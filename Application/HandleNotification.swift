//
//  HandleNotification.swift
//  Jupiter
//
//  Created by adulphan youngmod on 22/8/18.
//  Copyright © 2018 goldbac. All rights reserved.
//

import Foundation
import CoreData

class HandleNotification: OperationCloudKit {
    
    static let shared = HandleNotification()
    @objc func coreDataDidSave(_ notification: Notification) {
        print("contextDidSave")

        if let insertedObjects = notification.userInfo?[NSInsertedObjectsKey] as? Set<NSManagedObject>, !insertedObjects.isEmpty {
            guard let array = Array(insertedObjects) as? [SystemField] else {return}
            for id in array {
                print("Inserted: " ,id.identifier?.uuidString ?? "nil")
            }
 
        }
        if let updatedObjects = notification.userInfo?[NSUpdatedObjectsKey] as? Set<NSManagedObject>, !updatedObjects.isEmpty {

            guard let array = Array(updatedObjects) as? [SystemField] else {return}
            for id in array {
                print("Updateded: ",id.identifier?.uuidString ?? "nil")
            }
        }
        if let deletedObjects = notification.userInfo?[NSDeletedObjectsKey] as? Set<NSManagedObject>, !deletedObjects.isEmpty {

            guard let array = Array(deletedObjects) as? [SystemField] else {return}
            for id in array {
                print("Deleted: ",id.identifier?.uuidString ?? "nil")
            }
        }
        

    }
}
