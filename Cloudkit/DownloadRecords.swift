//
//  DownloadRecords.swift
//  Jupiter
//
//  Created by adulphan youngmod on 24/8/18.
//  Copyright © 2018 goldbac. All rights reserved.
//

import Foundation
import CloudKit

extension RecordExchange: AccessCoreData {
    
    var downloadOperation: CKFetchRecordZoneChangesOperation {
        
        let option = CKFetchRecordZoneChangesOptions()
        option.previousServerChangeToken = UserDefaults.standard.financialDataChangeToken
        let operation = CKFetchRecordZoneChangesOperation(recordZoneIDs: [CloudKit.financialDataZoneID], optionsByRecordZoneID: [CloudKit.financialDataZoneID:option])
        
        operation.recordChangedBlock = { (record) in
            
            self.incomingSaveRecords.append(record)
            print("incomingSave: \(record.recordID.recordName)")
        }
        
        
        operation.recordWithIDWasDeletedBlock = { (recordID, text) in
            
            self.incomingDeleteRecordIDs.append(recordID)
            print("incomingDelete: \(recordID.recordName)")
            
        }
        
        operation.recordZoneFetchCompletionBlock = { (zoneId, changeToken, _, _, error) in
            if let error = error {
                print("Error download operation : ", error)
                self.clearCachedRecords()
                return
            }
            
            UserDefaults.standard.financialDataChangeToken = changeToken
            self.resolveConflicts()
            DispatchQueue.main.sync { self.pushNewFetchToCoreData() }
            print("recordFetchComplete")
            //self.uploadOperation.addDependency(self.downloadOperation)
            CloudKit.privateDatabase.add(self.uploadOperation)
            
        }
        
        return operation
    }
    
    private func pushNewFetchToCoreData() {
        
        CloudKit.isDownloadingFromCloudKit = true
        saveNewFetchToCoreData()
        saveCoreData()
        clearCachedRecords()
        CloudKit.isDownloadingFromCloudKit = false
        
    }
    
    private func clearCachedRecords() {
        
        incomingSaveRecords = []
        incomingDeleteRecordIDs = []
        
    }
    
    private func saveNewFetchToCoreData() {
        
        for recordID in incomingDeleteRecordIDs {
            
            
            if let object = ExistingObject(recordName: recordID.recordName) {
                
                
                
                deleteCoreData(object: object)
            }
        }
        
        var sortedRecords: [CKRecord] = []
        for type in CloudKit.recordType.allValues {
            let filtered = incomingSaveRecords.filter{$0.recordType == type.rawValue}
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

