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

    var uploadOperation: CKModifyRecordsOperation {

        let operation = CKModifyRecordsOperation(recordsToSave: CloudKit.outgoingSaveRecords, recordIDsToDelete: CloudKit.outgoingDeleteRecordIDs)
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
            
            CloudKit.outgoingSaveRecords = []
            CloudKit.outgoingDeleteRecordIDs = []
            
        }
        
        return operation
    }
    
    func uploadToCloudKit(completion: @escaping () -> Void) {
        
        guard CloudKit.hasOutgoings else { completion(); return }
        let recordToSave = CloudKit.outgoingSaveRecords
        let recordIDToDelete = CloudKit.outgoingDeleteRecordIDs

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
            
            CloudKit.outgoingSaveRecords = []
            CloudKit.outgoingDeleteRecordIDs = []
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
