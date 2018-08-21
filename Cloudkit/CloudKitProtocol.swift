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
    var isDeleted: Bool { get }
    var identifier: UUID? { get }
    var entity: NSEntityDescription { get }
    
    func value(forKey: String) -> Any?
    func setValue(_: Any?, forKey: String)
    
    func createRecord() -> CKRecord
    func updateBy(record: CKRecord)
    
}

extension CloudKitProtocol {
    
    var recordName: String { return (identifier?.uuidString)!}
    
    func proceedToCloudKit() {
        
        guard !CloudKit.isFetchingFromCloudKit else { return }
        guard Application.connectedToCloudKit else { return }
        
        if isDeleted {
            let recordName = self.recordName
            let recordID = CKRecordID(recordName: recordName, zoneID: CloudKit.financialDataZoneID)
            CloudKit.recordIDsToDeleteFromCloudKit.append(recordID)
        } else {
            let record = self.createRecord()
            CloudKit.recordsToSaveToCloudKit.append(record)
        }
    }
    
    func recordWithAttributes() -> CKRecord {
        
        let recordID = CKRecordID(recordName: recordName, zoneID: CloudKit.financialDataZoneID)
        let record = CKRecord(recordType: CloudKit.recordType.transaction.rawValue, recordID: recordID)
        
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
    
    func getAttributesFrom(record: CKRecord) {
        
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

