//
//  ResolveConflicts.swift
//  Jupiter
//
//  Created by adulphan youngmod on 22/8/18.
//  Copyright © 2018 goldbac. All rights reserved.
//

import Foundation


extension OperationCloudKit {
    
    func resolveConflicts(completion: @escaping () -> Void) {
        
        let incomingSaveRecords = CloudKit.recordsToSaveToCoreData
        let incomingDeleteRecords = CloudKit.recordIDToDeleteFromCoreData
        
        var outgoingSaveRecords = CloudKit.recordsToSaveToCloudKit
        var outgoingDeleteRecords = CloudKit.recordIDsToDeleteFromCloudKit
        
        
        for recordID in incomingDeleteRecords {
            for record in outgoingSaveRecords {
                if record.recordID.recordName == recordID.recordName {
                    let index = outgoingSaveRecords.index(of: record)
                    outgoingSaveRecords.remove(at: index!)
                }
            }
            for recordID in outgoingDeleteRecords {
                if recordID.recordName == recordID.recordName {
                    let index = outgoingDeleteRecords.index(of: recordID)
                    outgoingDeleteRecords.remove(at: index!)
                }
            }
        }
        
        for recordID in outgoingDeleteRecords {
            for record in incomingSaveRecords {
                if record.recordID.recordName == recordID.recordName {
                    let index = incomingSaveRecords.index(of: record)
                    outgoingSaveRecords.remove(at: index!)
                }
            }
        }
        
        
        completion()
    }
    
    
}