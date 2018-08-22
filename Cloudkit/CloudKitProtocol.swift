//
//  CloudKitProtocol.swift
//  Jupiter
//
//  Created by adulphan youngmod on 18/8/18.
//  Copyright © 2018 goldbac. All rights reserved.
//

import Foundation
import CloudKit
import CoreData

protocol CloudKitProtocol: AccessExistingCoreData {

}

extension CloudKitProtocol where Self: NSManagedObject {
    
    var recordName: String {
        let id = value(forKey: "identifier") as! UUID
        return id.uuidString        
    }
    
    func proceedToCloudKit() {
        
        guard !CloudKit.isDownloadingFromCloudKit else { return }
        guard Application.connectedToCloudKit else { return }
        
        if isDeleted {
            let recordName = self.recordName
            let recordID = CKRecordID(recordName: recordName, zoneID: CloudKit.financialDataZoneID)
            
            let isDuplicate:Bool = CloudKit.recordIDsToDeleteFromCloudKit.contains { (id) -> Bool in
                id.recordName == recordName
            }
            
            if !isDuplicate {
                CloudKit.recordIDsToDeleteFromCloudKit.insert(recordID, at: 0)
            }
           
        } else {
            let record = self.recordToUpload()
            
            let index = CloudKit.recordsToSaveToCloudKit.index { (existing) -> Bool in
                existing.recordID.recordName == record.recordID.recordName
            }

            if let index = index {
                CloudKit.recordsToSaveToCloudKit[index] = record
            } else {
                CloudKit.recordsToSaveToCloudKit.append(record)
            }
            
        }
    }
    
    func recordToUpload() -> CKRecord {
        let record = fillUploadingRecordWithAttributes()
        setupReferenceFor(record: record)
        return record
    }
    
    
    func downloadFrom(record: CKRecord) {
        fillAttributesFromDownloading(record: record)
        setupRelationshipFromDownloading(record: record)

    }
    
    private func setupReferenceFor(record: CKRecord) {
        if recordType == CloudKit.recordType.transaction.rawValue {
            let accounts = (value(forKey: "accountSet") as! NSOrderedSet).array as! [Account]
            var accountReferenceList: [CKReference] = []
            for account in accounts {
                let recordName = account.recordName
                let recordID = CKRecordID(recordName: recordName, zoneID: CloudKit.financialDataZoneID)
                let referenceAccount = CKReference(recordID: recordID, action: .deleteSelf)
                accountReferenceList.append(referenceAccount)
                if account == accounts.first {
                    let parentAccount = CKReference(recordID: recordID, action: .none)
                    record.parent = parentAccount
                }
            }
            record.setObject(accountReferenceList as CKRecordValue, forKey: "accounts")

            
        }
        
        if recordType == CloudKit.recordType.account.rawValue {
            let recordName = (value(forKey: "company") as! Company).identifier?.uuidString
            let companyID = CKRecordID(recordName: recordName!, zoneID: CloudKit.financialDataZoneID)
            let referenceCompany = CKReference(recordID: companyID, action: .deleteSelf)
            record.setObject(referenceCompany as CKRecordValue, forKey: "company")
            let parentCompany = CKReference(recordID: companyID, action: .none)
            record.parent = parentCompany
            
            
        }
        
    }
    
    private func setupRelationshipFromDownloading(record: CKRecord) {
        
        if recordType == CloudKit.recordType.transaction.rawValue {
            let accountReferences = record.value(forKey: "accounts") as! [CKReference]
            var accountArray: [Account] = []
            for reference in accountReferences {
                let recordName = reference.recordID.recordName
                guard let account = ExistingAccount(recordName: recordName) else {
                    print("Error: downloading transacton has no match referenceed account") ; return
                }
                accountArray.append(account)
            }
            let accountSet = NSOrderedSet(array: accountArray)
            setValue(accountSet, forKey: "accountSet")
        }
        
        if recordType == CloudKit.recordType.account.rawValue {
            guard let companyRecordName = record.parent?.recordID.recordName else {
                print("Error: incoming account has no referenced company") ; return
            }
            guard let company = ExistingCompany(recordName: companyRecordName) else {
                print("Error: no record of downloaded account's company") ; return
            }
            setValue(company, forKey: "company")
        }
        
        
    }
    
    private var recordType: String {
        if self is Company { return CloudKit.recordType.company.rawValue }
        if self is Account { return CloudKit.recordType.account.rawValue }
        if self is Transaction { return CloudKit.recordType.transaction.rawValue }
        return ""
    }
    
    private func fillUploadingRecordWithAttributes() -> CKRecord {

        let recordID = CKRecordID(recordName: recordName, zoneID: CloudKit.financialDataZoneID)
        let record = CKRecord(recordType: recordType, recordID: recordID)
        
        for attibute in entity.attributesByName {
            guard !attibute.value.isTransient else { continue }
            guard attibute.key != "identifier" else { continue }
            let key = attibute.key
            let transferValue = value(forKey: key)
            if attibute.value.attributeValueClassName == "NSUUID" {
                if let id = transferValue {
                    record.setObject((id as! UUID).uuidString as CKRecordValue, forKey: key)
                }
            } else {
                
                record.setObject(transferValue as? CKRecordValue, forKey: key)
            }
        }
        
        return record
    }
    
    private func fillAttributesFromDownloading(record: CKRecord) {
        
        setValue(record.recordID.recordName.uuid(), forKey: "identifier")
        for attibute in entity.attributesByName {
            guard !attibute.value.isTransient else { continue }
            guard attibute.key != "identifier" else { continue }
            let key = attibute.key
            let transferValue = record.value(forKey: key)
            
            if attibute.value.attributeValueClassName == "NSUUID" {
                if let value = transferValue {
                    let id = (value as! String).uuid()
                    setValue(id, forKey: key)
                }
                
            } else {
                setValue(transferValue, forKey: key)
            }
        }
        
    }
    
    
}

