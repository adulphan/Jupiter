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
    
    func newAccountInWorkingCompany() -> AccountData? {
        guard let companyID = UserDefaults.standard.workingCompanyID else {
            print("No working company")
            return nil
        }
        guard let companyData = ExistingCompanyData(recordID: companyID) else {
            print("No working company with id: \(companyID)")
            return nil
        }
        let account = newAccount(inCompany: companyData)
        return account
    }
    
    func newAccount(inCompany: CompanyData) -> AccountData? {
        let account = AccountData(context: CoreData.context)
        account.companyData = inCompany
        return account
    }
    
    func setAsWorkingCompany(companyData: CompanyData) {
        UserDefaults.standard.workingCompanyID = companyData.recordID
    }

}








