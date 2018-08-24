//
//  ResolveConflicts.swift
//  Jupiter
//
//  Created by adulphan youngmod on 24/8/18.
//  Copyright © 2018 goldbac. All rights reserved.
//

import Foundation


extension RecordExchange {
    
        func resolveConflicts() {
        printTransferingRecords()
        
        guard hasOutgoings && hasIncomings else { return }
        
        var incomingSaveRecords_int = incomingSaveRecords.map{$0.recordID.recordName}
        let incomingDeleteRecords = incomingDeleteRecordIDs.map{$0.recordName}

        var outgoingSaveRecords_int = outgoingSaveRecords.map{$0.recordID.recordName}
        let outgoingDeleteRecords = outgoingDeleteRecordIDs.map{$0.recordName}
            
        
        let cloudHasDeleted = incomingDeleteRecords.filter(outgoingSaveRecords_int.contains)
        for recordName in cloudHasDeleted {
            let index = outgoingSaveRecords_int.index(of: recordName)
            outgoingSaveRecords.remove(at: index!)
        }
        
        let deviceHasDeleted = outgoingDeleteRecords.filter(incomingSaveRecords_int.contains)
        for recordName in deviceHasDeleted {
            let index = incomingSaveRecords_int.index(of: recordName)
            incomingSaveRecords.remove(at: index!)
        }

        let duplicateDelete = outgoingDeleteRecords.filter(incomingDeleteRecords.contains)
        for recordName in duplicateDelete {
            let index = outgoingDeleteRecords.index(of: recordName)
            outgoingDeleteRecordIDs.remove(at: index!)
            
            let index2 = incomingDeleteRecords.index(of: recordName)
            incomingDeleteRecordIDs.remove(at: index2!)
        }
        
        incomingSaveRecords_int = incomingSaveRecords.map{$0.recordID.recordName}
        outgoingSaveRecords_int = outgoingSaveRecords.map{$0.recordID.recordName}
        
        let competingSave = incomingSaveRecords_int.filter(outgoingSaveRecords_int.contains)
            guard competingSave.count != 0 else { printTransferingRecords(); return }
        for recordName in competingSave {
            let index1 = incomingSaveRecords_int.index(of: recordName)
            let incoming = incomingSaveRecords[index1!]
            
            let index2 = outgoingSaveRecords_int.index(of: recordName)
            let outgoing = outgoingSaveRecords[index2!]
            
            let incomingDate = incoming.value(forKey: "modifiedLocal") as! Date
            let outgoingDate = outgoing.value(forKey: "modifiedLocal") as! Date
            
            if outgoingDate > incomingDate {
                incomingSaveRecords.remove(at: index1!)
            } else {
                outgoingSaveRecords.remove(at: index2!)
            }
            
        }
        
        printTransferingRecords()
    }
    
    func printTransferingRecords() {
        
        let incomingSaveRecords_int = incomingSaveRecords.map{$0.recordID.recordName}
        let incomingDeleteRecords = incomingDeleteRecordIDs.map{$0.recordName}
        
        let outgoingSaveRecords_int = outgoingSaveRecords.map{$0.recordID.recordName}
        let outgoingDeleteRecords = outgoingDeleteRecordIDs.map{$0.recordName}
        
        print("")
        print("incomingSaveRecords: ", "\(incomingSaveRecords_int.map{$0.dropLast(28)})")
        print("incomingDeleteRecords: ", "\(incomingDeleteRecords.map{$0.dropLast(28)})")
        print("")
        print("outgoingSaveRecords: ", "\(outgoingSaveRecords_int.map{$0.dropLast(28)})")
        print("outgoingDeleteRecords: ", "\(outgoingDeleteRecords.map{$0.dropLast(28)})")
        
        
    }
    
}
