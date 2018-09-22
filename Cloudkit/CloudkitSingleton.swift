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

class CloudKit {
    
    static let privateDatabase = CKContainer.default().privateCloudDatabase
    static let publicDatabase = CKContainer.default().publicCloudDatabase
    static let sharedDatabase = CKContainer.default().sharedCloudDatabase
    
    static let financialDataZoneID = CKRecordZone(zoneName: "FinancialData").zoneID
    static var operationQueueIsEmpty: Bool { return operationQueue.operations.isEmpty }
    
    static var operationQueue: OperationQueue = {
        let queue = OperationQueue.init()
        queue.maxConcurrentOperationCount = 1
        queue.qualityOfService = .background
        return queue
    }()
    
    static var isFetching: Bool = false

    static var pendingRecordNames: Set<String> = Set()
    
    static var nilDataCount: Int = 0
    
    static var deletedRecordNames: Set<String> = Set()
    
}

protocol OperationCloudKit {}











