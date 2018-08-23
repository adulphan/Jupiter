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
    
    func uploadToCloudKit(completion: @escaping () -> Void) {
        
        guard CloudKit.hasDataToUpload else { completion(); return }
        let recordToSave = CloudKit.recordsToSaveToCloudKit
        let recordIDToDelete = CloudKit.recordIDsToDeleteFromCloudKit

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
            self.operationRefreshToken(dependency: operation) {
                completion()
            }
            
        }
        
        CloudKit.privateDatabase.add(operation)



    }
    
    func operationRefreshToken(dependency: CKOperation? ,completion: @escaping () -> Void) {
        let operationGetNewToken = CKFetchRecordZoneChangesOperation(recordZoneIDs: [CloudKit.financialDataZoneID], optionsByRecordZoneID: nil)
        operationGetNewToken.recordZoneFetchCompletionBlock = { (zoneId, changeToken, _, _, error) in
            if let err = error { print(err) }
            UserDefaults.standard.financialDataChangeToken = changeToken
            print("get new token!!")
            completion()
        }
        if let operation = dependency {
            operationGetNewToken.addDependency(operation)
        }
        
        CloudKit.privateDatabase.add(operationGetNewToken)
    }
    
    
}
