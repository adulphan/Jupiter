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


        guard let account = newAccountInWorkingCompany() else { return }
        account.name = "Wallet"
        account.recordID = UUID().uuidString
        account.type = 2
        account.modifiedLocal = Date()
        
        guard let account2 = newAccountInWorkingCompany() else { return }
        account2.name = "Gorcery"
        account2.recordID = UUID().uuidString
        account2.type = 2
        account2.modifiedLocal = Date()
        
        saveCoreData()
        
        let transaction = Transaction(context: CoreData.context)
        transaction.name = "Pay some bills"
        transaction.recordID = UUID().uuidString
        transaction.accounts = [account, account2]
        transaction.date = Date()
        transaction.flows = [234,500]
        
        let transaction2 = Transaction(context: CoreData.context)
        transaction2.name = "Pay some bills 222222"
        transaction2.recordID = UUID().uuidString
        transaction2.accounts = [account, account2]
        transaction2.date = Date()
        transaction2.flows = [1000,1000]

        saveCoreData()        

        
    }
    
}











