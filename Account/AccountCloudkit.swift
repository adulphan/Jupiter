//
//  AccountDataCloudkit.swift
//  Jupiter
//
//  Created by adulphan youngmod on 13/8/18.
//  Copyright © 2018 goldbac. All rights reserved.
//

import Foundation
import CloudKit

extension Account: AccessCoreData, CloudKitProtocol {

    func createRecord() -> CKRecord {
        let recordName = self.recordID!
        let recordID = CKRecordID(recordName: recordName, zoneID: CloudKit.financialDataZoneID)
        let record = CKRecord(recordType: CloudKit.recordType.account.rawValue, recordID: recordID)
        
        record.setObject(self.name as CKRecordValue?, forKey: "name")
        record.setObject(self.beginBalance as CKRecordValue?, forKey: "beginBalance")
        record.setObject(self.endBalance as CKRecordValue?, forKey: "endBalance")
        record.setObject(self.type as CKRecordValue?, forKey: "type")
        record.setObject(self.modifiedLocal as CKRecordValue?, forKey: "modifiedLocal")

        let companyRecordID = self.company?.recordID
        let companyID = CKRecordID(recordName: companyRecordID!, zoneID: CloudKit.financialDataZoneID)
        let referenceCompany = CKReference(recordID: companyID, action: .none)
        record.parent = referenceCompany
        
        return record
    }
    
    func updateBy(record: CKRecord) {
        self.recordID = record.recordID.recordName
        self.name = record.value(forKey: "name") as? String
        self.beginBalance = record.value(forKey: "beginBalance") as? Int64 ?? 0
        self.endBalance = record.value(forKey: "endBalance") as? Int64 ?? 0
        self.type = record.value(forKey: "type") as? Int16 ?? 0
        self.modifiedLocal = record.value(forKey: "modifiedLocal") as? Date
  
        guard let companyID = record.parent?.recordID.recordName else {
            print("Error: incoming account has no referenced company")
            return
        }
        
        let company = ExistingCompany(recordID: companyID)!
        self.company = company

    }
    
    func updateTo(record: CKRecord) -> CKRecord {
        record.setObject(self.name as CKRecordValue?, forKey: "name")
        record.setObject(self.beginBalance as CKRecordValue?, forKey: "beginBalance")
        record.setObject(self.endBalance as CKRecordValue?, forKey: "endBalance")
        record.setObject(self.type as CKRecordValue?, forKey: "type")
        record.setObject(self.modifiedLocal as CKRecordValue?, forKey: "modifiedLocal")
        
        let companyRecordID = self.company?.recordID
        let companyID = CKRecordID(recordName: companyRecordID!, zoneID: CloudKit.financialDataZoneID)
        let referenceCompany = CKReference(recordID: companyID, action: .none)
        record.parent = referenceCompany
        return record
        
    }
}






