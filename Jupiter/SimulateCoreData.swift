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

let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

func simulateCoreData() {
  
    clearData()
    
    let newCompanyData = CompanyData(context: context)

    do {try context.save()} catch {}
    
    
    var accounts:[Account] = []
    for i in 0...3 {

        let newAccountData = AccountData(context: context)
        newAccountData.companyData = newCompanyData
        newAccountData.name = "Account name: \(i)"        
        let account = Account(coreData: newAccountData)
        accounts.append(account)
    }

    do {try context.save()} catch {}

    let newCompanyViewModel = Company(coreData: newCompanyData)
    //let newAccountViewModel = Account(coreData: newAccountData)

    print("----------------")
    newCompanyViewModel.printOut()
    print("----------------")
    
    for account in accounts {
        account.printOut()
        print("----------------")
    }
    //newAccountViewModel?.printOut()
    
}

func clearData() {
    
    do {
        let result = try context.fetch(CompanyData.fetchRequest())
        for object in result {
            context.delete(object as! NSManagedObject)
        }
    } catch {
        print("Deleting CompanyData failed")
    }
    
    do {
        let result = try context.fetch(AccountData.fetchRequest())
        for object in result {
            context.delete(object as! NSManagedObject)
        }
    } catch {
        print("Deleting AccountData failed")
    }
    
    
}













