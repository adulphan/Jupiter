//
//  AccessSaveDelete.swift
//  Jupiter
//
//  Created by adulphan youngmod on 13/8/18.
//  Copyright © 2018 goldbac. All rights reserved.
//

import Foundation
import CoreData

extension AccessCoreData {
    
    func deleteCoreData(object: NSManagedObject) {
        CoreData.context.delete(object)
    }
    
    func deleteCoreData(objects: [NSManagedObject]) {
        for object in objects {
            CoreData.context.delete(object)
        }
    }
    
    func saveCoreData() {
        
        if CoreData.context.hasChanges {
            do {
                try CoreData.context.save()
            } catch {
                
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
        
        reloadCompanyData()
        reloadAccountData()
        
        
    }
    

    
    
    
}
