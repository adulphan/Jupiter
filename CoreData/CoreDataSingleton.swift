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

var workingCompany: Company? {
    get {
        if CoreData.workingCompany != nil {
            return CoreData.workingCompany
        } else {
            guard let identifier = UserDefaults.standard.workingCompanyID else { return nil }
            guard let fetchedCompany = writeContext.existingCompany(recordName: identifier.uuidString) else { return nil }
            CoreData.workingCompany = fetchedCompany
            return fetchedCompany
        }
    }
    
    set {
        CoreData.workingCompany = newValue
    }
}

class CoreData {

    static let persistentStoreCoordinator = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.persistentStoreCoordinator
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
        let context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        context.persistentStoreCoordinator = persistentStoreCoordinator
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        context.name = "writeContext"
        return context
    }()
    
    static var workingCompany: Company?

}


