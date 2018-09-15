//
//  ExistingData.swift
//  Jupiter
//
//  Created by adulphan youngmod on 14/9/18.
//  Copyright © 2018 goldbac. All rights reserved.
//

import Foundation
import CoreData

extension NSManagedObjectContext {
    
//    var workingCompany: Company? {
//        get{
//            guard let identifier = UserDefaults.standard.workingCompanyID else { return nil }
//            guard let companyData = existingCompany(recordName: identifier.uuidString) else { return nil }
//            return companyData
//        }
//    }
    
    func existingCompany(recordName: String) -> Company?  {
        return existingObject(recordName: recordName, objectName: nil, type: dataType.company.rawValue) as? Company
    }
    
    func existingCompany(name: String) -> Company? {
        return existingObject(recordName: nil, objectName: name, type: dataType.company.rawValue) as? Company
    }
    
    func existingAccount(recordName: String) -> Account? {
        return existingObject(recordName: recordName, objectName: nil, type: dataType.account.rawValue) as? Account
    }
    
    func existingAccount(name: String) -> Account? {
        return existingObject(recordName: nil, objectName: name, type: dataType.account.rawValue) as? Account
    }
    
    func existingTransaction(recordName: String) -> Transaction? {
        return existingObject(recordName: recordName, objectName: nil, type: dataType.transaction.rawValue) as? Transaction
    }
    
    func existingTransaction(name: String) -> Transaction? {
        return existingObject(recordName: nil, objectName: name, type: dataType.transaction.rawValue) as? Transaction
    }
    
    func existingObject(recordName: String, type: dataType.RawValue) -> NSManagedObject? {
       return existingObject(recordName: recordName, objectName: nil, type: type)
    }

    private func existingObject(recordName: String?, objectName: String?, type: String) -> NSManagedObject? {
        do {
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: type)
            if let id = recordName?.uuid() {
                fetchRequest.predicate = NSPredicate(format: "identifier == %@", id as CVarArg)
            }
            if let name = objectName {
                fetchRequest.predicate = NSPredicate(format: "name == %@", name)
            }
            
            fetchRequest.fetchLimit = 1
            let fetchedResults = try self.fetch(fetchRequest)
            if let object = fetchedResults.first {
                return object
            }
        }
        catch { print ("fetch existing object failed", error) }
        return nil
    }
    
    func existingObject(recordName: String) -> NSManagedObject? {        
        for entity in dataType.coreValues {
            do {
                let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entity.rawValue)
                if let id = recordName.uuid() {
                    fetchRequest.predicate = NSPredicate(format: "identifier == %@", id as CVarArg)
                }
                
                fetchRequest.fetchLimit = 1
                let fetchedResults = try self.fetch(fetchRequest)
                if let object = fetchedResults.first {
                    return object
                }
            }
            catch { print ("fetch existing object failed", error) }
        }
        return nil
    }
    
    

    
    
    
    
    
}

