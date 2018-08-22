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
    
    enum recordType : String {
        case company = "Company"
        case account = "Account"
        case transaction = "Transaction"
        static let allValues = [company, account, transaction]
    }
    
    static var isDownloadingFromCloudKit:Bool = false
    static let privateDatabase = CKContainer(identifier: "iCloud.goldbac-Inc.goldbac").privateCloudDatabase
    static let publicDatabase = CKContainer.default().publicCloudDatabase
    
    static let financialDataZoneID = CKRecordZone(zoneName: "FinancialData").zoneID
    
    static var companyRecordToSave: [CKRecord] = []
    static var accountRecordToSave: [CKRecord] = []
    static var transactionRecordToSave: [CKRecord] = []
    
    static var recordsToSaveToCoreData: [CKRecord] = []
    static var recordIDToDeleteFromCoreData: [CKRecordID] = []
    
    static var recordsToSaveToCloudKit: [CKRecord] = []
    static var recordIDsToDeleteFromCloudKit: [CKRecordID] = []
    
}

extension CloudKit {
    
    static func uploadToCloudKit() {
        guard recordsToSaveToCloudKit.count != 0 || recordIDsToDeleteFromCloudKit.count != 0 else { return }
        let operation = CKModifyRecordsOperation(recordsToSave: recordsToSaveToCloudKit, recordIDsToDelete: recordIDsToDeleteFromCloudKit)
        operation.savePolicy = .changedKeys
        operation.modifyRecordsCompletionBlock = { (records, recordIDs, error) in
            if let err = error {
                print(err)
            }
            for record in records! {
                print("\(record.recordID.recordName) is saved")
            }
            
            for id in recordIDs! {
                print("\(id.recordName) is deleted")
            }
            recordsToSaveToCloudKit = []
            recordIDsToDeleteFromCloudKit = []
        }
        
        CloudKit.privateDatabase.add(operation)

    }
    
}





