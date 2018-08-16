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
            let company = Company(context: CoreData.context)
            company.name = "Apple Inc."
            company.recordID = UUID().uuidString
            company.modifiedLocal = Date()
            
            setAsWorkingCompany(companyData: company)
            saveCoreData()
            reloadCompanyData()
        }

        for _ in 1...2 {
            guard let account = newAccountInWorkingCompany() else { return }
            account.name = "Wallet"
            account.recordID = UUID().uuidString
            account.type = 2
            account.modifiedLocal = Date()
        }

        saveCoreData()
    }
    
}











