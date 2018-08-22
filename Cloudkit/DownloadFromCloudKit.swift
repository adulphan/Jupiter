//
//  FetchChanges.swift
//  Jupiter
//
//  Created by adulphan youngmod on 13/8/18.
//  Copyright © 2018 goldbac. All rights reserved.
//

import Foundation
import CloudKit
import UIKit

protocol OperationCloudKit: AccessCoreData {}

extension OperationCloudKit {
    
    func exchangeDataWithCloudKit(completion: @escaping () -> Void) {
        
        guard Application.connectedToCloudKit else {
            print("No fetching: CloudKit is disabled")
            return
        }
        
        let option = CKFetchRecordZoneChangesOptions()
        //UserDefaults.standard.zoneChangeToken = nil
        option.previousServerChangeToken = UserDefaults.standard.financialDataChangeToken
        let operation = CKFetchRecordZoneChangesOperation(recordZoneIDs: [CloudKit.financialDataZoneID], optionsByRecordZoneID: [CloudKit.financialDataZoneID:option])

        operation.recordChangedBlock = { (record) in
            CloudKit.recordsToSaveToCoreData.append(record)
            print("\(record.recordID.recordName) is fetched")
        }
        
        operation.recordWithIDWasDeletedBlock = { (recordID, text) in
            CloudKit.recordIDToDeleteFromCoreData.append(recordID)
            print("\(recordID.recordName) is to delete")
        }

        operation.recordZoneFetchCompletionBlock = { (zoneId, changeToken, _, _, error) in
            if let error = error {
                print("Error fetching changes : ", error)
                self.clearCachedRecords()
                return
            }

            DispatchQueue.main.sync {
                
                self.resolveConflicts()
                self.pushNewFetchToCoreData()
                //self.uploadToCloudKit()
                UserDefaults.standard.financialDataChangeToken = changeToken
                
                completion()
            }
        }
        
        CloudKit.privateDatabase.add(operation)
    }

    private func pushNewFetchToCoreData() {
        
        CloudKit.isDownloadingFromCloudKit = true
        saveNewFetchToCoreData()
        saveCoreData()
        clearCachedRecords()
        CloudKit.isDownloadingFromCloudKit = false
        
    }
    
    private func clearCachedRecords() {
        
        CloudKit.recordsToSaveToCoreData = []
        CloudKit.recordIDToDeleteFromCoreData = []
        
    }
    
    private func saveNewFetchToCoreData() {
        
        for recordID in CloudKit.recordIDToDeleteFromCoreData {
            if let object = ExistingObject(recordName: recordID.recordName) {
                deleteCoreData(object: object)
            }
        }
        
        var sortedRecords: [CKRecord] = []
        for type in CloudKit.recordType.allValues {
            let filtered = CloudKit.recordsToSaveToCoreData.filter{$0.recordType == type.rawValue}
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






