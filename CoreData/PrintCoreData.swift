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
            let result: [Company] = try CoreData.context.fetch(Company.fetchRequest())
            print("----------------------------------------")
            for object in result  {
                print("company: \(object.name ?? "no company name") : \(object.recordID ?? "no id")")
                
            }
        } catch {
            print("Printing CompanyData failed")
        }
        
        do {
            let result: [Account] = try CoreData.context.fetch(Account.fetchRequest())
            print("----------------------------------------")
            for object in result {
                print("account: \(object.name ?? "no account name") : \(object.recordID ?? "no id")")
                
                let attributes = object.entity.attributesByName
                for (name, _) in  attributes {
                    print("    ",name, "=", object.value(forKey: name) ?? "no value")
                }
   
            }
        } catch {
            print("Printing Account failed")
        }
        
        do {
            let result: [Transaction] = try CoreData.context.fetch(Transaction.fetchRequest())
            print("----------------------------------------")
            for object in result {
                print("transaction: \(object.name ?? "no account name") : \(object.recordID ?? "no id")")
                print("   accounts: \(object.accounts.map{$0.name!})")
                
                let attributes = object.entity.attributesByName
                for (name, _) in  attributes {
                    print("    ",name, "=", object.value(forKey: name) ?? "no value")
                }
                
            }
        } catch {
            print("Printing Transaction failed")
        }
        
    }

}
