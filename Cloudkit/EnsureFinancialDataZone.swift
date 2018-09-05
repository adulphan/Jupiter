//
//  EnsureFinancialDataZone.swift
//  Jupiter
//
//  Created by adulphan youngmod on 21/8/18.
//  Copyright © 2018 goldbac. All rights reserved.
//

import Foundation

import Foundation
import CloudKit

extension OperationCloudKit  {
    
    func ensureZoneForFinancialData() {
        
        let operation = CKFetchRecordZonesOperation.fetchAllRecordZonesOperation()
        operation.fetchRecordZonesCompletionBlock = { (recordZones, error) in
            
            if error != nil { print(error!) ; return }
            let zoneID = CloudKit.financialDataZoneID
            let isContained = recordZones?.contains(where: { (dictionary) -> Bool in
                dictionary.value.zoneID == zoneID
            }) ?? false
            
            if isContained {
                print("FinancialData: zone already created")
            } else {
                self.createZoneForFinancialData()
            }
        }
        
        CloudKit.privateDatabase.add(operation)
        
    }
    
    private func createZoneForFinancialData() {
        
        let zoneID = CloudKit.financialDataZoneID
        let zone = CKRecordZone(zoneID: zoneID)
        
        let operation = CKModifyRecordZonesOperation(recordZonesToSave: [zone], recordZoneIDsToDelete: nil)
        operation.modifyRecordZonesCompletionBlock = { (zones, zoneIDs, error) in
            if error != nil { print(error!) ; return }
            print(zones!)
            print("FinancialData: successfully created")
        }
        
        CloudKit.privateDatabase.add(operation)
    }
    
    func deleteAllZone() {

        let zoneID = CloudKit.financialDataZoneID
        let operation = CKModifyRecordZonesOperation(recordZonesToSave: nil, recordZoneIDsToDelete: [zoneID])
        operation.modifyRecordZonesCompletionBlock = { (zones, zoneIDs, error) in
            if error != nil { print(error!) ; return }
            for id in zoneIDs! {
                 print(id.zoneName," is deleted")
            }
        }
        CloudKit.privateDatabase.add(operation)
        
    }
    
}







