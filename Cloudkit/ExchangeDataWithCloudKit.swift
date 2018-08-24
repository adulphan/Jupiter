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
    
    func exchangeCK() {
        
        let download = downloadOperation
        let upload = uploadOperation
        
        CloudKit.pendingOperations.append(download)
        CloudKit.pendingOperations.append(upload)
        upload.addDependency(download)
        
        if CloudKit.pendingOperations.count > 2  {
            let index = CloudKit.pendingOperations.index(of: download)
            let previousOperation = CloudKit.pendingOperations[index!-1]
            download.addDependency(previousOperation)
        }
        
        CloudKit.privateDatabase.add(download)
        CloudKit.privateDatabase.add(upload)
        
    }
    
    var downloadOperation: CKFetchRecordZoneChangesOperation {
        
        let option = CKFetchRecordZoneChangesOptions()
        option.previousServerChangeToken = UserDefaults.standard.financialDataChangeToken
        let operation = CKFetchRecordZoneChangesOperation(recordZoneIDs: [CloudKit.financialDataZoneID], optionsByRecordZoneID: [CloudKit.financialDataZoneID:option])
        
        operation.recordChangedBlock = { (record) in
            
            CloudKit.incomingSaveRecords.append(record)
            print("incomingSave: \(record.recordID.recordName)")
        }
        
        operation.recordWithIDWasDeletedBlock = { (recordID, text) in

            CloudKit.incomingDeleteRecordIDs.append(recordID)
            print("incomingDelete: \(recordID.recordName)")
            
        }
        
        operation.recordZoneFetchCompletionBlock = { (zoneId, changeToken, _, _, error) in
            if let error = error {
                print("Error download operation : ", error)
                self.clearCachedRecords()
                return
            }
            
            UserDefaults.standard.financialDataChangeToken = changeToken
            //self.resolveConflicts()
            
            
            DispatchQueue.main.sync { self.pushNewFetchToCoreData() }
        }
        
        return operation
    }
    
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
            CloudKit.incomingSaveRecords.append(record)
            print("\(record.recordID.recordName) is downloaded")
        }
        
        operation.recordWithIDWasDeletedBlock = { (recordID, text) in
            CloudKit.incomingDeleteRecordIDs.append(recordID)
            print("\(recordID.recordName) is ordered to delete")
        }

        operation.recordZoneFetchCompletionBlock = { (zoneId, changeToken, _, _, error) in
            if let error = error {
                print("Error fetching changes : ", error)
                self.clearCachedRecords()
                return
            }
            
            UserDefaults.standard.financialDataChangeToken = changeToken
            self.resolveConflicts()
            DispatchQueue.main.sync {
                self.pushNewFetchToCoreData()
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
        
        CloudKit.incomingSaveRecords = []
        CloudKit.incomingDeleteRecordIDs = []
        
    }
    
    private func saveNewFetchToCoreData() {
        
        for recordID in CloudKit.incomingDeleteRecordIDs {
            if let object = ExistingObject(recordName: recordID.recordName) {
                deleteCoreData(object: object)
            }
        }
        
        var sortedRecords: [CKRecord] = []
        for type in CloudKit.recordType.allValues {
            let filtered = CloudKit.incomingSaveRecords.filter{$0.recordType == type.rawValue}
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




//            let deviceAlreadyDelete = CloudKit.outgoingDeleteRecordIDs.map{$0.recordName}.contains(recordID.recordName)
//            let deviceHasUpdate = CloudKit.outgoingSaveRecords.map{$0.recordID.recordName}.contains(recordID.recordName)
//
//            if !deviceAlreadyDelete {
//                CloudKit.incomingDeleteRecordIDs.append(recordID)
//                print("incomingDelete: \(recordID.recordName)")
//            }
//
//            if deviceHasUpdate {
//                let index = CloudKit.outgoingSaveRecords.index(where: { (record) -> Bool in
//                    record.recordID.recordName == recordID.recordName
//                })
//
//                CloudKit.outgoingSaveRecords.remove(at: index!)
//            }



//let deviceAlreadyDelete = CloudKit.outgoingDeleteRecordIDs.map{$0.recordName}.contains(record.recordID.recordName)
////            let deviceHasUpdate = CloudKit.outgoingSaveRecords.map{$0.recordID.recordName}.contains(record.recordID.recordName)
////
//let index = CloudKit.outgoingSaveRecords.index(where: { (outRecord) -> Bool in
//    outRecord.recordID.recordName == record.recordID.recordName
//})
//
//var deviceVersionPrevail: Bool = false
//if let index = index {
//    let outgoingDate = CloudKit.outgoingSaveRecords[index].value(forKey: "modifiedLocal") as! Date
//    let incomingDate = record.value(forKey: "modifiedLocal") as! Date
//    if outgoingDate > incomingDate {
//        deviceVersionPrevail = true
//    } else {
//        CloudKit.outgoingSaveRecords.remove(at: index)
//    }
//}
//
//if !deviceAlreadyDelete && !deviceVersionPrevail {
//    CloudKit.incomingSaveRecords.append(record)
//    print("incomingSave: \(record.recordID.recordName)")
//}


