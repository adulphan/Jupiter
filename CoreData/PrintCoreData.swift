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
            let result: [CompanyData] = try CoreData.context.fetch(CompanyData.fetchRequest())
            print("----------------------------------------")
            for object in result  {
                print("company: \(object.name ?? "no company name") : \(object.recordID ?? "no id")")
                
            }
        } catch {
            print("Printing CompanyData failed")
        }
        
        do {
            let result: [AccountData] = try CoreData.context.fetch(AccountData.fetchRequest())
            print("----------------------------------------")
            for object in result {
                print("account: \(object.name ?? "no account name") : \(object.recordID ?? "no id")")
            }
        } catch {
            print("Deleting AccountData failed")
        }
        
    }

}
