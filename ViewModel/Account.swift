//
//  Account.swift
//  Jupiter
//
//  Created by adulphan youngmod on 11/8/18.
//  Copyright © 2018 goldbac. All rights reserved.
//

import Foundation
import CloudKit
import UIKit

class Account {
    
    var name: String?
    var imageRecordID: String?
    var beginBalance: Double?
    var endBalance: Double?
    var modified: Date?
    var type: Int16?

    init?(record: CKRecord) {
        
        name = record.value(forKey: "name") as? String
        imageRecordID = record.value(forKey: "imageRecordID") as? String
        beginBalance = record.value(forKey: "beginBalance") as? Double
        endBalance = record.value(forKey: "endBalance") as? Double
        modified = record.modificationDate
        type = record.value(forKey: "type") as? Int16
    
    }

    init() {
        
    }
    
    
}







