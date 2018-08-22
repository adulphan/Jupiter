//
//  UploadToCloudKit.swift
//  Jupiter
//
//  Created by adulphan youngmod on 22/8/18.
//  Copyright © 2018 goldbac. All rights reserved.
//

import Foundation
import CloudKit

extension OperationCloudKit {
    
    func uploadToCloudKit() {
        
        let recordToSave = CloudKit.recordsToSaveToCloudKit
        let recordIDToDelete = CloudKit.recordIDsToDeleteFromCloudKit
        
        guard recordToSave.count != 0 || recordIDToDelete.count != 0 else { return }
        let operation = CKModifyRecordsOperation(recordsToSave: recordToSave, recordIDsToDelete: recordIDToDelete)
        operation.savePolicy = .changedKeys
        operation.modifyRecordsCompletionBlock = { (records, recordIDs, error) in
            if let err = error {
                print(err)
            }
            for record in records! {
                print("\(record.recordID.recordName) is saved")
            }
            
            for id in recordIDs! {
                print("\(id.recordName) is deleted")
            }
            CloudKit.recordsToSaveToCloudKit = []
            CloudKit.recordIDsToDeleteFromCloudKit = []
        }
        
        CloudKit.privateDatabase.add(operation)
        
    }
    
    
}
