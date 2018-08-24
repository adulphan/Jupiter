//
//  UploadRecords.swift
//  Jupiter
//
//  Created by adulphan youngmod on 24/8/18.
//  Copyright © 2018 goldbac. All rights reserved.
//

import Foundation
import CloudKit

extension RecordExchange {
    
    var uploadOperation: CKModifyRecordsOperation {
        
        let operation = CKModifyRecordsOperation(recordsToSave: outgoingSaveRecords, recordIDsToDelete: outgoingDeleteRecordIDs)
        operation.savePolicy = .changedKeys
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
            
            print("finished upload: \(self.uploadOperation.operationID)")
            DispatchQueue.main.sync { self.printOutCoreData() }
        }
        
        return operation
    }
    
    
}
