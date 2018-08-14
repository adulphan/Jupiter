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
        
        guard CloudKit.isEnable else {
            print("Not fetching: CloudKit is disabled")
            return
        }
        
        let option = CKFetchRecordZoneChangesOptions()
        //UserDefaults.standard.zoneChangeToken = nil
        option.previousServerChangeToken = UserDefaults.standard.zoneChangeToken
        let operation = CKFetchRecordZoneChangesOperation(recordZoneIDs: [CloudKit.personalZoneID], optionsByRecordZoneID: [CloudKit.personalZoneID:option])

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
                UserDefaults.standard.zoneChangeToken = changeToken
                print("From recordZoneFetchCompletionBlock : token updated")
                completion()
            }
        }
        
        CloudKit.database.add(operation)
    }

    func pushNewFetchToCoreData() {
        
        CloudKit.isFetchingFromCloudKit = true
        
        for recordID in CloudKit.recordIDToDelete {
            if let object = ExistingCompanyData(recordID: recordID.recordName) {
                deleteCoreData(object: object)
            }
            
            if let object = ExistingAccountData(recordID: recordID.recordName) {
                deleteCoreData(object: object)
            }
            
        }
        
        for record in CloudKit.companyRecordToSave {
            if let object = ExistingCompanyData(recordID: record.recordID.recordName) {
                object.updateBy(record: record)
            } else {
                let object = CompanyData(context: CoreData.context)
                object.updateBy(record: record)
            }
        }
        
        saveCoreData()
        
        for record in CloudKit.accountRecordToSave {
            if let object = ExistingAccountData(recordID: record.recordID.recordName) {
                object.updateBy(record: record)
            } else {
                let object = AccountData(context: CoreData.context)
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






