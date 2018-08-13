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
        
    }
    
    func clearCoreData() {
        
        do {
            let result = try CoreData.context.fetch(CompanyData.fetchRequest())
            for object in result {
                CoreData.context.delete(object as! NSManagedObject)
            }
        } catch {
            print("Deleting CompanyData failed")
        }
        
        do {
            let result = try CoreData.context.fetch(AccountData.fetchRequest())
            for object in result {
                CoreData.context.delete(object as! NSManagedObject)
            }
        } catch {
            print("Deleting AccountData failed")
        }
        
        saveCoreData()
        
    }
    
    func clearAccountData() {
        
        do {
            let result = try CoreData.context.fetch(AccountData.fetchRequest())
            for object in result {
                CoreData.context.delete(object as! NSManagedObject)
            }
        } catch {
            print("Deleting AccountData failed")
        }
        
        saveCoreData()
        
    }
    
    
    
}
