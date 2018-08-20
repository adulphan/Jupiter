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
        let recordName = self.recordName
        let recordID = CKRecordID(recordName: recordName, zoneID: CloudKit.financialDataZoneID)
        let record = CKRecord(recordType: CloudKit.recordType.account.rawValue, recordID: recordID)
        
        record.setObject(self.name as CKRecordValue?, forKey: "name")
        record.setObject(self.beginBalance as CKRecordValue?, forKey: "beginBalance")
        record.setObject(self.endBalance as CKRecordValue?, forKey: "endBalance")
        record.setObject(self.type as CKRecordValue?, forKey: "type")
        record.setObject(self.modifiedLocal as CKRecordValue?, forKey: "modifiedLocal")

        let companyRecordName = self.company?.identifier?.uuidString
        let companyID = CKRecordID(recordName: companyRecordName!, zoneID: CloudKit.financialDataZoneID)
        let referenceCompany = CKReference(recordID: companyID, action: .none)
        record.parent = referenceCompany
        
        return record
    }
    
    func updateBy(record: CKRecord) {
        self.identifier = record.recordID.recordName.uuid()
        self.name = record.value(forKey: "name") as? String
        self.beginBalance = record.value(forKey: "beginBalance") as? Int64 ?? 0
        self.endBalance = record.value(forKey: "endBalance") as? Int64 ?? 0
        self.type = record.value(forKey: "type") as? Int16 ?? 0
        self.modifiedLocal = record.value(forKey: "modifiedLocal") as? Date
  
        guard let companyRecordName = record.parent?.recordID.recordName else {
            print("Error: incoming account has no referenced company")
            return
        }
        
        let company = ExistingCompany(recordName: companyRecordName)!
        self.company = company

    }
    
    func updateTo(record: CKRecord) -> CKRecord {
        record.setObject(self.name as CKRecordValue?, forKey: "name")
        record.setObject(self.beginBalance as CKRecordValue?, forKey: "beginBalance")
        record.setObject(self.endBalance as CKRecordValue?, forKey: "endBalance")
        record.setObject(self.type as CKRecordValue?, forKey: "type")
        record.setObject(self.modifiedLocal as CKRecordValue?, forKey: "modifiedLocal")
        
        let companyRecordName = self.company?.recordName
        let companyID = CKRecordID(recordName: companyRecordName!, zoneID: CloudKit.financialDataZoneID)
        let referenceCompany = CKReference(recordID: companyID, action: .none)
        record.parent = referenceCompany
        return record
        
    }
}






