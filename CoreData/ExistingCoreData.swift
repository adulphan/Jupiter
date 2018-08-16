//
//  Protocols.swift
//  Jupiter
//
//  Created by adulphan youngmod on 13/8/18.
//  Copyright © 2018 goldbac. All rights reserved.
//

import Foundation
import CoreData

extension AccessCoreData {
    
    var workingCompany: Company? {
        get{
            guard let companyID = UserDefaults.standard.workingCompanyID else { return nil }
            guard let companyData = ExistingCompany(recordID: companyID) else { return nil }
            return companyData
        }
    }
    
    func ExistingCompany(name: String) -> Company? {
        let filtered = CoreData.allCompanyInCoreData.filter { (data) -> Bool in
            data.name == name
        }
        if let company = filtered.first {
            return company
        }
        //print("No company with name: \(name)")
        return nil
    }
    
    func ExistingCompany(recordID: String) -> Company? {
        let filtered = CoreData.allCompanyInCoreData.filter { (data) -> Bool in
            data.recordID == recordID
        }
        if let company = filtered.first {
            return company
        }
        //print("No company with recordID: \(recordID)")
        return nil
    }
    
    func ExistingAccount(recordID: String) -> Account? {
        reloadAccountData()
        let filtered = CoreData.allAccountsInCoreDate.filter { (data) -> Bool in
            data.recordID == recordID
        }
        if let account = filtered.first {
            return account
        }
        //print("No account with recordID: \(recordID)")
        return nil
    }

}








