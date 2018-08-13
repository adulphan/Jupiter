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


protocol FetchCloudKit: AccessCoreData, CloudkitConnect {
    
}

class Fetch_CloudKit: AccessCoreData, CloudkitConnect {
    
    func fetchChanges(databaseTokenKey: String, zoneIDs: [CKRecordZoneID], completion: @escaping () -> Void) {

        let option = CKFetchRecordZoneChangesOptions()
        option.previousServerChangeToken = UserDefaults.standard.zoneChangeToken
        let operation = CKFetchRecordZoneChangesOperation(recordZoneIDs: [personalZoneID], optionsByRecordZoneID: [personalZoneID:option])

        operation.recordChangedBlock = { (record) in
            
            
//            reloadCompanyData()
//            let account = ExistingAccountData(recordID: "")
//
//            let fetchRequest: NSFetchRequest<AccountData> = AccountData.fetchRequest()
//            let predicate = NSPredicate(format: "recordID == %@", record.recordID.recordName)
//            fetchRequest.predicate = predicate
            
//            do {
//                if let account = try CoreData.context.fetch(fetchRequest).first {
//                    account.endBalance = (record.value(forKey: "endBalance") as? Double) ?? 0
//
//                    account.imageRecordID = record.value(forKey: "imageRecordID") as? String
//                    account.modified = record.modificationDate
//                    account.name = record.value(forKey: "name") as? String
//                    account.type = (record.value(forKey: "type") as? Int16) ?? 0
//                } else {
//                    let account = Account(record: record)
//                    account?.addToCoreData(recordID: record.recordID.recordName)
//
//                }
//
//            } catch  {
//                print(error)
//            }
            
            print("Record changed:", record.recordID.recordName)
            
        }
        
        operation.recordWithIDWasDeletedBlock = { (recordId, text) in
            
            let fetchRequest: NSFetchRequest<AccountData> = AccountData.fetchRequest()
            let predicate = NSPredicate(format: "recordID == %@", recordId.recordName)
            fetchRequest.predicate = predicate
            
//            do {
//                if let account = try CoreData.shared.context.fetch(fetchRequest).first {
//                    CoreData.shared.context.delete(account)
//                    print("Record deleted:", recordId.recordName)
//                    print(text)
//                }
//            } catch  {
//                print(error)
//            }
            
            //let account = try context.fetch(fetchRequest)
            //            let sortDescriptor = NSSortDescriptor(key: "modified", ascending: false)
            //            fetchRequest.sortDescriptors = [sortDescriptor]
            
            
            
        }
        
        operation.recordZoneChangeTokensUpdatedBlock = { (zoneId, token, data) in
            // Flush record changes and deletions for this zone to disk
            // Write this new zone change token to disk
            UserDefaults.standard.zoneChangeToken = token
            print("From recordZoneChangeTokensUpdatedBlock : \(token?.description ?? "No Token")")
        }
        
        operation.recordZoneFetchCompletionBlock = { (zoneId, changeToken, _, _, error) in
            if let error = error {
                print("Error fetching zone changes for \(databaseTokenKey) database:", error)
                return
            }
            
            // Flush record changes and deletions for this zone to disk
            // Write this new zone change token to disk
            UserDefaults.standard.zoneChangeToken = changeToken
            print("From recordZoneFetchCompletionBlock : \(changeToken?.description ?? "No Token")")
        }
        
        operation.fetchRecordZoneChangesCompletionBlock = { (error) in
            if let error = error {
                print("Error fetching zone changes for \(databaseTokenKey) database:", error)
            }
            completion()
        }
        
        database.add(operation)
    }
    
    
}
