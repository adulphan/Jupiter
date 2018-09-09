//
//  ClearCoreData.swift
//  Jupiter
//
//  Created by adulphan youngmod on 14/8/18.
//  Copyright © 2018 goldbac. All rights reserved.
//

import Foundation
import CoreData

extension CoreDataForAdmin {
    
    func clearCoreData() {
        
        let entityName = ["Company", "Account", "Transaction", "Month", "PendingUpload"]
        
        for name in entityName {
            let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: name)
            let request = NSBatchDeleteRequest(fetchRequest: fetch)
            do { try CoreData.mainContext.execute(request)
            } catch  { print("Deleting \(name) failed") }
        }
        
    }
    
    func clearAccountData() {
        
        let entityName = ["Account", "Transaction", "Month"]
        
        for name in entityName {
            let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: name)
            let request = NSBatchDeleteRequest(fetchRequest: fetch)
            do { try CoreData.mainContext.execute(request)
            } catch  { print("Deleting \(name) failed") }
        }
        
    }

}





