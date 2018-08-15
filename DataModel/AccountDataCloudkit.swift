//
//  AccountDataCloudkit.swift
//  Jupiter
//
//  Created by adulphan youngmod on 13/8/18.
//  Copyright © 2018 goldbac. All rights reserved.
//

import Foundation
import CloudKit

extension AccountData: AccessCoreData {
    
    func createRecord() -> CKRecord? {

        let recordName = self.recordID!
        let recordID = CKRecordID(recordName: recordName, zoneID: CloudKit.personalZoneID)
        let record = CKRecord(recordType: CloudKit.recordType.account.rawValue, recordID: recordID)
        
        record.setObject(self.name as CKRecordValue?, forKey: "name")
        record.setObject(self.beginBalance as CKRecordValue?, forKey: "beginBalance")
        record.setObject(self.endBalance as CKRecordValue?, forKey: "endBalance")
        record.setObject(self.type as CKRecordValue?, forKey: "type")
        record.setObject(self.note as CKRecordValue?, forKey: "note")
        record.setObject(self.favourite as CKRecordValue?, forKey: "favourite")
        record.setObject(self.imageData as CKRecordValue?, forKey: "imageData")
        record.setObject(self.modifiedLocal as CKRecordValue?, forKey: "modifiedLocal")
        
        let asset = self.imageData?.createCKAsset()
        record.setObject(asset, forKey: "imageData")
 
        guard let companyRecordID = self.companyData?.recordID else {
            print("Fail to create record: no company recordID")
            return nil
        }
        
        let companyID = CKRecordID(recordName: companyRecordID, zoneID: CloudKit.personalZoneID)
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
        self.note = record.value(forKey: "note") as? String
        self.favourite = record.value(forKey: "favourite") as? Bool ?? false
        self.imageData = record.value(forKey: "imageData") as? Data
        self.modifiedLocal = record.value(forKey: "modifiedLocal") as? Date
        self.imageData = record.value(forKey: "imageData") as? Data
        
        guard let companyID = record.parent?.recordID.recordName else {
            print("Error: incoming account has no referenced company")
            return
        }
        
        let companyData = ExistingCompanyData(recordID: companyID)!
        self.companyData = companyData

    }
    
    func saveToCloudkit() {
        guard !CloudKit.isFetchingFromCloudKit else { return }
        guard CloudKit.isEnable else {
            print("Not uploading: CloudKit is disabled")
            return
        }
        
        let record = self.createRecord()!
        CloudKit.database.save(record, completionHandler: { (record, error) in
            if error != nil {
                print(error!)
            } else {
                print("\(record?.recordID.recordName.description ?? "No ID") is saved")
                FileManager.default.clearTempFileForCKAsset()
            }
        })
        
    }
    
    
}








