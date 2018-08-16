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
    static var allCompanyInCoreData: [Company] = []
    static var allAccountsInWorkingCompany: [Account] = []
    static var allAccountsInCoreDate: [Account] = []
}

protocol AccessCoreData {
    
    
}

protocol CoreDataForAdmin: AccessCoreData {
    

}

