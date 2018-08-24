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
        
        
        guard CloudKit.hasOutgoings && CloudKit.hasIncomings else { return }
        
        
        var incomingSaveRecords = CloudKit.incomingSaveRecords.map{$0.recordID.recordName}
        let incomingDeleteRecords = CloudKit.incomingDeleteRecordIDs.map{$0.recordName}
        
        var outgoingSaveRecords = CloudKit.outgoingSaveRecords.map{$0.recordID.recordName}
        let outgoingDeleteRecords = CloudKit.outgoingDeleteRecordIDs.map{$0.recordName}
        
        let cloudHasDeleted = incomingDeleteRecords.filter(outgoingSaveRecords.contains)
        for recordName in cloudHasDeleted {
            let index = outgoingSaveRecords.index(of: recordName)
            CloudKit.outgoingSaveRecords.remove(at: index!)
        }
        
        let deviceHasDeleted = outgoingDeleteRecords.filter(incomingSaveRecords.contains)
        for recordName in deviceHasDeleted {
            let index = incomingSaveRecords.index(of: recordName)
            CloudKit.incomingSaveRecords.remove(at: index!)
        }

        let duplicateDelete = outgoingDeleteRecords.filter(incomingDeleteRecords.contains)
        for recordName in duplicateDelete {
            let index = outgoingDeleteRecords.index(of: recordName)
            CloudKit.outgoingDeleteRecordIDs.remove(at: index!)
            
            let index2 = incomingDeleteRecords.index(of: recordName)
            CloudKit.incomingDeleteRecordIDs.remove(at: index2!)
        }
        
        incomingSaveRecords = CloudKit.incomingSaveRecords.map{$0.recordID.recordName}
        outgoingSaveRecords = CloudKit.outgoingSaveRecords.map{$0.recordID.recordName}
        
        let competingSave = incomingSaveRecords.filter(outgoingSaveRecords.contains)
        for recordName in competingSave {
            let index1 = incomingSaveRecords.index(of: recordName)
            let incoming = CloudKit.incomingSaveRecords[index1!]
            
            let index2 = outgoingSaveRecords.index(of: recordName)
            let outgoing = CloudKit.outgoingSaveRecords[index2!]
            
            let incomingDate = incoming.value(forKey: "modifiedLocal") as! Date
            let outgoingDate = outgoing.value(forKey: "modifiedLocal") as! Date
            
            if outgoingDate > incomingDate {
                CloudKit.incomingSaveRecords.remove(at: index1!)
            } else {
                CloudKit.outgoingSaveRecords.remove(at: index2!)
            }
            
        }
        
        printTransferingRecords()
    }
    
    func printTransferingRecords() {
        
        let incomingSaveRecords = CloudKit.incomingSaveRecords.map{$0.recordID.recordName}
        let incomingDeleteRecords = CloudKit.incomingDeleteRecordIDs.map{$0.recordName}
        
        let outgoingSaveRecords = CloudKit.outgoingSaveRecords.map{$0.recordID.recordName}
        let outgoingDeleteRecords = CloudKit.outgoingDeleteRecordIDs.map{$0.recordName}
        
        print("")
        print("incomingSaveRecords: ", "\(incomingSaveRecords.map{$0.dropLast(28)})")
        print("incomingDeleteRecords: ", "\(incomingDeleteRecords.map{$0.dropLast(28)})")
        print("")
        print("outgoingSaveRecords: ", "\(outgoingSaveRecords.map{$0.dropLast(28)})")
        print("outgoingDeleteRecords: ", "\(outgoingDeleteRecords.map{$0.dropLast(28)})")
        
        
    }
    
    
}














