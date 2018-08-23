//
//  ResolveConflicts.swift
//  Jupiter
//
//  Created by adulphan youngmod on 22/8/18.
//  Copyright © 2018 goldbac. All rights reserved.
//

import Foundation
import CloudKit


extension OperationCloudKit {
    
    func resolveConflicts() {
        printTransferingRecords()
        
        
        guard CloudKit.hasDataToUpload && CloudKit.hasDownloadedData else { return }
        var incomingSaveRecords = CloudKit.recordsToSaveToCoreData.map{$0.recordID.recordName}
        let incomingDeleteRecords = CloudKit.recordIDToDeleteFromCoreData.map{$0.recordName}
        
        var outgoingSaveRecords = CloudKit.recordsToSaveToCloudKit.map{$0.recordID.recordName}
        let outgoingDeleteRecords = CloudKit.recordIDsToDeleteFromCloudKit.map{$0.recordName}
        
        let cloudHasDeleted = incomingDeleteRecords.filter(outgoingSaveRecords.contains)
        for recordName in cloudHasDeleted {
            let index = outgoingSaveRecords.index(of: recordName)
            CloudKit.recordsToSaveToCloudKit.remove(at: index!)
        }
        
        let deviceHasDeleted = outgoingDeleteRecords.filter(incomingSaveRecords.contains)
        for recordName in deviceHasDeleted {
            let index = incomingSaveRecords.index(of: recordName)
            CloudKit.recordsToSaveToCoreData.remove(at: index!)
        }

        let duplicateDelete = outgoingDeleteRecords.filter(incomingDeleteRecords.contains)
        for recordName in duplicateDelete {
            let index = outgoingDeleteRecords.index(of: recordName)
            CloudKit.recordIDsToDeleteFromCloudKit.remove(at: index!)
            
            let index2 = incomingDeleteRecords.index(of: recordName)
            CloudKit.recordIDToDeleteFromCoreData.remove(at: index2!)
        }
        
        incomingSaveRecords = CloudKit.recordsToSaveToCoreData.map{$0.recordID.recordName}
        outgoingSaveRecords = CloudKit.recordsToSaveToCloudKit.map{$0.recordID.recordName}
        
        let competingSave = incomingSaveRecords.filter(outgoingSaveRecords.contains)
        for recordName in competingSave {
            let index1 = incomingSaveRecords.index(of: recordName)
            let incoming = CloudKit.recordsToSaveToCoreData[index1!]
            
            let index2 = outgoingSaveRecords.index(of: recordName)
            let outgoing = CloudKit.recordsToSaveToCloudKit[index2!]
            
            let incomingDate = incoming.value(forKey: "modifiedLocal") as! Date
            let outgoingDate = outgoing.value(forKey: "modifiedLocal") as! Date
            
            if outgoingDate > incomingDate {
                CloudKit.recordsToSaveToCoreData.remove(at: index1!)
            } else {
                CloudKit.recordsToSaveToCloudKit.remove(at: index2!)
            }
            
        }
        
        printTransferingRecords()
    }
    
    func printTransferingRecords() {
        
        let incomingSaveRecords = CloudKit.recordsToSaveToCoreData.map{$0.recordID.recordName}
        let incomingDeleteRecords = CloudKit.recordIDToDeleteFromCoreData.map{$0.recordName}
        
        let outgoingSaveRecords = CloudKit.recordsToSaveToCloudKit.map{$0.recordID.recordName}
        let outgoingDeleteRecords = CloudKit.recordIDsToDeleteFromCloudKit.map{$0.recordName}
        
        print("")
        print("incomingSaveRecords: ", "\(incomingSaveRecords.map{$0.dropLast(28)})")
        print("incomingDeleteRecords: ", "\(incomingDeleteRecords.map{$0.dropLast(28)})")
        print("")
        print("outgoingSaveRecords: ", "\(outgoingSaveRecords.map{$0.dropLast(28)})")
        print("outgoingDeleteRecords: ", "\(outgoingDeleteRecords.map{$0.dropLast(28)})")
        
        
    }
    
    
}














