//
//  NSManagedObject.swift
//  Jupiter
//
//  Created by adulphan youngmod on 20/8/18.
//  Copyright © 2018 goldbac. All rights reserved.
//

import Foundation
import CoreData
import CloudKit

extension NSManagedObject {
    
    func downloadfrom(record: CKRecord) {
        
        if let object = self as? Company {
            object.downloadFrom(record: record)
        }
        if let object = self as? Account {
            object.downloadFrom(record: record)
        }
        if let object = self as? Transaction {
            object.downloadFrom(record: record)
        }
    
    }
    
}

extension NSManagedObjectID {
    

}







