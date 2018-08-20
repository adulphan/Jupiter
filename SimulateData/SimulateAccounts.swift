//
//  SimulateAccounts.swift
//  goldbac
//
//  Created by adulphan youngmod on 4/8/18.
//  Copyright © 2018 goldbac Inc. All rights reserved.
//

import Foundation
import UIKit
import CoreData


extension SimulateData {
    
    func simulateCompany() {
        
        if workingCompany == nil {
            
            let company = Company(context: CoreData.context)
            
            company.name = "Apple Inc."
            company.identifier = UUID()
            company.modifiedLocal = Date()
            
            setAsWorkingCompany(company: company)
            print("Company: \(company.recordName) is set workingCompany")
        }
        
    }

    func simulateAccounts() {

//        let cashName = ["wallet"]
//        let cardName = ["amex","citi"]
//        let bankName = ["bofa","barclays","chase","suntrust"]
//        let expenseName = ["grocery","eatout","fuel","utility","medical","home","car","appliance","subscription","family","interest expense"]
//        let incomeName = ["salary", "interest income"]
//        let assetName = ["savings","land","stock"]
//        let debtName = ["auto leasing","homeLoan","personalLoan"]
//        let equityName = ["adjustmant","paidup"]
//        let accountName = [cashName,cardName,bankName,expenseName,incomeName,assetName,debtName,equityName]
        let accountName = [["wallet", "grocery", "bofa"]]
        
        for array in accountName {
            
            let type = accountName.index(of: array)!
            for name in array {
                
                guard let newAcount = newAccountInWorkingCompany() else { return }
                
                
                newAcount.name = String(name.uppercased().first!) + String(name.dropFirst())
                newAcount.type = Int16(type)
                newAcount.beginBalance = 0
                newAcount.endBalance = 0
                newAcount.modifiedLocal = Date()
                newAcount.identifier = UUID()
            }
        }

    }

}
