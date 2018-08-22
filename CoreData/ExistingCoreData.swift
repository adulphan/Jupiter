//
//  Protocols.swift
//  Jupiter
//
//  Created by adulphan youngmod on 13/8/18.
//  Copyright © 2018 goldbac. All rights reserved.
//

import Foundation
import CoreData

extension AccessCoreData {
    
    func ExistingCompany(recordName: String) -> Company?  {
        return ExistingObject(recordName: recordName, objectName: nil, type: CoreData.dataType.company) as? Company
        
    }
    
    func ExistingCompany(name: String) -> Company? {
        return ExistingObject(recordName: nil, objectName: name, type: CoreData.dataType.company) as? Company
    }
    
    func ExistingAccount(recordName: String) -> Account? {
        return ExistingObject(recordName: recordName, objectName: nil, type: CoreData.dataType.account) as? Account
        
    }
    
    func ExistingAccount(name: String) -> Account? {
        return ExistingObject(recordName: nil, objectName: name, type: CoreData.dataType.account) as? Account
        
    }

    func ExistingTransaction(recordName: String) -> Transaction? {
        return ExistingObject(recordName: recordName, objectName: nil, type: CoreData.dataType.transaction) as? Transaction
        
    }
    
    private func ExistingObject(recordName: String?, objectName: String?, type: CoreData.dataType) -> Any? {
        do {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: type.rawValue)
            if let id = recordName?.uuid() {
                fetchRequest.predicate = NSPredicate(format: "identifier == %@", id as CVarArg)
            }
            if let name = objectName {
                fetchRequest.predicate = NSPredicate(format: "name == %@", name)
            }
            
            fetchRequest.fetchLimit = 1
            let fetchedResults = try CoreData.context.fetch(fetchRequest)
            if let object = fetchedResults.first {
                return object
            }
        }
        catch { print ("fetch existing object failed", error) }
        return nil
    }
    
    func ExistingObject(recordName: String?) -> NSManagedObject? {
        
        do {
            for type in CoreData.dataType.coreValues {
                let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: type.rawValue)                
                if let id = recordName?.uuid() {
                    fetchRequest.predicate = NSPredicate(format: "identifier == %@", id as CVarArg)
                }

                fetchRequest.fetchLimit = 1
                let fetchedResults = try CoreData.context.fetch(fetchRequest)
                if let object = fetchedResults.first {
                    return object
                }
            }
        }
        catch { print ("fetch existing object failed", error) }
        return nil
    }

}








