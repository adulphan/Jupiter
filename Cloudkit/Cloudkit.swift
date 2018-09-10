//
//  Cloudkit.swift
//  Jupiter
//
//  Created by adulphan youngmod on 12/8/18.
//  Copyright © 2018 goldbac. All rights reserved.
//

import Foundation
import CloudKit
import CoreData

var pendingQueue: DispatchQueue {    
    return CloudKit.pendingQueue
}

class CloudKit {
    
    enum recordType : String {
        case company = "Company"
        case account = "Account"
        case transaction = "Transaction"
        static let allValues = [company, account, transaction]
    }
    

    static let pendingQueue = DispatchQueue(label: "pendingQueue", qos: DispatchQoS.background, autoreleaseFrequency: DispatchQueue.AutoreleaseFrequency.workItem)
    
    static let privateDatabase = CKContainer.default().privateCloudDatabase
    static let publicDatabase = CKContainer.default().publicCloudDatabase
    static let sharedDatabase = CKContainer.default().sharedCloudDatabase
    
    static let financialDataZoneID = CKRecordZone(zoneName: "FinancialData").zoneID
    
    static var incomingSaveRecords: [CKRecord] = []
    static var incomingDeleteRecordIDs: [CKRecordID] = []
    static var hasIncomings: Bool = incomingSaveRecords != [] || incomingDeleteRecordIDs != []
    
    static var outgoingSaveRecords: [CKRecord] = []
    static var outgoingDeleteRecordIDs: [CKRecordID] = []
    static var hasOutgoings: Bool { return outgoingSaveRecords != [] || outgoingDeleteRecordIDs != [] }    
    
    static var operationQueueIsEmpty: Bool { return operationQueue.operations.isEmpty }
    
    static var operationQueue: OperationQueue = {
        let queue = OperationQueue.init()
        queue.maxConcurrentOperationCount = 1
        queue.qualityOfService = .background
        return queue
    }()


    static var pendingUpload: [PendingUpload] {
        return Array(pendingContext.registeredObjects) as! [PendingUpload]
    }
    
    static var hasPendingUploads: Bool {
        return !pendingUpload.isEmpty
    }
    
}














