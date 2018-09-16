//
//  UploadToCloud.swift
//  Jupiter
//
//  Created by adulphan youngmod on 14/9/18.
//  Copyright © 2018 goldbac. All rights reserved.
//

import Foundation
import CloudKit


class UploadOperation: CKModifyRecordsOperation {
    
    override func main() {
        name = "uploadOperation"
        setupRecords()
        super.main()
    }
    
    override func cancel() {
        if let recordsTosave = recordsToSave, let recordIDsTodelete = recordIDsToDelete {
            let returningRecordNames = recordsTosave.map{$0.recordID.recordName} + recordIDsTodelete.map{$0.recordName}
            CloudKit.pendingRecordNames = CloudKit.pendingRecordNames.union(returningRecordNames)
        }
        super.cancel()
    }

    private func setupRecords() {
        
        let count = CloudKit.pendingRecordNames.count
        let maxRecords = 300
        var recordNames: Set<String> = Set()
        if count <= maxRecords {
            recordNames = CloudKit.pendingRecordNames
            CloudKit.pendingRecordNames.removeAll()
        } else {
            recordNames = Set(CloudKit.pendingRecordNames.dropLast(count - maxRecords))
            CloudKit.pendingRecordNames = CloudKit.pendingRecordNames.subtracting(recordNames)
        }
        
        var records: [CKRecord] = []
        var recordIDs: [CKRecordID] = []
        
        writeContext.performAndWait {
            cloudContext.refreshAllObjects()
            for recordName in recordNames {
                if let object = cloudContext.existingObject(recordName: recordName) {
                    if let record = object.recordToUpload() {
                        records.append(record)
                    } else {
                        CloudKit.nilDataCount += 1
                        print("Found record but data is nil, count: ", CloudKit.nilDataCount)
                        let recordID = CKRecordID(recordName: recordName, zoneID: CloudKit.financialDataZoneID)
                        recordIDs.append(recordID)
                    }
                    
                } else {
                    let recordID = CKRecordID(recordName: recordName, zoneID: CloudKit.financialDataZoneID)
                    recordIDs.append(recordID)
                }
            }
        }
        
        recordsToSave = records
        recordIDsToDelete = recordIDs
        
    }
    
}

extension OperationCloudKit {

    func uploadToCloud() {
        let operation = UploadOperation()
        operation.modifyRecordsCompletionBlock = { (savedRecords, deletedIDs, error) in
            
            if let error = error as? CKError {
                print(error)
                if let retry = error.retryAfterSeconds {
                    self.handleRetryable(retryAfterSeconds: retry)
                }
            }

            for recordID in deletedIDs! { print("\(recordID.recordName) is deleted from Cloud") }
            for record in savedRecords! { print("\(record.recordID.recordName) is saved on Cloud") }
            
            self.updateChageTag(by: savedRecords!)
            
            print("------------------------------")
            
            if CloudKit.pendingRecordNames.count != 0 {
                self.uploadToCloud()
            } else {
                
                cloudContext.printSystemField()
                print("------------------------------")
                print("End session, nilDatacount: ", CloudKit.nilDataCount)
            }
            

        }
        
        let operationQueue = CloudKit.operationQueue
        if let lastOperation = operationQueue.operations.last {
            operation.addDependency(lastOperation)
        }
        operationQueue.addOperations([operation], waitUntilFinished: false)

    }
    
    private func handleRetryable(retryAfterSeconds: TimeInterval) {

        print("")
        print("Suspend operationQueue: retryable error - waiting \(retryAfterSeconds + 5) seconds to continue")
        print("")
        CloudKit.operationQueue.isSuspended = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + retryAfterSeconds + 5) {
            self.uploadToCloud()
            CloudKit.operationQueue.isSuspended = false
            print("")
            print("Continue operationQueue")
            print("")

        }

    }
    
    private func updateChageTag(by: [CKRecord]) {
        writeContext.performAndWait {
            for record in by {
                if let object = cloudContext.existingObject(recordName: record.recordID.recordName) {
                    object.updateRecordDataBy(record: record)
                }
            }
            cloudContext.processPendingChanges()
        }
        
    }

}









