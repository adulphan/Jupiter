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
    }
    
    static var isFetchingFromCloudKit:Bool = false
    static let privateDatabase = CKContainer(identifier: "iCloud.goldbac-Inc.goldbac").privateCloudDatabase
    static let publicDatabase = CKContainer.default().publicCloudDatabase
    
    static let financialDataZoneID = CKRecordZone(zoneName: "FinancialData").zoneID
    
    static var companyRecordToSave: [CKRecord] = []
    static var accountRecordToSave: [CKRecord] = []
    static var recordIDToDelete: [CKRecordID] = []
    
    static let modifyingOperation: CKModifyRecordsOperation = {
        let operation = CKModifyRecordsOperation()
        operation.savePolicy = .changedKeys
        return operation
    }()
    
}







