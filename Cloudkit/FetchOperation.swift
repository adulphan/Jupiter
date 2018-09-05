//
//  FectChangesOperation.swift
//  Jupiter
//
//  Created by adulphan youngmod on 29/8/18.
//  Copyright © 2018 goldbac. All rights reserved.
//

import Foundation
import CloudKit
import UIKit

extension OperationCloudKit {
    
    func fetchRecords(completion: @escaping (Error?) -> Void) {
        
        var incomingSaveRecords: [CKRecord] = []
        var incomingDeleteRecordIDs: [CKRecordID] = []
        
        let option = CKFetchRecordZoneChangesOptions()
        option.previousServerChangeToken = UserDefaults.standard.financialDataChangeToken
        let operation = CKFetchRecordZoneChangesOperation(recordZoneIDs: [CloudKit.financialDataZoneID], optionsByRecordZoneID: [CloudKit.financialDataZoneID:option])
        operation.name = "fetchFinnacialData"
        operation.database = CloudKit.privateDatabase
        operation.recordChangedBlock = { (record) in
            incomingSaveRecords.append(record)
            print("incomingSave: \(record.recordID.recordName)")
            
        }
        
        operation.recordWithIDWasDeletedBlock = { (recordID, text) in
            incomingDeleteRecordIDs.append(recordID)
            print("incomingDelete: \(recordID.recordName)")
            
        }
        
        operation.recordZoneFetchCompletionBlock = { (zoneId, changeToken, _, _, error) in
            if let error = error {
                print("Error download operation : ", error)
                completion(error)
                return
            }
            UserDefaults.standard.financialDataChangeToken = changeToken
            DispatchQueue.main.sync { self.pushNewFetchToCoreData(recordsToSave: incomingSaveRecords, recordIDsTodelete: incomingDeleteRecordIDs) }
            completion(nil)
        }
        
        let operationQueue = CloudKit.operationQueue
        if let lastOperation = operationQueue.operations.last {
            operation.addDependency(lastOperation)
        }
        
        operationQueue.addOperations([operation], waitUntilFinished: false)
        
    }
    
    private func pushNewFetchToCoreData(recordsToSave: [CKRecord], recordIDsTodelete: [CKRecordID]) {
        
        saveNewFetchToCoreData(recordsToSave: recordsToSave, recordIDsTodelete: recordIDsTodelete)
        saveCoreData(sendToCloudKit: false)
        
    }
    
    
    private func saveNewFetchToCoreData(recordsToSave: [CKRecord], recordIDsTodelete: [CKRecordID]) {
        
        for recordID in recordIDsTodelete {
            if let object = ExistingObject(recordName: recordID.recordName) {
                deleteCoreData(object: object)
            }
        }
        
        var sortedRecords: [CKRecord] = []
        for type in CloudKit.recordType.allValues {
            let filtered = recordsToSave.filter{$0.recordType == type.rawValue}
            sortedRecords += filtered
        }
        
        for record in sortedRecords {

            let recordName = record.recordID.recordName
            
            switch record.recordType {
                
            case CloudKit.recordType.company.rawValue:
                if let object = ExistingCompany(recordName: recordName) {
                    object.downloadFrom(record: record)
                } else {
                    let object = Company(context: CoreData.context)
                    object.downloadFrom(record: record)
                }
            case CloudKit.recordType.account.rawValue:
                if let object = ExistingAccount(recordName: recordName) {
                    object.downloadFrom(record: record)
                } else {
                    let object = Account(context: CoreData.context)
                    object.downloadFrom(record: record)
                }
            case CloudKit.recordType.transaction.rawValue:
                if let object = ExistingTransaction(recordName: recordName) {
                    object.downloadFrom(record: record)
                } else {
                    let object = Transaction(context: CoreData.context)
                    object.downloadFrom(record: record)
                }
                
            default:
                print("unidentified recordtype")
            }
            
            
        }
        
    }
    
}
