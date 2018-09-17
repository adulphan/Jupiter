//
//  SaveDeleteData.swift
//  Jupiter
//
//  Created by adulphan youngmod on 14/9/18.
//  Copyright © 2018 goldbac. All rights reserved.
//

import Foundation
import CoreData

extension NSManagedObjectContext {
    
    func delete(objects: [NSManagedObject]) {
        for object in objects {
            self.delete(object)
        }
    }
    
    func saveData() {
        writeContext.performAndWait {
            if self.hasChanges {
                do { try self.save() } catch {
                    let nserror = error as NSError
                    print(nserror)
                }
            }
        }

    }

    func clearData() {
        
        let entityName = dataType.allValues
        for name in entityName {
            let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: name.rawValue)
            let request = NSBatchDeleteRequest(fetchRequest: fetch)
            do { try self.execute(request)
            } catch  { print("Deleting \(name) failed") }
        }
        
    }


}




