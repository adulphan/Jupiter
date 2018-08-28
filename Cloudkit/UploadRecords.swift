//
//  UploadRecords.swift
//  Jupiter
//
//  Created by adulphan youngmod on 24/8/18.
//  Copyright © 2018 goldbac. All rights reserved.
//

import Foundation
import CloudKit


extension CKModifyRecordsOperation {
    
    open override func main() {
//        for operation in CloudKit.operationQueue.operations {
//            var deleted: [CKRecordID] = []
//            if let op = operation as? CKModifyRecordsOperation {
//                if let deletedIDs = op.recordIDsToDelete {
//                    deleted += deletedIDs
//                }
//            }
//            recordsToSave = recordsToSave?.filter({ (record) -> Bool in
//                !deleted.contains(record.recordID)
//            })
//        }
//        
        super.main()
    }
    
}

extension RecordExchange {
    
    func createUploadOperation() -> CKModifyRecordsOperation {

        let operation = CKModifyRecordsOperation(recordsToSave: outgoingSaveRecords, recordIDsToDelete: outgoingDeleteRecordIDs)
        operation.savePolicy = .changedKeys
        operation.database = CloudKit.privateDatabase
        operation.name = "uploadOperation"
        operation.modifyRecordsCompletionBlock = { (records, recordIDs, error) in
            if let err = error {
                print(err)
            }
            for record in records! {
                print("\(record.recordID.recordName) is saved on Cloud")
            }
            
            for id in recordIDs! {
                print("\(id.recordName) is deleted from Cloud")
            }

            print("Upload finished: \(self.downloadOperation.operationID)", ", date: ",Date().description)
            let operationQueue = CloudKit.operationQueue
            print("operationQueue count: ",operationQueue.operations.count)
            DispatchQueue.main.sync { self.printOutCoreData() }
            //self.printOutCoreData()
        }
        
        return operation
    }
    
    func createRefreshTokenOperation() -> CKFetchRecordZoneChangesOperation {
        let operation = CKFetchRecordZoneChangesOperation(recordZoneIDs: [CloudKit.financialDataZoneID], optionsByRecordZoneID: nil)
        operation.database = CloudKit.privateDatabase
        operation.recordZoneFetchCompletionBlock = { (zoneId, changeToken, _, _, error) in
            print("Refresh finished: \(self.downloadOperation.operationID)", ", date: ",Date().description)
            if let err = error { print(err) }
            let operationQueue = CloudKit.operationQueue
            
            let refreshIndex = operationQueue.operations.index(where: { (opertion) -> Bool in
                operation.operationID == self.refrechToken.operationID
            })
            
            print("operationQueue count: ",operationQueue.operations.count)
            print("refreshIndex: ",refreshIndex ?? "nil")
            
            UserDefaults.standard.financialDataChangeToken = changeToken
            
            DispatchQueue.main.sync { self.printOutCoreData() }
            guard refreshIndex != operationQueue.operations.count-1 else {
                print("Batch end here")
                return
            }
   
        }
        return operation
    }
    
}






