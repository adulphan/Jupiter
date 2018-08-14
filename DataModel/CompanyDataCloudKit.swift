//
//  CompanyDataCloudKit.swift
//  Jupiter
//
//  Created by adulphan youngmod on 13/8/18.
//  Copyright © 2018 goldbac. All rights reserved.
//

import Foundation
import CloudKit

extension CompanyData {
        
    func createRecord() -> CKRecord {
        let recordName = self.recordID!
        let recordID = CKRecordID(recordName: recordName, zoneID: CloudKit.personalZoneID)
        let record = CKRecord(recordType: CloudKit.recordType.company.rawValue, recordID: recordID)
        record.setObject(self.name as CKRecordValue?, forKey: "name")
        record.setObject(self.note as CKRecordValue?, forKey: "note")
        record.setObject(self.modifiedLocal as CKRecordValue?, forKey: "modifiedLocal")

        return record
    }
    
    func updateBy(record: CKRecord) {
        
        self.recordID = record.recordID.recordName
        self.name = record.value(forKey: "name") as? String
        self.note = record.value(forKey: "note") as? String
        self.modifiedLocal = record.value(forKey: "modifiedLocal") as? Date
        
    }

    func saveToCloudkit() {
        guard !CloudKit.isFetchingFromCloudKit else { return }
        guard CloudKit.isEnable else {
            print("Not uploading: CloudKit is disabled")
            return
        }
        
        let record = self.createRecord()
        CloudKit.database.save(record, completionHandler: { (record, error) in
            if error != nil {
                print(error!)
            } else {
                print("\(record?.recordID.recordName.description ?? "No ID") is saved")
            }
        })
        
    }


}
