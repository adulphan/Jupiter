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

class CoreData {

    static let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext    
    
    enum dataType : String {
        case company = "Company"
        case account = "Account"
        case transaction = "Transaction"
        case month = "Month"
        
        static let coreValues = [company, account, transaction]
        static let allValues = [company, account, transaction, month]
    }

}

protocol AccessCoreData {
    
    
}

protocol CoreDataForAdmin: AccessCoreData {
    

}

