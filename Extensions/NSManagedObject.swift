//
//  NSManagedObject.swift
//  Jupiter
//
//  Created by adulphan youngmod on 20/8/18.
//  Copyright © 2018 goldbac. All rights reserved.
//

import Foundation
import CoreData
import CloudKit

extension NSManagedObject {
    
    var recordName: String? {
        if let id = value(forKey: "identifier") {
            return (id as! UUID).uuidString
        } else {            
            return nil
        }
    }
    
    func proceedToCloud() {
        guard cloudIsEnable else { return }
        if isDeleted || isInserted {

            if let name = recordName {
                CloudKit.pendingRecordNames.insert(name)
                if isDeleted {
                    CloudKit.deletedRecordNames.insert(name)
                }
            }
            return
            
        }
        
        let changedKeys = changedValues().map{$0.key}
        guard changedKeys != ["recordData"] else { return }
        let relationshipNames = entity.relationshipsByName.map{$0.key}
        if !Set(changedKeys).isSubset(of: Set(relationshipNames)) {
            CloudKit.pendingRecordNames.insert(recordName!)
        }
        
    }

    
    func recordToUpload() -> CKRecord? {
        
        //var record: CKRecord!
        
        if let recordData = self.value(forKey: "recordData") {
            
            let unarchiver = NSKeyedUnarchiver(forReadingWith: recordData as! Data)
            unarchiver.requiresSecureCoding = true
            let record = CKRecord(coder: unarchiver)!
            
            fillUploadingRecordWithAttributes(record: record)
            setupReferenceFor(record: record)
            
            return record
            
        } else {
            
            guard let recordName = self.recordName else { return nil }
            let recordID = CKRecord.ID(recordName: recordName, zoneID: CloudKit.financialDataZoneID)
            let record = CKRecord(recordType: self.recordType, recordID: recordID)
            
            let data = NSMutableData()
            let archiver = NSKeyedArchiver(forWritingWith: data)
            archiver.requiresSecureCoding = true
            record.encodeSystemFields(with: archiver)
            archiver.finishEncoding()
            self.setValue(data, forKey: "recordData")
            
            fillUploadingRecordWithAttributes(record: record)
            setupReferenceFor(record: record)
            
            return record
            
        }
        

    }
    
    
    func downloadFrom(record: CKRecord) {
        fillAttributesFromDownloading(record: record)
        setupRelationshipFromDownloading(record: record)
        updateRecordDataBy(record: record)
        
    }
    
    func updateRecordDataBy(record: CKRecord) {
        let data = NSMutableData()
        let archiver = NSKeyedArchiver(forWritingWith: data)
        archiver.requiresSecureCoding = true
        record.encodeSystemFields(with: archiver)
        archiver.finishEncoding()
        self.setValue(data, forKey: "recordData")
    }
    
    private func setupReferenceFor(record: CKRecord) {
        if recordType == dataType.transaction.rawValue {
            let accounts = (value(forKey: "accountSet") as! NSOrderedSet).array as! [Account]
            var accountReferenceList: [CKRecord.Reference] = []
            for account in accounts {
                let recordName = account.recordName!
                let recordID = CKRecord.ID(recordName: recordName, zoneID: CloudKit.financialDataZoneID)
                let referenceAccount = CKRecord.Reference(recordID: recordID, action: .deleteSelf)
                accountReferenceList.append(referenceAccount)
                if account == accounts.first {
                    let parentAccount = CKRecord.Reference(recordID: recordID, action: .none)
                    record.parent = parentAccount
                }
            }
            record.setObject(accountReferenceList as CKRecordValue, forKey: "accounts")
            
            
        }
        
        if recordType == dataType.account.rawValue {
            let recordName = (value(forKey: "company") as! Company).identifier?.uuidString
            let companyID = CKRecord.ID(recordName: recordName!, zoneID: CloudKit.financialDataZoneID)
            let referenceCompany = CKRecord.Reference(recordID: companyID, action: .deleteSelf)
            record.setObject(referenceCompany as CKRecordValue, forKey: "company")
            let parentCompany = CKRecord.Reference(recordID: companyID, action: .none)
            record.parent = parentCompany
            
            
        }
        
    }
    
    private func setupRelationshipFromDownloading(record: CKRecord) {
        
        if recordType == dataType.transaction.rawValue {
            let accountReferences = record.value(forKey: "accounts") as! [CKRecord.Reference]
            var accountArray: [NSManagedObject] = []
            for reference in accountReferences {
                let recordName = reference.recordID.recordName
                guard let account = writeContext.existingAccount(recordName: recordName) else {
                    print("Error: downloading transacton has no match referenced account") ; return
                }
                accountArray.append(account)
            }
            let accountSet = NSOrderedSet(array: accountArray)
            setValue(accountSet, forKey: "accountSet")
        }
        
        if recordType == dataType.account.rawValue {
            guard let companyRecordName = record.parent?.recordID.recordName else {
                print("Error: incoming account has no referenced company") ; return
            }
            guard let company = writeContext.existingCompany(recordName: companyRecordName) else {
                print("Error: no record of downloaded account's company") ; return
            }
            setValue(company, forKey: "company")
        }
        
        
    }
    
    private var recordType: String {
        if self is Company { return dataType.company.rawValue }
        if self is Account { return dataType.account.rawValue }
        if self is Transaction { return dataType.transaction.rawValue }
        return ""
    }
    
    private func fillUploadingRecordWithAttributes(record: CKRecord) {
        
        for attibute in entity.attributesByName {
            guard !attibute.value.isTransient else { continue }
            guard attibute.key != "identifier" else { continue }
            guard attibute.key != "recordData" else { continue }
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
        
    }
    
    private func fillAttributesFromDownloading(record: CKRecord) {
        
        setValue(record.recordID.recordName.uuid(), forKey: "identifier")
        for attibute in entity.attributesByName {
            guard !attibute.value.isTransient else { continue }
            guard attibute.key != "identifier" else { continue }
            guard attibute.key != "recordData" else { continue }
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








