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
    
    func newAccountInWorkingCompany() -> Account? {
        guard let companyID = UserDefaults.standard.workingCompanyID else {
            print("No working company")
            return nil
        }
        guard let companyData = ExistingCompany(recordID: companyID) else {
            print("No working company with id: \(companyID)")
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
    
    func setAsWorkingCompany(companyData: Company) {
        UserDefaults.standard.workingCompanyID = companyData.recordID
    }

}








