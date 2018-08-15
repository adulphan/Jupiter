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





