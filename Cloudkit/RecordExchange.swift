//
//  RecordExchange.swift
//  Jupiter
//
//  Created by adulphan youngmod on 24/8/18.
//  Copyright © 2018 goldbac. All rights reserved.
//

import Foundation
import CloudKit


class RecordExchange: OperationCloudKit {
    
    var incomingSaveRecords: [CKRecord] = []
    var incomingDeleteRecordIDs: [CKRecordID] = []
    
    var outgoingSaveRecords: [CKRecord] = CloudKit.outgoingSaveRecords
    var outgoingDeleteRecordIDs: [CKRecordID] = CloudKit.outgoingDeleteRecordIDs
    
    var hasIncomings: Bool {
        return incomingSaveRecords.count != 0 || incomingDeleteRecordIDs.count != 0
    }
    
    var hasOutgoings: Bool {
        return outgoingSaveRecords.count != 0 || outgoingDeleteRecordIDs.count != 0
    }
    
    func start() {
        

//        uploadOperation.addDependency(downloadOperation)
//        let operationQueue = OperationQueue.main
//        operationQueue.addOperations([downloadOperation, uploadOperation], waitUntilFinished: false)
        CloudKit.privateDatabase.add(downloadOperation)
//        CloudKit.privateDatabase.add(uploadOperation)

        
        
    }

}









