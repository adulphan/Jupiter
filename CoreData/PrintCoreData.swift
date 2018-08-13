//
//  PrintCoreData.swift
//  Jupiter
//
//  Created by adulphan youngmod on 13/8/18.
//  Copyright © 2018 goldbac. All rights reserved.
//

import Foundation
import CoreData

extension AccessCoreData {

    func printOutAllCoreData() {
        
        do {
            let result = try CoreData.context.fetch(CompanyData.fetchRequest())
            for object in result {
                let company = Company(coreData: object as! CompanyData)
                company.printOut()
                print("----------------")
            }
        } catch {
            print("Printing CompanyData failed")
        }
        
        do {
            let result = try CoreData.context.fetch(AccountData.fetchRequest())
            for object in result {
                let account = Account(coreData: object as! AccountData)
                account.printOut()
                print("----------------")
            }
        } catch {
            print("Deleting AccountData failed")
        }
        
    }

}
