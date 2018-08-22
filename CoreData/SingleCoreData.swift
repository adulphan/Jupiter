//
//  SingleCoreDataProtocol.swift
//  Jupiter
//
//  Created by adulphan youngmod on 14/8/18.
//  Copyright © 2018 goldbac. All rights reserved.
//

import Foundation
import CoreData

protocol SingleCoreData {
    var workingCompany: CompanyData? { get }
    
    func newAccount(inCompany: CompanyData) -> AccountData
    func newAccountInWorkingCompany() -> AccountData?
    func setAsWorkingCompany(companyData: CompanyData)
    func ExistingCompanyData(name: String) -> CompanyData?
    func ExistingCompanyData(recordID: String) -> CompanyData?
    func ExistingAccountData(recordID: String) -> AccountData?    
    func deleteCoreData(object: NSManagedObject)
    func deleteCoreData(objects: [NSManagedObject])
}

extension DataSnatcher: SingleCoreData {
    
    func newAccount(inCompany: CompanyData) -> AccountData {
        let account = AccountData(context: context)
        account.companyData = inCompany
        return account
    }
    
    var workingCompany: CompanyData? {
        get{
            guard let companyID = UserDefaults.standard.workingCompanyID else { return nil }
            guard let companyData = ExistingCompanyData(recordID: companyID) else { return nil }
            return companyData
        }
    }
    
    func newAccountInWorkingCompany() -> AccountData? {
        guard let companyID = UserDefaults.standard.workingCompanyID else {
            print("No working company")
            return nil
        }
        guard let companyData = ExistingCompanyData(recordID: companyID) else {
            print("No working company with id: \(companyID)")
            return nil
        }
        let account = AccountData(inCompany: companyData)
        return account
    }
    
    func setAsWorkingCompany(companyData: CompanyData) {
        UserDefaults.standard.workingCompanyID = companyData.recordID
    }
    
    func ExistingCompanyData(name: String) -> CompanyData? {
        reloadCompanyData()
        let filtered = allCompanyInCoreData.filter { (data) -> Bool in
            data.name == name
        }
        if let company = filtered.first {
            return company
        }
        //print("No company with name: \(name)")
        return nil
    }
    
    func ExistingCompanyData(recordID: String) -> CompanyData? {
        reloadCompanyData()
        let filtered = allCompanyInCoreData.filter { (data) -> Bool in
            data.recordID == recordID
        }
        if let company = filtered.first {
            return company
        }
        //print("No company with recordID: \(recordID)")
        return nil
    }
    
    func ExistingAccountData(recordID: String) -> AccountData? {
        reloadAccountData()
        let filtered = allAccountsInCoreDate.filter { (data) -> Bool in
            data.recordID == recordID
        }
        if let account = filtered.first {
            return account
        }
        //print("No account with recordID: \(recordID)")
        return nil
    }
    
    func deleteCoreData(object: NSManagedObject) {
        context.delete(object)
    }
    
    func deleteCoreData(objects: [NSManagedObject]) {
        for object in objects {
            context.delete(object)
        }
    }
    
    func reloadCompanyData() {
        do {
            let fetchRequest: NSFetchRequest<CompanyData> = CompanyData.fetchRequest()
            let companys = try context.fetch(fetchRequest)
            allCompanyInCoreData = companys
            //print("Number of company: \(CoreData.allCompanyInCoreData.count.description)")
        } catch {
            print("Loading company failed")
            allCompanyInCoreData = []
        }
    }
    
    func reloadAccountData() {
        do {
            let fetchRequest: NSFetchRequest<AccountData> = AccountData.fetchRequest()
            let accounts = try context.fetch(fetchRequest)
            allAccountsInCoreDate = accounts
            //print("Number of accounts: \(CoreData.allAccountsInCoreDate.count.description)")
        } catch {
            print("Loading account failed")
            allAccountsInCoreDate = []
        }
    }
    
    
    func saveCoreData() {
        
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
        
    }
    
}
