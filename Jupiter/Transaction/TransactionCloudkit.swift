//
//  TransactionCloudkit.swift
//  Jupiter
//
//  Created by adulphan youngmod on 18/8/18.
//  Copyright © 2018 goldbac. All rights reserved.
//

import Foundation
import CloudKit

extension Transaction: AccessCoreData, CloudKitProtocol {
    
    func createRecord() -> CKRecord {
        let recordName = self.recordName
        let recordID = CKRecordID(recordName: recordName, zoneID: CloudKit.financialDataZoneID)
        let record = CKRecord(recordType: CloudKit.recordType.transaction.rawValue, recordID: recordID)

        record.setObject(self.name as CKRecordValue?, forKey: "name")
        record.setObject(self.date as CKRecordValue?, forKey: "date")
        record.setObject(self.flows as CKRecordValue?, forKey: "flows")
        record.setObject(self.modifiedLocal as CKRecordValue?, forKey: "modifiedLocal")
        record.setObject(self.note as CKRecordValue?, forKey: "note")
        record.setObject(self.url as CKRecordValue?, forKey: "url")
        record.setObject(self.photoID?.uuidString as CKRecordValue?, forKey: "photoID")
        record.setObject(self.thumbID?.uuidString as CKRecordValue?, forKey: "thumbID")
        
        var accountReferenceList: [CKReference] = []
        for account in accounts {
            let recordName = account.recordName
            let recordID = CKRecordID(recordName: recordName, zoneID: CloudKit.financialDataZoneID)
            let referenceAccount = CKReference(recordID: recordID, action: .none)
            accountReferenceList.append(referenceAccount)
        }
        record.setObject(accountReferenceList as CKRecordValue, forKey: "accounts")
        record.parent = accountReferenceList.first!

        return record
    }

    func updateBy(record: CKRecord) {
        
        self.identifier = record.recordID.recordName.uuid()
        self.name = record.value(forKey: "name") as? String
        self.date = record.value(forKey: "date") as? Date
        self.flows = record.value(forKey: "flows") as! [Int64]
        self.modifiedLocal = record.value(forKey: "modifiedLocal") as? Date
        self.note = record.value(forKey: "note") as? String
        self.url = record.value(forKey: "url") as? String
        self.photoID = (record.value(forKey: "photoID") as? String)?.uuid()
        self.thumbID = (record.value(forKey: "thumbID") as? String)?.uuid()
        
        let accountReferences = record.value(forKey: "accounts") as! [CKReference]
        
        var accountArray: [Account] = []
        for reference in accountReferences {
            let recordName = reference.recordID.recordName
            let account = ExistingAccount(recordName: recordName)
            accountArray.append(account!)
        }        
        self.accounts = accountArray
    }
    
}
