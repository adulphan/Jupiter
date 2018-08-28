//
//  UploadOperation.swift
//  Jupiter
//
//  Created by adulphan youngmod on 27/8/18.
//  Copyright © 2018 goldbac. All rights reserved.
//

import Foundation
import CloudKit

class UploadFinancialData: CKModifyRecordsOperation, AccessExistingCoreData {
    
    override init() {
        super.init()
        database = CloudKit.privateDatabase
        name = "uploadFinancialData: \(Date().description)"
        savePolicy = .ifServerRecordUnchanged
        recordsToSave = CloudKit.outgoingSaveRecords
        recordIDsToDelete = CloudKit.outgoingDeleteRecordIDs
        
        modifyRecordsCompletionBlock = { (savedRecords, deletedIDs, error) in
            if let err = error as? CKError{
                print(err)
            }
            for record in savedRecords! {
                print("\(record.recordID.recordName) is saved on Cloud")
                
                let data = NSMutableData()
                let archiver = NSKeyedArchiver(forWritingWith: data)
                archiver.requiresSecureCoding = true
                record.encodeSystemFields(with: archiver)
                archiver.finishEncoding()
                
                let object = self.ExistingObject(recordName: record.recordID.recordName)!
                object.setValue(data, forKey: "recordData")
                
            }
            
            for id in deletedIDs! {
                print("\(id.recordName) is deleted from Cloud")
            }
            
            print("Completed: \(self.name!)")
            
        }
    }
    
    
}










