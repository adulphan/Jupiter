//
//  ViewRecordsInCLoudKit.swift
//  Jupiter
//
//  Created by adulphan youngmod on 1/9/18.
//  Copyright © 2018 goldbac. All rights reserved.
//

import Foundation
import CloudKit

extension OperationCloudKit {
    
    func viewRecordsInCloudKit() {
        
        let predicate = NSPredicate(value: true)
        print("")
        let companyQuery = CKQuery(recordType: "Company", predicate: predicate)
        CloudKit.privateDatabase.perform(companyQuery, inZoneWith: nil) { (records, error) in
            if error != nil { print(error!) }
            if records?.count != 0 {
                for record: CKRecord in records! {
                    print(record.recordType," : ",record.recordID.recordName)
                }
            } else {
                print("no company")
            }
            print("")
        }
        
        let accountQuery = CKQuery(recordType: "Account", predicate: predicate)
        CloudKit.privateDatabase.perform(accountQuery, inZoneWith: nil) { (records, error) in
            if error != nil { print(error!) }
            if records?.count != 0 {
                for record: CKRecord in records! {
                    print(record.recordType," : ",record.recordID.recordName)
                }
            } else {
                print("no account")
            }
            print("")
        }

        let transactionQuery = CKQuery(recordType: "Transaction", predicate: predicate)
        CloudKit.privateDatabase.perform(transactionQuery, inZoneWith: nil) { (records, error) in
            if error != nil { print(error!) }
            if records?.count != 0 {
                for record: CKRecord in records! {
                    print(record.recordType," : ",record.recordID.recordName)
                }
            } else {
                print("no transaction")
            }
            print("")
        }
        
    }
    
    func deleteAllRecords() {
        
        var companyRecords: [CKRecord] = []
        let predicate = NSPredicate(value: true)
        let companyQuery = CKQuery(recordType: "Company", predicate: predicate)
        
        let deleteOperation = CKModifyRecordsOperation()
        deleteOperation.savePolicy = .changedKeys
        deleteOperation.modifyRecordsCompletionBlock = { (_, deletedIDs, error) in
            if error != nil { print(error!) }
            for id in deletedIDs! {
                print(id.recordName," is deleted")
            }
            self.viewRecordsInCloudKit()
        }
        
        CloudKit.privateDatabase.perform(companyQuery, inZoneWith: nil) { (record, error) in
            if error != nil { print(error!) }
            for record: CKRecord in record! {
                print(record.recordType," : ",record.recordID.recordName)
                companyRecords.append(record)
            }
            
            deleteOperation.recordIDsToDelete = companyRecords.map{$0.recordID}
            CloudKit.privateDatabase.add(deleteOperation)
        }
        

        
    }
    
}









