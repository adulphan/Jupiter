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
    static var allCompanyInCoreData: [CompanyData] = []
    static var allAccountsInWorkingCompany: [AccountData] = []
    static var allAccountsInCoreDate: [AccountData] = []
}

protocol AccessCoreData {
    
}

