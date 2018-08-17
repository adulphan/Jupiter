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
            let result = try CoreData.context.fetch(Company.fetchRequest())
            for object in result {
                CoreData.context.delete(object as! NSManagedObject)
            }
        } catch {
            print("Deleting Company failed")
        }
        
        do {
            let result = try CoreData.context.fetch(Account.fetchRequest())
            for object in result {
                CoreData.context.delete(object as! NSManagedObject)
            }
        } catch {
            print("Deleting Account failed")
        }
        
        do {
            let result = try CoreData.context.fetch(Transaction.fetchRequest())
            for object in result {
                CoreData.context.delete(object as! NSManagedObject)
            }
        } catch {
            print("Deleting Transaction failed")
        }
        
        saveCoreData()
        
    }
    
    func clearAccountData() {
        
        do {
            let result = try CoreData.context.fetch(Account.fetchRequest())
            for object in result {
                CoreData.context.delete(object as! NSManagedObject)
            }
        } catch {
            print("Deleting Account failed")
        }
        
        saveCoreData()
        
    }

}





