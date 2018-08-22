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
        
        guard CloudKit.hasDataToUpload else { return }
        let recordToSave = CloudKit.recordsToSaveToCloudKit
        let recordIDToDelete = CloudKit.recordIDsToDeleteFromCloudKit
        
        print(recordToSave.map{$0.recordType})
        print(recordToSave.map{$0.recordID.recordName})
        
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
        
//        let option = CKFetchRecordZoneChangesOptions()
//        option.previousServerChangeToken = UserDefaults.standard.financialDataChangeToken
        let operationGetNewToken = CKFetchRecordZoneChangesOperation(recordZoneIDs: [CloudKit.financialDataZoneID], optionsByRecordZoneID: nil)
        operationGetNewToken.recordZoneFetchCompletionBlock = { (zoneId, changeToken, _, _, error) in
            if let err = error { print(err) }
            UserDefaults.standard.financialDataChangeToken = changeToken
            print("get new token!!")
        }
        
        operationGetNewToken.addDependency(operation)
        CloudKit.privateDatabase.add(operationGetNewToken)

    }
    
    
}
