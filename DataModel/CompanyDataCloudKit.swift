//
//  CompanyDataCloudKit.swift
//  Jupiter
//
//  Created by adulphan youngmod on 13/8/18.
//  Copyright © 2018 goldbac. All rights reserved.
//

import Foundation
import CloudKit

extension CompanyData: CloudkitConnect {
        
    func createRecord() -> CKRecord {
        let recordName = self.recordID!
        let recordID = CKRecordID(recordName: recordName, zoneID: personalZoneID)
        let record = CKRecord(recordType: companyType, recordID: recordID)
        record.setObject(self.name as CKRecordValue?, forKey: "name")
        record.setObject(self.note as CKRecordValue?, forKey: "note")
        record.setObject(self.modifiedLocal as CKRecordValue?, forKey: "modifiedLocal")

        return record
    }

    func saveToCloudkit() {
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
