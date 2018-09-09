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
import UIKit

protocol CloudKitProtocol: AccessExistingCoreData {
    
}

extension CloudKitProtocol where Self: NSManagedObject {
    
    var recordName: String {
        let id = value(forKey: "identifier") as! UUID
        return id.uuidString        
    }
    
    func screeningForCloudKit() {
        guard CoreData.sendToCludKit == true else { return }
        guard Application.connectedToCloudKit else { return }
        
        if isDeleted || isInserted {
            proceedToCloudKit()
            return
            
        }
        
        let changedKeys = changedValues().map{$0.key}
        guard changedKeys != ["recordData"] else { return }
        let relationshipNames = entity.relationshipsByName.map{$0.key}
        if !Set(changedKeys).isSubset(of: Set(relationshipNames)) {
            proceedToCloudKit()
        }
        
    }
    
    private func proceedToCloudKit() {
        let record = self.recordToUpload()
        
        let pendingUpload = CloudKit.pendingUpload
        
        let pending = PendingUpload(record: record)
        
        let duplicate = pendingUpload.filter { (pending) -> Bool in
            pending.recordID.recordName == record.recordID.recordName
        }
        
        for object in duplicate {
            CoreData.mainContext.delete(object)
        }
        
        if isDeleted { pending.delete = true }

    }    
    
    func recordToUpload() -> CKRecord {

        var record: CKRecord!
        
        if let recordData = self.value(forKey: "recordData") {
            let unarchiver = NSKeyedUnarchiver(forReadingWith: recordData as! Data)
            unarchiver.requiresSecureCoding = true
            record = CKRecord(coder: unarchiver)!
            
        } else {
            
            let recordName = self.recordName
            let recordID = CKRecordID(recordName: recordName, zoneID: CloudKit.financialDataZoneID)
            record = CKRecord(recordType: self.recordType, recordID: recordID)
            
        }
        
        fillUploadingRecordWithAttributes(record: record)        
        setupReferenceFor(record: record)

        return record
    }
    
    
    func downloadFrom(record: CKRecord) {
        fillAttributesFromDownloading(record: record)
        setupRelationshipFromDownloading(record: record)
        
        let data = NSMutableData()
        let archiver = NSKeyedArchiver(forWritingWith: data)
        archiver.requiresSecureCoding = true
        record.encodeSystemFields(with: archiver)
        archiver.finishEncoding()
        self.setValue(data, forKey: "recordData")

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
                    print("Error: downloading transacton has no match referenced account") ; return
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

