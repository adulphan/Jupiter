//
//  Cloudkit.swift
//  Jupiter
//
//  Created by adulphan youngmod on 12/8/18.
//  Copyright © 2018 goldbac. All rights reserved.
//

import Foundation
import CloudKit



class CloudKit {
    
    static let shared = CloudKit()
    
    enum recordType : String {
        case company = "Company"
        case account = "Account"
        case transaction = "Transaction"
    }
    
    let database = CKContainer(identifier: "iCloud.goldbac-Inc.goldbac").privateCloudDatabase
    let personalZoneID = CKRecordZone(zoneName: "Personal").zoneID

    
    func saveToCloudkit(company: CompanyData) {
        let recordName = company.recordID!
        let recordID = CKRecordID(recordName: recordName, zoneID: personalZoneID)
        let newRecord = CKRecord(recordType: recordType.company.rawValue, recordID: recordID)
        
        newRecord.setObject(company.name as CKRecordValue?, forKey: "name")

        database.save(newRecord, completionHandler: { (record, error) in
            if error != nil {
                print(error!)
            } else {
                print("\(record?.recordID.recordName.description ?? "No ID") is saved")
                company.modified = record?.modificationDate
            }
        })

    }

    
    func saveToCloudkit(account: AccountData) {
        let recordName = account.recordID!
        let recordID = CKRecordID(recordName: recordName, zoneID: personalZoneID)
        let newRecord = CKRecord(recordType: recordType.account.rawValue, recordID: recordID)
        
        newRecord.setObject(account.name as CKRecordValue?, forKey: "name")
        newRecord.setObject(account.beginBalance as CKRecordValue?, forKey: "beginBalance")
        newRecord.setObject(account.endBalance as CKRecordValue?, forKey: "endBalance")
        newRecord.setObject(account.type as CKRecordValue?, forKey: "type")
        newRecord.setObject(account.note as CKRecordValue?, forKey: "note")
        newRecord.setObject(account.favourite as CKRecordValue?, forKey: "favourite")
        newRecord.setObject(account.imageData as CKRecordValue?, forKey: "imageData")        
        
        guard let companyRecordID = account.companyData?.recordID else {
            print("Fail to save: no company recordID")
            return
        }

        let companyID = CKRecordID(recordName: companyRecordID, zoneID: personalZoneID)
        let referenceCompany = CKReference(recordID: companyID, action: .none)
        newRecord.parent = referenceCompany
        
        database.save(newRecord, completionHandler: { (record, error) in
            if error != nil {
                print(error!)
            } else {
                print("\(record?.recordID.recordName.description ?? "No ID") is saved")
                account.modified = record?.modificationDate
            }
        })
        
    }
    
    
    
    
    
    
    
    
    
    
    
}
