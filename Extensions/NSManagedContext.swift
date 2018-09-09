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
        
        let entityName = ["Company", "Account", "Transaction", "Month", "PendingUpload"]
        
        for name in entityName {
            let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: name)
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







