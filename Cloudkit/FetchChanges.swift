//
//  FetchChanges.swift
//  Jupiter
//
//  Created by adulphan youngmod on 13/8/18.
//  Copyright © 2018 goldbac. All rights reserved.
//

import Foundation
import CloudKit
import CoreData


protocol FetchCloudKit: AccessCoreData {
    
    
    
}

extension FetchCloudKit  {
    
    func fetchChanges(completion: @escaping () -> Void) {
        
        CloudKit.isFetchingFromCloudKit = true
        
        let option = CKFetchRecordZoneChangesOptions()
        UserDefaults.standard.zoneChangeToken = nil
        option.previousServerChangeToken = UserDefaults.standard.zoneChangeToken
        let operation = CKFetchRecordZoneChangesOperation(recordZoneIDs: [CloudKit.personalZoneID], optionsByRecordZoneID: [CloudKit.personalZoneID:option])

        operation.recordChangedBlock = { (record) in
 
        }
        
        operation.recordWithIDWasDeletedBlock = { (recordID, _) in
            

        }
        
        operation.recordZoneFetchCompletionBlock = { (zoneId, changeToken, _, _, error) in

            if let error = error {
                print("Error fetching zone changes : ", error)
                return
            }

            UserDefaults.standard.zoneChangeToken = changeToken
            print("From recordZoneFetchCompletionBlock : token updated")
        }
        
        CloudKit.database.add(operation)
    }


    
    
}
