//
//  DownloadRecords.swift
//  Jupiter
//
//  Created by adulphan youngmod on 24/8/18.
//  Copyright © 2018 goldbac. All rights reserved.
//

import Foundation
import CloudKit
import UIKit

extension CKFetchRecordZoneChangesOperation {
    open override func main() {
        let option = CKFetchRecordZoneChangesOptions()
        option.previousServerChangeToken = UserDefaults.standard.financialDataChangeToken
        self.optionsByRecordZoneID = [CloudKit.financialDataZoneID:option]
        super.main()
    }
    
}

extension RecordExchange: AccessCoreData {
    
    func createDownloadOperation() -> CKFetchRecordZoneChangesOperation {
        
        let option = CKFetchRecordZoneChangesOptions()
        option.previousServerChangeToken = UserDefaults.standard.financialDataChangeToken
        let operation = CKFetchRecordZoneChangesOperation(recordZoneIDs: [CloudKit.financialDataZoneID], optionsByRecordZoneID: [CloudKit.financialDataZoneID:option])
        operation.name = "downloadOperation"
        operation.database = CloudKit.privateDatabase
        operation.recordChangedBlock = { (record) in
            let recordName = record.recordID.recordName
            let deletingNames = self.outgoingDeleteRecordIDs.map{$0.recordName}
            let savingNames = self.outgoingSaveRecords.map{$0.recordID.recordName}
            
            guard !deletingNames.contains(recordName) else { return }
            guard !savingNames.contains(recordName) else { return }
            self.incomingSaveRecords.append(record)
            print("incomingSave: \(record.recordID.recordName)")

        }
        
        operation.recordWithIDWasDeletedBlock = { (recordID, text) in
            
            let recordName = recordID.recordName
            let deletingNames = self.outgoingDeleteRecordIDs.map{$0.recordName}
            let savingNames = self.outgoingSaveRecords.map{$0.recordID.recordName}
            
            if savingNames.contains(recordName) {
                let index = self.outgoingSaveRecords.index(where: { (savingRecord) -> Bool in
                    savingRecord.recordID.recordName == recordName
                })
                self.outgoingSaveRecords.remove(at: index!)
            }
            
            guard !deletingNames.contains(recordName) else { return }
            self.incomingDeleteRecordIDs.append(recordID)
            print("incomingDelete: \(recordID.recordName)")
            
        }
        
        operation.recordZoneFetchCompletionBlock = { (zoneId, changeToken, _, _, error) in
            if let error = error {
                print("Error download operation : ", error)
                return
            }
            self.printTransferingRecords()

//            print("Download finished: \(self.downloadOperation.operationID)", ", date: ",Date().description)
//            print("Now we test suspension ", ", date: ",Date().description)
//            print("")
//            print("")
//            CloudKit.operationQueue.isSuspended = true
//
//            DispatchQueue.main.async {
//                Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(self.retryDownload), userInfo: nil, repeats: false)
//
//            }

            //UserDefaults.standard.financialDataChangeToken = changeToken
            
            DispatchQueue.main.sync { self.pushNewFetchToCoreData() }
            self.uploadOperation.recordsToSave = self.outgoingSaveRecords
            self.uploadOperation.recordIDsToDelete = self.outgoingDeleteRecordIDs

        }
        
        return operation
    }
    
    
    @objc func retryDownload() {
        
        print("restart download!!!", ", date: ",Date().description)
        let newDownloadOperation = createDownloadOperation()
        let operationQueue = CloudKit.operationQueue
        print("operationQueue count: ",operationQueue.operations.count)
        print(operationQueue.operations.map{$0.name!})
        let nextOperation = operationQueue.operations.first as! CKOperation
        nextOperation.removeDependency(downloadOperation)
        nextOperation.addDependency(newDownloadOperation)
        operationQueue.addOperation(newDownloadOperation)
        print("newDownload is added", ", date: ",Date().description)
        print(operationQueue.operations.map{$0.name!})
        
        self.incomingSaveRecords = []
         self.incomingDeleteRecordIDs = []
        CloudKit.operationQueue.isSuspended = false
        
    }
    
    private func pushNewFetchToCoreData() {
        
        CloudKit.isDownloadingFromCloudKit = true
        saveNewFetchToCoreData()
        saveCoreData()
        CloudKit.isDownloadingFromCloudKit = false
        
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
  
            let hasInserted = record.modificationDate == record.creationDate
            let fromOtherDevice = record.value(forKey: "lastModifyDevice") as? String != UIDevice.current.identifierForVendor?.uuidString
            let recordName = record.recordID.recordName
            
            switch record.recordType {
                
            case CloudKit.recordType.company.rawValue:
                if let object = ExistingCompany(recordName: recordName) {
                    object.downloadFrom(record: record)
                } else if hasInserted && fromOtherDevice {
                    let object = Company(context: CoreData.context)
                    object.downloadFrom(record: record)
                }
            case CloudKit.recordType.account.rawValue:
                if let object = ExistingAccount(recordName: recordName) {
                    object.downloadFrom(record: record)
                } else if hasInserted && fromOtherDevice {
                    let object = Account(context: CoreData.context)
                    object.downloadFrom(record: record)
                }
            case CloudKit.recordType.transaction.rawValue:
                if let object = ExistingTransaction(recordName: recordName) {
                    object.downloadFrom(record: record)
                } else if hasInserted && fromOtherDevice {
                    let object = Transaction(context: CoreData.context)
                    object.downloadFrom(record: record)
                }
                
            default:
                print("unidentified recordtype")
            }
            
            
        }
        
    }
    
    
    
    
}

