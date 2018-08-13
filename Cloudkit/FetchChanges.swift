//
//  FetchChanges.swift
//  Jupiter
//
//  Created by adulphan youngmod on 13/8/18.
//  Copyright © 2018 goldbac. All rights reserved.
//

import Foundation
import CloudKit
import CoreData


protocol FetchCloudKit: AccessCoreData {
    
}

extension CloudKit: AccessCoreData {
    
    func fetchChanges(completion: @escaping () -> Void) {
        
        CloudKit.isFetchingFromCloudKit = true
        
        let option = CKFetchRecordZoneChangesOptions()
        UserDefaults.standard.zoneChangeToken = nil
        option.previousServerChangeToken = UserDefaults.standard.zoneChangeToken
        let operation = CKFetchRecordZoneChangesOperation(recordZoneIDs: [CloudKit.personalZoneID], optionsByRecordZoneID: [CloudKit.personalZoneID:option])

        operation.recordChangedBlock = { (record) in
            
            DispatchQueue.main.sync {
                self.updateOrSaveToCoreData(record: record)
            }
            
        }
        
        operation.recordWithIDWasDeletedBlock = { (recordID, _) in
            
            
            DispatchQueue.main.sync {
                if let victim = self.ExistingCompanyData(recordID: recordID.recordName) {
                    self.deleteCoreData(object: victim)
                    print("Company deleted: ", recordID.recordName)
                }
                
                if let victim = self.ExistingAccountData(recordID: recordID.recordName) {
                    self.deleteCoreData(object: victim)
                    print("Account deleted: ", recordID.recordName)
                }
            }

        }
        
        operation.recordZoneFetchCompletionBlock = { (zoneId, changeToken, _, _, error) in

            if let error = error {
                print("Error fetching zone changes : ", error)
                return
            }

            UserDefaults.standard.zoneChangeToken = changeToken
            print("From recordZoneFetchCompletionBlock : token updated")
        }
        
        CloudKit.database.add(operation)
    }

    
    func updateOrSaveToCoreData(record: CKRecord) {
        
        switch record.recordType {
        case CloudKit.recordType.account.rawValue:
            if let account = self.ExistingAccountData(recordID: record.recordID.recordName) {
                account.updateBy(record: record)
                print("Account updated: ", record.recordID.recordName)
            } else {
                let account = AccountData(context: CoreData.context)
                account.updateBy(record: record)
                print("Account created: ", record.recordID.recordName)
            }
        case CloudKit.recordType.company.rawValue:
            if let company = self.ExistingCompanyData(recordID: record.recordID.recordName) {
                company.updateBy(record: record)
                print("Company updated: ", record.recordID.recordName)
            } else {
                let company = CompanyData(context: CoreData.context)
                company.updateBy(record: record)
                print("Company created: ", record.recordID.recordName)
            }
        default:
            print("Default")
        }
        
    }
    
    
    
}
