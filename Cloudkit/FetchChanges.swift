//
//  FetchChanges.swift
//  Jupiter
//
//  Created by adulphan youngmod on 13/8/18.
//  Copyright © 2018 goldbac. All rights reserved.
//

import Foundation
import CloudKit

protocol FetchCloudKit: AccessCoreData {
    
    
}

extension FetchCloudKit  {
    
    func fetchChangesFromCloudKit(completion: @escaping () -> Void) {
        
        guard Application.connectedToCloudKit else {
            print("No fetching: CloudKit is disabled")
            return
        }
        
        let option = CKFetchRecordZoneChangesOptions()
        //UserDefaults.standard.zoneChangeToken = nil
        option.previousServerChangeToken = UserDefaults.standard.financialDataChangeToken
        let operation = CKFetchRecordZoneChangesOperation(recordZoneIDs: [CloudKit.financialDataZoneID], optionsByRecordZoneID: [CloudKit.financialDataZoneID:option])

        operation.recordChangedBlock = { (record) in
            if record.recordType == CloudKit.recordType.company.rawValue {
                CloudKit.companyRecordToSave.append(record)
            }
            
            if record.recordType == CloudKit.recordType.account.rawValue {
                CloudKit.accountRecordToSave.append(record)
            }

        }
        
        operation.recordWithIDWasDeletedBlock = { (recordID, text) in
            CloudKit.recordIDToDelete.append(recordID)
            
        }

        operation.recordZoneFetchCompletionBlock = { (zoneId, changeToken, _, _, error) in
            if let error = error {
                print("Error fetching changes : ", error)
                self.clearCachedRecords()
                return
            }

            DispatchQueue.main.sync {
                self.pushNewFetchToCoreData()
                UserDefaults.standard.financialDataChangeToken = changeToken
                print("From recordZoneFetchCompletionBlock : token updated")
                completion()
            }
        }
        
        CloudKit.privateDatabase.add(operation)
    }

    func pushNewFetchToCoreData() {
        
        CloudKit.isFetchingFromCloudKit = true
        
        for recordID in CloudKit.recordIDToDelete {
            if let object = ExistingCompany(recordID: recordID.recordName) {
                deleteCoreData(object: object)
            }
            
            if let object = ExistingAccount(recordID: recordID.recordName) {
                deleteCoreData(object: object)
            }
            
        }
        
        for record in CloudKit.companyRecordToSave {
            if let object = ExistingCompany(recordID: record.recordID.recordName) {
                object.updateBy(record: record)
            } else {
                let object = Company(context: CoreData.context)
                object.updateBy(record: record)
            }
        }
        
        saveCoreData()
        
        for record in CloudKit.accountRecordToSave {
            if let object = ExistingAccount(recordID: record.recordID.recordName) {
                object.updateBy(record: record)
            } else {
                let object = Account(context: CoreData.context)
                object.updateBy(record: record)
            }
        }
        
        saveCoreData()
        clearCachedRecords()
        CloudKit.isFetchingFromCloudKit = false
        
    }
    
    func clearCachedRecords() {
        
        CloudKit.companyRecordToSave = []
        CloudKit.accountRecordToSave = []
        CloudKit.recordIDToDelete = []
        
    }
    
    
}






