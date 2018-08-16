//
//  LoadCoreData.swift
//  Jupiter
//
//  Created by adulphan youngmod on 13/8/18.
//  Copyright © 2018 goldbac. All rights reserved.
//

import Foundation
import CoreData

extension AccessCoreData {
    
    func reloadData() {
        reloadCompanyData()
        reloadAccountData()
    }
    
    func reloadCompanyData() {
        do {
            let fetchRequest: NSFetchRequest<Company> = Company.fetchRequest()
            let companys = try CoreData.context.fetch(fetchRequest)
            CoreData.allCompanyInCoreData = companys
            //print("Number of company: \(CoreData.allCompanyInCoreData.count.description)")
        } catch {
            print("Loading company failed")
            CoreData.allCompanyInCoreData = []
        }
    }
    
    func reloadAccountData() {
        do {
            let fetchRequest: NSFetchRequest<Account> = Account.fetchRequest()
            let accounts = try CoreData.context.fetch(fetchRequest)
            CoreData.allAccountsInCoreDate = accounts
            //print("Number of accounts: \(CoreData.allAccountsInCoreDate.count.description)")
        } catch {
            print("Loading account failed")
            CoreData.allAccountsInCoreDate = []
        }
    }


}
