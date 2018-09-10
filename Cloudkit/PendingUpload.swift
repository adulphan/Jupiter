//
//  PendingUpload.swift
//  Jupiter
//
//  Created by adulphan youngmod on 8/9/18.
//  Copyright © 2018 goldbac. All rights reserved.
//

import Foundation
import CloudKit

extension PendingUpload {
    
    
    convenience init(record: CKRecord, isDeleted: Bool) {
        self.init(context: pendingContext)        
        self.record = record
        self.date = Date()
        self.delete = isDeleted
        
    }
    
    var recordID: CKRecordID {
        return record!.recordID
    }

}

