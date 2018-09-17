//
//  FectChangesOperation.swift
//  Jupiter
//
//  Created by adulphan youngmod on 29/8/18.
//  Copyright © 2018 goldbac. All rights reserved.
//

import Foundation
import CloudKit
import CoreData
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

        operation.recordZoneFetchCompletionBlock = { (zoneId, serverChangeToken, clientChangeToken, moreComing, error) in
            if let error = error {
                print("Error download operation : ", error)
                completion(error)
                return
            } else {
                print("moreComing: ",moreComing)
                
                let localData = UserDefaults.standard.value(forKey: "financialDataChangeToken") as? Data
                print("Same clientChangeToken: ",localData == clientChangeToken) 
                
                UserDefaults.standard.financialDataChangeToken = serverChangeToken
                self.pushNewFetchToCoreData(recordsToSave: incomingSaveRecords, recordIDsTodelete: incomingDeleteRecordIDs)
                completion(nil)
                
                if CloudKit.pendingRecordNames.count != 0 {
                    self.uploadToCloud()
                } else {
                    print("------------------------------")
                    writeContext.performAndWait {
                        cloudContext.printSystemField()
                    }
                }
            }

        }
        
        let operationQueue = CloudKit.operationQueue
        if let lastOperation = operationQueue.operations.last {
            operation.addDependency(lastOperation)
        }
        operationQueue.addOperations([operation], waitUntilFinished: false)
        
    }
    
    private func pushNewFetchToCoreData(recordsToSave: [CKRecord], recordIDsTodelete: [CKRecordID]) {
        
        writeContext.performAndWait {
            var objectsToDelete: [NSManagedObject] = []
            for recordID in recordIDsTodelete {
                if let object = cloudContext.existingObject(recordName: recordID.recordName) {
                    objectsToDelete.append(object)
                }
            }
            
            cloudContext.delete(objects: objectsToDelete)

            var sortedRecords: [CKRecord] = []
            for type in dataType.allValues {

                let filtered = recordsToSave.filter{$0.recordType == type.rawValue}
                sortedRecords += filtered
            }
            
            for record in sortedRecords {
                let recordName = record.recordID.recordName
                if let object = cloudContext.existingObject(recordName: recordName, type: record.recordType) {
                    object.downloadFrom(record: record)
                } else {
                    let object = NSEntityDescription.insertNewObject(forEntityName: record.recordType, into: cloudContext)
                    object.downloadFrom(record: record)
                }
            }
            cloudContext.saveData()
        }

    }
    
}





