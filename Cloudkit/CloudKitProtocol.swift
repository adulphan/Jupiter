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

protocol CloudKitProtocol {

    var identifier: UUID? { get set }
    func prepareToUpload(record: CKRecord)
    func prepareToDownload(record: CKRecord)
    
}

extension CloudKitProtocol where Self: NSManagedObject {
    
    var recordName: String { return (identifier?.uuidString)!}
    
    func recordToUpload() -> CKRecord {
        let record = fillUploadingRecordWithAttributes()
        
        
        prepareToUpload(record: record)
        
        
        return record
    }
    
    
    func downloadFrom(record: CKRecord) {
        fillAttributesFromDownloading(record: record)
        
        
        prepareToDownload(record: record)
        
        
        
    }
    
    func proceedToCloudKit() {
        
        guard !CloudKit.isFetchingFromCloudKit else { return }
        guard Application.connectedToCloudKit else { return }
        
        if isDeleted {
            let recordName = self.recordName
            let recordID = CKRecordID(recordName: recordName, zoneID: CloudKit.financialDataZoneID)
            CloudKit.recordIDsToDeleteFromCloudKit.append(recordID)
        } else {
            let record = self.recordToUpload()
            CloudKit.recordsToSaveToCloudKit.append(record)
        }
    }
    
    var recordType: String {
        if self is Company { return CloudKit.recordType.company.rawValue }
        if self is Account { return CloudKit.recordType.account.rawValue }
        if self is Transaction { return CloudKit.recordType.transaction.rawValue }
        return ""
    }
    
    func fillUploadingRecordWithAttributes() -> CKRecord {
        

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
    
    func fillAttributesFromDownloading(record: CKRecord) {
        
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

