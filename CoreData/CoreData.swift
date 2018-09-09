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

var mainContext: NSManagedObjectContext {
    return CoreData.mainContext
}

var pendingContext: NSManagedObjectContext {
    return CoreData.pendingContext
}

class CoreData {

    static let mainContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    static let pendingContext: NSManagedObjectContext = {
        let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        context.persistentStoreCoordinator = mainContext.persistentStoreCoordinator
        return context
    }()
    


    static var sendToCludKit: Bool = false
    
    enum dataType : String {
        case company = "Company"
        case account = "Account"
        case transaction = "Transaction"
        case month = "Month"
        case pendingUpload = "PendingUpload"
        
        static let coreValues = [company, account, transaction]
        static let allValues = [company, account, transaction, month, pendingUpload]
    }

}

protocol AccessCoreData: AccessExistingCoreData, CreateNewCoreData, SaveAndDeleteCoreData, PrintCoreData {
    
    
}

protocol CoreDataForAdmin: AccessCoreData {
    

}

