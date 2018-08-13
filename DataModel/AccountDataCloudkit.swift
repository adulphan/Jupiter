//
//  AccountDataCloudkit.swift
//  Jupiter
//
//  Created by adulphan youngmod on 13/8/18.
//  Copyright © 2018 goldbac. All rights reserved.
//

import Foundation
import CloudKit

extension AccountData: CloudkitConnect {
    
    func createRecord() -> CKRecord {

        let recordName = self.recordID!
        let recordID = CKRecordID(recordName: recordName, zoneID: personalZoneID)
        let record = CKRecord(recordType: accountType, recordID: recordID)
        
        record.setObject(self.name as CKRecordValue?, forKey: "name")
        record.setObject(self.beginBalance as CKRecordValue?, forKey: "beginBalance")
        record.setObject(self.endBalance as CKRecordValue?, forKey: "endBalance")
        record.setObject(self.type as CKRecordValue?, forKey: "type")
        record.setObject(self.note as CKRecordValue?, forKey: "note")
        record.setObject(self.favourite as CKRecordValue?, forKey: "favourite")
        record.setObject(self.imageData as CKRecordValue?, forKey: "imageData")
        record.setObject(self.modifiedLocal as CKRecordValue?, forKey: "modifiedLocal")
        
        return record
    }
    
    func saveToCloudkit() {
        let record = self.createRecord()
        
        guard let companyRecordID = self.companyData?.recordID else {
            print("Fail to save: no company recordID")
            return
        }
        
        let companyID = CKRecordID(recordName: companyRecordID, zoneID: personalZoneID)
        let referenceCompany = CKReference(recordID: companyID, action: .none)
        record.parent = referenceCompany
        
        database.save(record, completionHandler: { (record, error) in
            if error != nil {
                print(error!)
            } else {
                print("\(record?.recordID.recordName.description ?? "No ID") is saved")
            }
        })
        
    }
    
}








