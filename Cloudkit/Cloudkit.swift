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
    static let privateDatabase = CKContainer.default().privateCloudDatabase
    static let publicDatabase = CKContainer.default().publicCloudDatabase
    
    static let financialDataZoneID = CKRecordZone(zoneName: "FinancialData").zoneID
    
    static var companyRecordToSave: [CKRecord] = []
    static var accountRecordToSave: [CKRecord] = []
    static var transactionRecordToSave: [CKRecord] = []
    
    static var incomingSaveRecords: [CKRecord] = []
    static var incomingDeleteRecordIDs: [CKRecordID] = []
    static var hasIncomings: Bool = incomingSaveRecords != [] || incomingDeleteRecordIDs != []
    
    static var outgoingSaveRecords: [CKRecord] = []
    static var outgoingDeleteRecordIDs: [CKRecordID] = []
    static var hasOutgoings: Bool = outgoingSaveRecords != [] || outgoingDeleteRecordIDs != []
    
    static var pendingOperations: [CKOperation] = []
    
}






