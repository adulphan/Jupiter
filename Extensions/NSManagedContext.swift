//
//  NSManagedObjectContext.swift
//  Jupiter
//
//  Created by adulphan youngmod on 9/9/18.
//  Copyright © 2018 goldbac. All rights reserved.
//

import Foundation
import CoreData

extension NSManagedObjectContext {
    
    
    func existingObjectWith(recordName: String?, type: CoreData.dataType) -> Any? {
        do {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: type.rawValue)
            if let id = recordName?.uuid() {
                fetchRequest.predicate = NSPredicate(format: "identifier == %@", id as CVarArg)
            }
//            fetchRequest.includesPropertyValues = true
//            fetchRequest.resultType = .managedObjectResultType
            fetchRequest.propertiesToFetch = ["name"]
            fetchRequest.fetchLimit = 1
            let fetchedResults = try self.fetch(fetchRequest)
            if let object = fetchedResults.first {
                return object
            }
        }
        catch { print ("fetch existing object failed", error) }
        return nil
    }
    
    
    func existingObject(with: String) -> NSManagedObject? {
        
        guard let uri = URL(string: with) else {return nil}
        
        
        if let objectID = persistentStoreCoordinator?.managedObjectID(forURIRepresentation: uri) {
            
            do {
                let object = try existingObject(with: objectID)
                return object
                
            } catch  {
                
                
                return nil
            }

        } else {
            
            
            return nil
        }
    }
    
    
    func delete(objects: [NSManagedObject]) {
        self.performAndWait {
            for object in objects {
                self.delete(object)
            }
        }
    }
    
    func saveData() {
        self.performAndWait {
            if self.hasChanges {
                do {
                    try self.save()
                } catch {
                    
                    let nserror = error as NSError
                    print("")
                    print("Description: ",nserror.userInfo["NSLocalizedDescription"] ?? "no description")
                    print("")
                    print(nserror)
                    print("")
                    print(nserror.userInfo)
                    fatalError("Unresolved error")
                }
            }
        }

    }
    
    func clearData() {
        
        let entityName = CoreData.dataType.allValues
        for name in entityName {
            let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: name.rawValue)
            let request = NSBatchDeleteRequest(fetchRequest: fetch)
            do { try self.execute(request)
            } catch  { print("Deleting \(name) failed") }
        }
        
    }
    
    func printSystemField() {
        
        for name in CoreData.dataType.allValues {
            do {
                let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: name.rawValue)
                let fetchedResults = try self.fetch(fetchRequest)
                for object in fetchedResults {
                    if let obj = object as? SystemField {
                        print("\(name.rawValue) : \(obj.identifier?.uuidString.dropLast(25) ?? "no id") : \(obj.name ?? "no name")")
                    }
                }
                
            }
            catch { print ("print object failed", error) }
        }
        
    }

}







