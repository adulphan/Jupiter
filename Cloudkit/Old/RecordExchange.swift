////
////  RecordExchange.swift
////  Jupiter
////
////  Created by adulphan youngmod on 24/8/18.
////  Copyright © 2018 goldbac. All rights reserved.
////
//
//import Foundation
//import CloudKit
//
//
//class RecordExchange: OperationCloudKit {
//    
//    var incomingSaveRecords: [CKRecord] = []
//    var incomingDeleteRecordIDs: [CKRecordID] = []
//    
//    var outgoingSaveRecords: [CKRecord] = []
//    var outgoingDeleteRecordIDs: [CKRecordID] = []
//    
//    var hasIncomings: Bool {
//        return incomingSaveRecords.count != 0 || incomingDeleteRecordIDs.count != 0
//    }
//    
//    var hasOutgoings: Bool {
//        return outgoingSaveRecords.count != 0 || outgoingDeleteRecordIDs.count != 0
//    }
//
//    var uploadOperation = CKModifyRecordsOperation()
//    var downloadOperation = CKFetchRecordZoneChangesOperation()
//    var refrechToken = CKFetchRecordZoneChangesOperation()
//
//    func start() {
//        
//        let operationQueue = CloudKit.operationQueue
//        let group = CKOperationGroup()
//        
//        uploadOperation = createUploadOperation()
//        downloadOperation = createDownloadOperation()
////        refrechToken = createRefreshTokenOperation()
//        
//        uploadOperation.group = group
//        downloadOperation.group = group
////        refrechToken.group = group
//        
//        uploadOperation.addDependency(downloadOperation)
////        refrechToken.addDependency(uploadOperation)
//
//        if let lastOperation = operationQueue.operations.last {
//            downloadOperation.addDependency(lastOperation)
//        }
//        operationQueue.maxConcurrentOperationCount = 1
//        outgoingSaveRecords = CloudKit.outgoingSaveRecords
//        outgoingDeleteRecordIDs = CloudKit.outgoingDeleteRecordIDs
//        
//        operationQueue.addOperations([downloadOperation, uploadOperation], waitUntilFinished: false)
//        print("operation added: ", Date().description)
//    
//    }
//
//
//}
//
//
//
//
//
//
//
//
//
