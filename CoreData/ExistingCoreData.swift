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
    
    func ExistingCompany(recordID: String) -> Company?  {
        return ExistingObject(recordID: recordID, objectName: nil, type: CoreData.dataType.company) as? Company
        
    }
    
    func ExistingCompany(name: String) -> Company? {
        return ExistingObject(recordID: nil, objectName: name, type: CoreData.dataType.company) as? Company
    }
    
    func ExistingAccount(recordID: String) -> Account? {
        return ExistingObject(recordID: recordID, objectName: nil, type: CoreData.dataType.account) as? Account
        
    }
    
    func ExistingAccount(name: String) -> Account? {
        return ExistingObject(recordID: nil, objectName: name, type: CoreData.dataType.account) as? Account
    }

    private func ExistingObject(recordID: String?, objectName: String?, type: CoreData.dataType) -> Any? {
        do {
            
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: type.rawValue)
            if let id = recordID {
                fetchRequest.predicate = NSPredicate(format: "recordID == %@", id)
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
    
    

}








