//
//  UploadOperation.swift
//  Jupiter
//
//  Created by adulphan youngmod on 27/8/18.
//  Copyright © 2018 goldbac. All rights reserved.
//

import Foundation
import CloudKit

extension OperationCloudKit {
    
    func uploadRecords(completion: @escaping (Error?) -> Void) {
        let operation = CKModifyRecordsOperation()
        operation.database = CloudKit.privateDatabase
        operation.name = "uploadFinancialData: \(Date().description)"
        operation.savePolicy = .ifServerRecordUnchanged
        operation.recordsToSave = CloudKit.outgoingSaveRecords
        operation.recordIDsToDelete = CloudKit.outgoingDeleteRecordIDs
        operation.modifyRecordsCompletionBlock = { (savedRecords, deletedIDs, error) in
            if let error = error as? CKError {
                
                if error.code == CKError.partialFailure {
                    let partialError = error.partialErrorsByItemID
                    let dictionary =  partialError as! [CKRecordID : CKError]
                    for dict in dictionary {
                        if dict.value.code == CKError.serverRecordChanged {
                            print("\(dict.key.recordName) is NOT saved on Cloud: ServerRecordChange - coreData will update in the next fetch")
                        } else if dict.value.code == CKError.unknownItem {
                            print("\(dict.key.recordName) is NOT saved on Cloud: UnknownItem (mostlikely deleted) - coreData will update in the next fetch")
                        } else if dict.value.code == CKError.batchRequestFailed {
                            print("\(dict.key.recordName) is NOT saved on Cloud: Batch Request failure")
                        } else {
                            
                            print("\(dict.key.recordName) : \(dict.value)")
                        }
                    }
                } else {
                    
                    print(error)
                }
            } else {
                
                print(error.debugDescription)
            }
            
            for record in savedRecords! {
                
                print(record.allKeys())
                
                print("\(record.recordID.recordName) is saved on Cloud")
                
                let data = NSMutableData()
                let archiver = NSKeyedArchiver(forWritingWith: data)
                archiver.requiresSecureCoding = true
                record.encodeSystemFields(with: archiver)
                archiver.finishEncoding()
                
                if let object = self.ExistingObject(recordName: record.recordID.recordName) {
                    object.setValue(data, forKey: "recordData")
                }

            }
    
            for id in deletedIDs! {
                print("\(id.recordName) is deleted from Cloud")
            }
            
            CloudKit.isDownloadingFromCloudKit = true
            self.saveCoreData()
            CloudKit.isDownloadingFromCloudKit = false
            
            print("Completed: \(operation.name!)")
            completion(error)
        }
        
        let operationQueue = CloudKit.operationQueue
        if let lastOperation = operationQueue.operations.last {
            operation.addDependency(lastOperation)
        }

        operationQueue.addOperations([operation], waitUntilFinished: false)
        
    }
    
    
}











