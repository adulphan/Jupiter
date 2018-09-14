//
//  CloudkitExtensions.swift
//  Jupiter
//
//  Created by adulphan youngmod on 18/8/18.
//  Copyright © 2018 goldbac. All rights reserved.
//

import Foundation
import CloudKit

extension CKRecord {
    var identifier: UUID {
        return self.recordID.recordName.uuid()!
    }
    
    func updateSystemDataBy(record: CKRecord) -> CKRecord {
        
        for key in record.allKeys() {
            let value = self.value(forKey: key)
            record.setValue(value, forKey: key)
        }
        return record
    }
    
    
    func insertInContext() {
    
        switch recordType {
            
        case CloudKit.recordType.company.rawValue:
            let object = Company(context: CoreData.mainContext)
            object.downloadFrom(record: self)
            
        case CloudKit.recordType.account.rawValue:
            let object = Account(context: CoreData.mainContext)
            object.downloadFrom(record: self)
            
        case CloudKit.recordType.transaction.rawValue:
            let object = Transaction(context: CoreData.mainContext)
            object.downloadFrom(record: self)
            
        default:
            print("No insert")
        }
        
        
    }

}








