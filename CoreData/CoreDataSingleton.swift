//
//  CoreData.swift
//  Jupiter
//
//  Created by adulphan youngmod on 12/8/18.
//  Copyright © 2018 goldbac. All rights reserved.
//

import Foundation
import CoreData
import UIKit

var writeContext: NSManagedObjectContext {
    return CoreData.writeContext
}

var cloudContext: NSManagedObjectContext {
    return CoreData.cloudContext
}

// *** Not save to use

//var workingCompany: Company? {
//    get {
//        if CoreData.workingCompany != nil {
//            return CoreData.workingCompany
//        } else {
//            guard let identifier = UserDefaults.standard.workingCompanyID else { return nil }
//            guard let fetchedCompany = writeContext.existingCompany(recordName: identifier.uuidString) else { return nil }
//            CoreData.workingCompany = fetchedCompany
//            return fetchedCompany
//        }
//    }
//
//    set {
//        CoreData.workingCompany = newValue
//        UserDefaults.standard.workingCompanyID = newValue?.recordName?.uuid()
//    }
//}

class CoreData {
    
    static let coreDataStack = CoreDataStack(modelName: "Jupiter")
//    static let persistentContainer: NSPersistentContainer = {
//        let container = NSPersistentContainer(name: "Jupiter")
//        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
//            if let error = error as NSError? {
//                fatalError("Unresolved error \(error), \(error.userInfo)")
//            }
//        })
//        return container
//    }()
    
    static let persistentStoreCoordinator = coreDataStack.persistentStoreCoordinator
    static let viewContext: NSManagedObjectContext = {
        let context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        context.persistentStoreCoordinator = persistentStoreCoordinator
        context.name = "viewContext"
        return context
    }()
    static let cloudContext: NSManagedObjectContext = {
        let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        context.persistentStoreCoordinator = persistentStoreCoordinator
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        context.name = "cloudContext"
        return context
    }()
    static let writeContext: NSManagedObjectContext = {
        let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        context.persistentStoreCoordinator = persistentStoreCoordinator
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        context.name = "writeContext"
        return context
    }()
    
    static var workingCompany: Company?

}











