//
//  NewCoreData.swift
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
            guard let identifier = UserDefaults.standard.workingCompanyID else { return nil }
            guard let companyData = ExistingCompany(recordName: identifier.uuidString) else { return nil }
            return companyData
        }
    }
    
    func newAccountInWorkingCompany() -> Account? {
        
        
        guard let identifier = UserDefaults.standard.workingCompanyID else {
            print("No working company")
            return nil
        }

        guard let companyData = ExistingCompany(recordName: identifier.uuidString) else {
            print("No working company with id: \(identifier)")
            return nil
        }
        let account = newAccount(inCompany: companyData)
        return account
    }
    
    func newAccount(inCompany: Company) -> Account? {
        let account = Account(context: CoreData.context)
        account.company = inCompany
        return account
    }
    
    func setAsWorkingCompany(company: Company) {
        UserDefaults.standard.workingCompanyID = company.identifier
    }

}








