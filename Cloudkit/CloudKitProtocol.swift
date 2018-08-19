//
//  CloudKitProtocol.swift
//  Jupiter
//
//  Created by adulphan youngmod on 18/8/18.
//  Copyright © 2018 goldbac. All rights reserved.
//

import Foundation
import CloudKit

protocol CloudKitProtocol {
    var recordID: String? { get set }
    var isInserted: Bool { get }
    var isUpdated: Bool { get }
    var isDeleted: Bool { get }
    
    func createRecord() -> CKRecord
    func updateBy(record: CKRecord)
    func updateTo(record: CKRecord) -> CKRecord
}

extension CloudKitProtocol {
    
    func proceedToCloudKit() {
        if isInserted { saveToCloudKit() }
        if isUpdated { updateCloudKit() }
        if isDeleted { deleteCloudKit() }
    }
    
    private func saveToCloudKit() {
        guard !CloudKit.isFetchingFromCloudKit else { return }
        guard Application.connectedToCloudKit else {
            print("Not uploading: CloudKit is disabled")
            return
        }
        
        let record = self.createRecord()
        CloudKit.privateDatabase.save(record, completionHandler: { (record, error) in
            if error != nil { print(error!) }
            print("\(record?.recordID.recordName.description ?? "No ID") is saved")
            FileManager.default.clearTempFileForCKAsset()
        })
        
    }
    
    private func updateCloudKit() {
        guard !CloudKit.isFetchingFromCloudKit else { return }
        guard Application.connectedToCloudKit else {
            print("Not uploading: CloudKit is disabled")
            return
        }
        
        let recordName = self.recordID!
        let recordID = CKRecordID(recordName: recordName, zoneID: CloudKit.financialDataZoneID)
        CloudKit.privateDatabase.fetch(withRecordID: recordID) { (existingRecord, error) in
            if error != nil { print("Fetch error: ",error!) }
            let updatedRecord = self.updateTo(record: existingRecord!)
            CloudKit.privateDatabase.save(updatedRecord, completionHandler: { (record, error) in
                if error != nil { print("Save error: ",error!) }
                print("\(record?.recordID.recordName.description ?? "No ID") is updated")
            })
        }
    }
    
    private func deleteCloudKit() {
        guard !CloudKit.isFetchingFromCloudKit else { return }
        guard Application.connectedToCloudKit else {
            print("Not uploading: CloudKit is disabled")
            return
        }
        
        let recordName = self.recordID!
        let recordID = CKRecordID(recordName: recordName, zoneID: CloudKit.financialDataZoneID)
        CloudKit.privateDatabase.delete(withRecordID: recordID) { (recordID, error) in
            if error != nil { print("Fetch error: ",error!) }
            print("\(recordID?.recordName.description ?? "No ID") is deleted")
        }
        
    }
    
    
}

