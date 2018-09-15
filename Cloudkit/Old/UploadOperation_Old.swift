////
////  UploadOperation.swift
////  Jupiter
////
////  Created by adulphan youngmod on 27/8/18.
////  Copyright © 2018 goldbac. All rights reserved.
////
//
//import Foundation
//import CloudKit
//import CoreData
//
//class CKUPloadOperation: CKModifyRecordsOperation {
//    
//    override init() {
//        super.init()
//        
//        database = CloudKit.privateDatabase
//        name = "uploadFinancialData"
//        savePolicy = .ifServerRecordUnchanged
//        isAtomic = false
//        qualityOfService = .background
//        
//    }
//    
////    var allFetchedPendings: [PendingUpload] = CloudKit.pendingUpload
////    var noDuplicate: [PendingUpload] = []
//    
//    var pendingSaveRecords: [CKRecord] {
//        
//        let savingPendings = noDuplicate.filter { (pending) -> Bool in
//            pending.delete == false
//        }
//
//        return savingPendings.map{$0.record!}
//
//    }
//
//    var pendingDeleteRecords: [CKRecord] {
//        
//        let deletingPendings = noDuplicate.filter { (pending) -> Bool in
//            pending.delete == true
//        }
//        
//        return deletingPendings.map{$0.record!}
//
//    }
//    
//    var pendingDeleteRecordIDs: [CKRecordID] {
//        return pendingDeleteRecords.map{$0.recordID}
//    }
//    
//    func removeDuplicates() {
//        var newArray: [PendingUpload] = []
//        let all = allFetchedPendings
//        for pending in all {
//            let index = newArray.index { (object) -> Bool in
//                object.recordID.recordName == pending.recordID.recordName
//            }
//            if let index = index {
//                if pending.date! > newArray[index].date! {
//                    newArray[index] = pending
//                }
//            } else {
//                newArray.append(pending)
//            }
//
//        }
//        noDuplicate = newArray
//    }
//    
//}
//
//extension OperationCloudKit {
//    
//    func uploadRecords() {
//        
//        let operation = CKUPloadOperation()
//        operation.removeDuplicates()
//        operation.recordsToSave = operation.pendingSaveRecords
//        operation.recordIDsToDelete = operation.pendingDeleteRecordIDs
//        
//        guard !operation.allFetchedPendings.isEmpty else { return }
//        print("CoreDataNotification: uploading to CloudKit")
//        
//        operation.modifyRecordsCompletionBlock = { (savedRecords, deletedIDs, error) in
//    
//            self.handle(error: error)
//
//            for id in deletedIDs! {
//                print("\(id.recordName) is deleted from Cloud")
//            }
//            
//            for record in savedRecords! {
//                print("\(record.recordID.recordName) is saved on Cloud")
//            }
//            
//            mainContext.performAndWait {
//                for record in savedRecords! {
//                    self.updateLocalRecordByServer(record: record)
//                    mainContext.processPendingChanges()
//                }
//            }
//            
//            pendingContext.delete(objects: operation.allFetchedPendings)
//            self.updatePendingRecordByServer(records: savedRecords!)
//            pendingContext.processPendingChanges()
//            print("Completed: \(operation.name!)")
//            
//            guard CloudKit.hasPendingUploads else {
//
//                DispatchQueue.main.sync { self.saveCoreData(sendToCloudKit: false) }
//                pendingContext.performAndWait { pendingContext.saveData() }
//                self.printOutCoreData(includeMonths: false, transactionDetails: false)
//                return
//            }
//            self.uploadRecords()
//
//        }
//        
//        let operationQueue = CloudKit.operationQueue
//        if let lastOperation = operationQueue.operations.last {
//            operation.addDependency(lastOperation)
//        }
//        operationQueue.addOperations([operation], waitUntilFinished: false)
//        
//    }
//    
//    private func handle(error: Error?) {
//        
//        guard let error = error else { return }
//
//        if let error = error as? CKError {
//            if error.code == CKError.partialFailure {
//                handlePartialFailure(error: error)
//                return
//            }
//            
//            if let retryAfterSeconds = error.retryAfterSeconds {
//                print(error)
//                handleRetryable(retryAfterSeconds: retryAfterSeconds)
//                return
//                
//            } else {
//                print(error)
//                print("")
//                print("Serious error: not partial error, not invalid-argument error, not retryable....")
//                print("Records return to pending state")
//                print("")
//
//                return
//            }
//            
//        } else {
//            
//            print(error.localizedDescription)
//            
//        }
//    }
//    
//    private func handlePartialFailure(error: CKError) {
//        
//        let partialErrorsByItemID = error.partialErrorsByItemID
//        let dictionary =  partialErrorsByItemID as! [CKRecordID : CKError]
//        for dict in dictionary {
//            if dict.value.code == CKError.serverRecordChanged {
//                print("\(dict.key.recordName) is NOT saved on Cloud: ServerRecordChange")
//                
//                let serverRecord = dict.value.serverRecord!
//                var clientRecord = dict.value.clientRecord!
//                
//                let serverDate = serverRecord.value(forKey: "modifiedLocal") as! Date
//                let clientDate = clientRecord.value(forKey: "modifiedLocal") as! Date
//                
//                if clientDate > serverDate {
//                    print("Retry with client record")
//                    clientRecord = clientRecord.updateSystemDataBy(record: serverRecord)
//                    let pending = PendingUpload(record: clientRecord, isDeleted: false)
//                    pendingContext.insert(pending)
//                    
//                } else {
//                    let recordName = serverRecord.recordID.recordName
//                    if let object = ExistingObject(recordName: recordName) {
//                        print("Retrieve server record")
//                        object.downloadfrom(record: serverRecord)
//                    }
//                }
//                
//            } else if dict.value.code == CKError.unknownItem {
//                print("\(dict.key.recordName) is NOT saved on Cloud: UnknownItem (mostlikely deleted) - coreData will delete object")
//                if let object = ExistingObject(recordName: dict.key.recordName) {
//                    CoreData.mainContext.delete(object)
//                }
//                
//            } else if dict.value.code == CKError.batchRequestFailed {
//                print("\(dict.key.recordName) is NOT saved on Cloud: Batch Request failure - operation is atomic")
//            } else {
//                
//                print("\(dict.key.recordName) : \(dict.value)")
//            }
//        }
//        
//    }
//    
//    private func handleRetryable(retryAfterSeconds: TimeInterval) {
//        
//        print("")
//        print("Suspend operationQueue: retryable error - waiting \(retryAfterSeconds + 5) seconds to continue")
//        print("")
//        CloudKit.operationQueue.isSuspended = true
//        
//        DispatchQueue.main.asyncAfter(deadline: .now() + retryAfterSeconds + 5) {
//            let operation = CloudKit.operationQueue.operations.first!
//            operation.cancel()
//            self.uploadRecords()
//            CloudKit.operationQueue.isSuspended = false
//            print("")
//            print("Continue operationQueue")
//            print("")
//            
//        }
//
//    }
//    
//    private func updateLocalRecordByServer(record: CKRecord) {
//        
//        if let object = self.ExistingObject(recordName: record.recordID.recordName) {
//            let data = NSMutableData()
//            let archiver = NSKeyedArchiver(forWritingWith: data)
//            archiver.requiresSecureCoding = true
//            record.encodeSystemFields(with: archiver)
//            archiver.finishEncoding()            
//            object.setValue(data, forKey: "recordData")
//        }
//        
//    }
//    
//    private func updatePendingRecordByServer(records: [CKRecord]) {
//
//        pendingContext.performAndWait {
//            let pendingUploads = CloudKit.pendingUpload
//            for record in records {
//                let withSameRecords = pendingUploads.filter { (pending) -> Bool in
//                    pending.recordID.recordName == record.recordID.recordName
//                }
//                
//                for pending in withSameRecords {
//                    pending.record = pending.record?.updateSystemDataBy(record: record)
//                }
//            }
//            pendingContext.processPendingChanges()
//        }
//
//    }
//    
//}
//
//
//
//
//
//
//
//
//
//
//
