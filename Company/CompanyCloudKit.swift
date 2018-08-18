//
//  CompanyDataCloudKit.swift
//  Jupiter
//
//  Created by adulphan youngmod on 13/8/18.
//  Copyright © 2018 goldbac. All rights reserved.
//

import Foundation
import CloudKit

extension Company: CloudKitProtocol {
        
    func createRecord() -> CKRecord {
        let recordName = self.recordID!
        let recordID = CKRecordID(recordName: recordName, zoneID: CloudKit.financialDataZoneID)
        let record = CKRecord(recordType: CloudKit.recordType.company.rawValue, recordID: recordID)
        record.setObject(self.name as CKRecordValue?, forKey: "name")
        record.setObject(self.modifiedLocal as CKRecordValue?, forKey: "modifiedLocal")

        return record
    }
    
    func updateBy(record: CKRecord) {        
        self.recordID = record.recordID.recordName
        self.name = record.value(forKey: "name") as? String
        self.modifiedLocal = record.value(forKey: "modifiedLocal") as? Date

    }
    
    func updateTo(record: CKRecord) -> CKRecord {
        record.setObject(self.name as CKRecordValue?, forKey: "name")
        record.setObject(self.modifiedLocal as CKRecordValue?, forKey: "modifiedLocal")
        return record
    }


}
