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
    var isInserted: Bool { get }
    var isUpdated: Bool { get }
    var isDeleted: Bool { get }
    var identifier: UUID? { get }
    
    func createRecord() -> CKRecord
    func updateBy(record: CKRecord)
    func updateTo(record: CKRecord) -> CKRecord
}

extension CloudKitProtocol {

    func proceedToCloudKit() {
        
        if isDeleted {
            deleteCloudKit()
            return
        } else {
            saveToCloudKit()
            return
        }
    }
    
    var recordName: String { return (identifier?.uuidString)!}
    
    private func saveToCloudKit() {
        guard !CloudKit.isFetchingFromCloudKit else { return }
        guard Application.connectedToCloudKit else {
            //print("Not saving \(self.recordName) : CloudKit is disabled")
            return
        }
        
        let record = self.createRecord()
        let operation = CKModifyRecordsOperation(recordsToSave: [record], recordIDsToDelete: nil)
        
        operation.modifyRecordsCompletionBlock = { (records, ids, error) in
            if error != nil { print(error!) }
            if let savedRecord = records?.first {
                print("\(savedRecord.recordID.recordName) is saved to CloudKit")
            }
            
        }
        
        operation.savePolicy = .changedKeys
        CloudKit.privateDatabase.add(operation)
        
        
    }
    
    private func deleteCloudKit() {
        guard !CloudKit.isFetchingFromCloudKit else { return }
        guard Application.connectedToCloudKit else {
            print("Not deleting \(self.recordName): CloudKit is disabled")
            return
        }
        
        let recordName = self.recordName
        let recordID = CKRecordID(recordName: recordName, zoneID: CloudKit.financialDataZoneID)
        CloudKit.privateDatabase.delete(withRecordID: recordID) { (recordID, error) in
            if error != nil { print("Fetch error: ",error!) }
            print("\(recordID?.recordName.description ?? "No ID") is deleted")
        }
        
    }
    
    
}

