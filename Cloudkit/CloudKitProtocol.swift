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
}

extension CloudKitProtocol {

    func proceedToCloudKit() {
        
        guard !CloudKit.isFetchingFromCloudKit else { return }
        guard Application.connectedToCloudKit else { return }
        
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
        let record = self.createRecord()
        CloudKit.recordsToSaveToCloudKit.append(record)
    }
    
    private func deleteCloudKit() {
        let recordName = self.recordName
        let recordID = CKRecordID(recordName: recordName, zoneID: CloudKit.financialDataZoneID)
        CloudKit.recordIDsToDeleteFromCloudKit.append(recordID)
    }
    
    
}

