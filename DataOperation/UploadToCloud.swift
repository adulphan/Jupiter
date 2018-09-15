////
////  UploadToCloud.swift
////  Jupiter
////
////  Created by adulphan youngmod on 14/9/18.
////  Copyright © 2018 goldbac. All rights reserved.
////
//
//import Foundation
//import CloudKit
//
//
//class UploadOperation: CKModifyRecordsOperation {
//    
//    override func main() {
//        let maxRecords: Int = 200
//        var recordNames: Set<String> = Set()
//        let count = CloudKit.pendingRecordNames.count
//        if count < maxRecords {
//            recordNames = CloudKit.pendingRecordNames
//            CloudKit.pendingRecordNames.removeAll()
//        } else {
//            recordNames = Set(CloudKit.pendingRecordNames.dropFirst(count-maxRecords))
//            CloudKit.pendingRecordNames = CloudKit.pendingRecordNames.subtracting(recordNames)
//            print("Cut down to 100")
//        }
//        
//        var records: [CKRecord] = []
//        var recordIDs: [CKRecordID] = []
//        cloudContext.refreshAllObjects()
//        
//        for recordName in recordNames {
//            if let object = cloudContext.existingObject(recordName: recordName) {
//                if let record = object.recordToUpload() {
//                    records.append(record)
//                } else {
//                    CloudKit.nilDataCount += 1
//                    print("Found record but data is nil, count: ", CloudKit.nilDataCount)
//                    let recordID = CKRecordID(recordName: recordName, zoneID: CloudKit.financialDataZoneID)
//                    recordIDs.append(recordID)
//                }
//                
//            } else {
//                let recordID = CKRecordID(recordName: recordName, zoneID: CloudKit.financialDataZoneID)
//                recordIDs.append(recordID)
//            }
//        }
//        
//        recordsToSave = records
//        recordIDsToDelete = recordIDs
//        name = "uploadOperation"
//        
//        
//        modifyRecordsCompletionBlock = {(savedRecords, deletedIDs, error) in
//            
//            if let error = error as? CKError {
//                if let retry = error.retryAfterSeconds {
//                    self.handleRetryable(retryAfterSeconds: retry)
//                } else if error.code == CKError.operationCancelled {
//                    print("New writeOperation get priority")
//                } else {
//                    print(error)
//                }
//                
//            }
//            
//            for recordID in deletedIDs! { print("\(recordID.recordName) is deleted from Cloud") }
//            for record in savedRecords! { print("\(record.recordID.recordName) is saved on Cloud") }
//            print("--------------------------------------------------")
//            for record in savedRecords! {
//                if let object = cloudContext.existingObject(recordName: record.recordID.recordName) {
//                    object.updateRecordDataBy(record: record)
//                }
//            }
//            
//        }
//        
//        super.main()
//    }
//    
//    override func cancel() {
//        let pendingNames = recordsToSave!.map{$0.recordID.recordName} + recordIDsToDelete!.map{$0.recordName}
//        CloudKit.pendingRecordNames = CloudKit.pendingRecordNames.union(pendingNames)
//        super.cancel()
//    }
//    
//
//}
//
//extension OperationCloudKit {
//
//    func uploadToCloud() {
//        let operation = UploadOperation()
//        
//        operation.modifyRecordsCompletionBlock = { (savedRecords, deletedIDs, error) in
//            
//            if let error = error as? CKError {
//                if let retry = error.retryAfterSeconds {
//                    self.handleRetryable(retryAfterSeconds: retry)
//                }
//                print(error)
//            }
//
//            for recordID in deletedIDs! {
//                print("\(recordID.recordName) is deleted from Cloud")
//            }
//
//            for record in savedRecords! {
//                print("\(record.recordID.recordName) is saved on Cloud")
//            }
//            
//            for record in savedRecords! {
//                if let object = cloudContext.existingObject(recordName: record.recordID.recordName) {
//                    object.updateRecordDataBy(record: record)
//                }
//            }
//            
//            cloudContext.processPendingChanges()
//            print("------------------------------")
//            
//            if CloudKit.pendingRecordNames.isEmpty {
//                cloudContext.printSystemField()
//                print("------------------------------")
//                print("End session, nilDatacount: ", CloudKit.nilDataCount)
//                
//            } 
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
//    func handleRetryable(retryAfterSeconds: TimeInterval) {
//
//        print("")
//        print("Suspend operationQueue: retryable error - waiting \(retryAfterSeconds + 5) seconds to continue")
//        print("")
//        CloudKit.operationQueue.isSuspended = true
//        
//        DispatchQueue.main.asyncAfter(deadline: .now() + retryAfterSeconds + 5) {
//            let operation = CloudKit.operationQueue.operations.first!
//            operation.cancel()
//            CloudKit.operationQueue.isSuspended = false
//            print("")
//            print("Continue operationQueue")
//            print("")
//
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
