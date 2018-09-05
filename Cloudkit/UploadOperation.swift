//
//  UploadOperation.swift
//  Jupiter
//
//  Created by adulphan youngmod on 27/8/18.
//  Copyright © 2018 goldbac. All rights reserved.
//

import Foundation
import CloudKit

class CKUPloadOperation: CKModifyRecordsOperation {
    
    override init() {
        super.init()
        
        database = CloudKit.privateDatabase
        name = "uploadFinancialData"
        savePolicy = .ifServerRecordUnchanged
        recordsToSave = CloudKit.outgoingSaveRecords
        recordIDsToDelete = CloudKit.outgoingDeleteRecordIDs
        isAtomic = false
        qualityOfService = .background
        
    }
    
    override func main() {
        CloudKit.outgoingSaveRecords = []
        CloudKit.outgoingDeleteRecordIDs = []        
        super.main()
    }
}

extension OperationCloudKit {
    
    func uploadRecords() {
        let operation = CKUPloadOperation()
        operation.modifyRecordsCompletionBlock = { (savedRecords, deletedIDs, error) in
            
            self.handle(error: error, operation: operation)
            for id in deletedIDs! {
                print("\(id.recordName) is deleted from Cloud")
            }
     
            for record in savedRecords! {

                print("\(record.recordID.recordName) is saved on Cloud")
                self.updateLocalRecordByServer(record: record)
                self.updatePendingRecordByServer(record: record)

            }
            
            self.saveCoreData(sendToCloudKit: false)
            print("Completed: \(operation.name!)")
            

            guard CloudKit.hasOutgoings else {
                print("No outgoing records")
                self.printOutCoreData(includeMonths: false, transactionDetails: false)
                return
            }
            self.uploadRecords()
        }
        
        let operationQueue = CloudKit.operationQueue
        if let lastOperation = operationQueue.operations.last {
            operation.addDependency(lastOperation)
        }
        operationQueue.addOperations([operation], waitUntilFinished: false)
        
    }
    
    private func handle(error: Error?, operation: CKModifyRecordsOperation) {
        
        guard let error = error else { return }

        if let error = error as? CKError {
            if error.code == CKError.partialFailure {
                handlePartialFailure(error: error)
                return
            }
            if error.code == CKError.invalidArguments {
                handleInvalidArgument(error: error)
                return
            }
            if let retryAfterSeconds = error.retryAfterSeconds {
                print(error)
                handleRetryable(retryAfterSeconds: retryAfterSeconds)
                return
                
            } else {
                print(error)
                print("")
                print("Serious error: not partial error, not invalid-argument error, not retryable....")
                print("Records return to pending state")
                print("")

                if let recordToSave = operation.recordsToSave {
                    CloudKit.outgoingSaveRecords.append(contentsOf: recordToSave)
                }
                
                if let recordIDsToDelete = operation.recordIDsToDelete {
                    CloudKit.outgoingDeleteRecordIDs.append(contentsOf: recordIDsToDelete)
                }

                return
            }
            
        } else {
            
            print(error.localizedDescription)
            
        }
    }
    
    private func handlePartialFailure(error: CKError) {
        
        let partialErrorsByItemID = error.partialErrorsByItemID
        let dictionary =  partialErrorsByItemID as! [CKRecordID : CKError]
        for dict in dictionary {
            if dict.value.code == CKError.serverRecordChanged {
                print("\(dict.key.recordName) is NOT saved on Cloud: ServerRecordChange - will retry with client record")
                let serverRecord = dict.value.serverRecord!
                var clientRecord = dict.value.clientRecord!
                
                let clientRecordInPending = CloudKit.outgoingSaveRecords.index { (rec) -> Bool in
                    rec.recordID.recordName == clientRecord.recordID.recordName
                }
                
                if let index = clientRecordInPending {
                    clientRecord = CloudKit.outgoingSaveRecords[index]
                    let mergedRecord = clientRecord.updateSystemDataBy(record: serverRecord)
                    CloudKit.outgoingSaveRecords[index] = mergedRecord
                    
                } else {
                    let mergedRecord = clientRecord.updateSystemDataBy(record: serverRecord)
                    CloudKit.outgoingSaveRecords.append(mergedRecord)
                }
                
            } else if dict.value.code == CKError.unknownItem {
                print("\(dict.key.recordName) is NOT saved on Cloud: UnknownItem (mostlikely deleted) - coreData will delete object")
                if let object = ExistingObject(recordName: dict.key.recordName) {
                    CoreData.context.delete(object)
                }
                
            } else if dict.value.code == CKError.batchRequestFailed {
                print("\(dict.key.recordName) is NOT saved on Cloud: Batch Request failure - operation is atomic")
            } else {
                
                print("\(dict.key.recordName) : \(dict.value)")
            }
        }
        
    }
    
