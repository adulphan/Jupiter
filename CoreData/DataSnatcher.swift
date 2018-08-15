//
//  DataSnatcher.swift
//  Jupiter
//
//  Created by adulphan youngmod on 14/8/18.
//  Copyright © 2018 goldbac. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class DataSnatcher {
    
    static let shared = DataSnatcher()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var allCompanyInCoreData: [CompanyData] = []
    var allAccountsInWorkingCompany: [AccountData] = []
    var allAccountsInCoreDate: [AccountData] = []
    
}
