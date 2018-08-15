//
//  SimulateCoreData.swift
//  Jupiter
//
//  Created by adulphan youngmod on 12/8/18.
//  Copyright © 2018 goldbac. All rights reserved.
//

import Foundation
import CoreData
import UIKit

protocol SimulateData: AccessCoreData {

}

extension SimulateData {
    
    func simulateData() {
        
        reloadCompanyData()
        
        if workingCompany == nil {
            let company = CompanyData(context: CoreData.context)
            company.name = "Apple Inc."
            company.note = "note note go go 333"
            company.recordID = UUID().uuidString
            company.modifiedLocal = Date()
            
            setAsWorkingCompany(companyData: company)
            saveCoreData()
            reloadCompanyData()
        }

        guard let account = newAccountInWorkingCompany() else { return }
        account.name = "Wallet"
        account.favourite = false
        account.recordID = UUID().uuidString
        account.type = 2
        account.modifiedLocal = Date()        

        saveCoreData()
    }
    
}











