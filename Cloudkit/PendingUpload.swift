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
    
    
    convenience init(record: CKRecord) {
        self.init(context: mainContext)
        
        self.record = record
        date = Date()
        
    }
    
    var recordID: CKRecordID {
        return record!.recordID
    }

}