    private func handleInvalidArgument(error: CKError) {
        
        let description = error.userInfo["CKErrorDescription"] as! String
        if description.lowercased().range(of:"save") != nil && description.lowercased().range(of:"delete") != nil {
            print("You can't save and delete the same record - will delete in the next batch")
            let operation = CloudKit.operationQueue.operations.first! as! CKModifyRecordsOperation
            var recordToSave = operation.recordsToSave!
            let recordIDsToDelete = operation.recordIDsToDelete!
            
            for recordID in recordIDsToDelete {
                let index = recordToSave.index { (rec) -> Bool in
                    rec.recordID.recordName == recordID.recordName
                }
                if let index = index {
                    recordToSave.remove(at: index)
                    print("Record in conflict: ", recordID.recordName)
                }
            }
            
            for record in recordToSave {
                let isContainInNextBatch = CloudKit.outgoingSaveRecords.map{$0.recordID.recordName}.contains(record.recordID.recordName) || CloudKit.outgoingDeleteRecordIDs.map{$0.recordName}.contains(record.recordID.recordName)
                if !isContainInNextBatch {
                    CloudKit.outgoingSaveRecords.append(record)
                }
            }
            
            CloudKit.outgoingDeleteRecordIDs.append(contentsOf: recordIDsToDelete)
        }
        
    }
    
    
    private func handleRetryable(retryAfterSeconds: TimeInterval) {
        
        let operation = CloudKit.operationQueue.operations.first! as! CKModifyRecordsOperation
        let recordToSave = operation.recordsToSave!
        let recordIDsToDelete = operation.recordIDsToDelete!
        
        for record in recordToSave {
            let isContainInNextBatch = CloudKit.outgoingSaveRecords.map{$0.recordID.recordName}.contains(record.recordID.recordName) || CloudKit.outgoingDeleteRecordIDs.map{$0.recordName}.contains(record.recordID.recordName)
            if !isContainInNextBatch {
                CloudKit.outgoingSaveRecords.append(record)
            }
        }
        CloudKit.outgoingDeleteRecordIDs.append(contentsOf: recordIDsToDelete)
        print("")
        print("Suspend operationQueue: retryable error - waiting \(retryAfterSeconds) seconds to continue")
        print("")
        CloudKit.operationQueue.isSuspended = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + retryAfterSeconds + 5) {
            CloudKit.operationQueue.isSuspended = false
            print("")
            print("Continue operationQueue")
            print("")
            
        }

    }
    
    private func updateLocalRecordByServer(record: CKRecord) {
        
        let data = NSMutableData()
        let archiver = NSKeyedArchiver(forWritingWith: data)
        archiver.requiresSecureCoding = true
        record.encodeSystemFields(with: archiver)
        archiver.finishEncoding()
        
        if let object = self.ExistingObject(recordName: record.recordID.recordName) {
            object.setValue(data, forKey: "recordData")
        }
        
    }
    
    private func updatePendingRecordByServer(record: CKRecord) {
        let pendingRecords = CloudKit.outgoingSaveRecords
        let index = pendingRecords.index(where: { (rec) -> Bool in
            rec.recordID.recordName == record.recordID.recordName
        })
        if let index = index {
            let pending = pendingRecords[index]
            CloudKit.outgoingSaveRecords[index] = pending.updateSystemDataBy(record: record)
        }
    
    }
    
//    private func updatePendingRecordsBy(serverRecords: [CKRecord]) {
//        guard serverRecords.count > 0 else { return }
//        let pendingRecords = CloudKit.outgoingSaveRecords
//        for i in 0...serverRecords.count-1 {
//            let record = serverRecords[i]
//            let index = pendingRecords.index { (rec) -> Bool in
//                rec.recordID.recordName == record.recordID.recordName
//            }
//            if let index = index {
//                let pending = pendingRecords[index]
//                CloudKit.outgoingSaveRecords[index] = pending.exportValuesTo(record: record)
//            }
//        }
//        
//    }
    
    
//    private func updateRecordInNextOperationByServer(record: CKRecord) {
//
//        if CloudKit.operationQueue.operations.count > 1 {
//            if let nextOperation = CloudKit.operationQueue.operations[1] as? CKModifyRecordsOperation {
//                let records = nextOperation.recordsToSave
//                let index = records?.index(where: { (rec) -> Bool in
//                    rec.recordID.recordName == record.recordID.recordName
//                })
//
//                if let records = records, let index = index {
//                    let updatedRecord = records[index].exportValuesTo(record: record)
//                    nextOperation.recordsToSave![index] = updatedRecord
//                }
//
//            }
//        }
//
//    }
    
}











