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
    
    
    func printMonthFor(account: Account) {
        print("")
        print("Monthly balance: \(account.name ?? "no account name")")
        do {
            let fetchRequest: NSFetchRequest<Month> = Month.fetchRequest()
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: "endDate", ascending: false)]
            fetchRequest.predicate = NSPredicate(format: "account == %@", account)
            let fetchedResults = try CoreData.context.fetch(fetchRequest)
            for object in fetchedResults {
                print("\(object.endDate?.description ?? "no date") flow: \(object.flows) balance: \(object.balance)")
            }
            
        }
        catch { print ("print object failed", error) }
        
        
    }

    func printOutCoreData() {
        for type in CoreData.dataType.allValues {
            print("")
            printData(type: type)
        }

    }
    
    func printTransaction() {
        print("")
        do {
            let fetchRequest: NSFetchRequest<Transaction> = Transaction.fetchRequest()
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
            let fetchedResults = try CoreData.context.fetch(fetchRequest)
            for object in fetchedResults {
                print("\(object.date?.description ?? "no date") : \(object.name ?? "no name") :\(object.accounts.map{$0.name!}) : \(object.flows)")
            
            }
            
        }
        catch { print ("print object failed", error) }
        
    }
    
    private func printData(type: CoreData.dataType) {
        
        do {
            
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: type.rawValue)
            let fetchedResults = try CoreData.context.fetch(fetchRequest)
            for object in fetchedResults {

                if let obj = object as? SystemField {
                    print("\(type.rawValue) : \(obj.identifier?.uuidString ?? "no id") : \(obj.name ?? "no name")")
                }
                
//                if let obj = object as? Account {
//                    print(obj.transactions.map{$0.name!})
//                }
                
                if let obj = object as? Transaction {
                    print(obj.date!)
                    print(obj.accounts.map{$0.name!})
                    print(obj.flows)
                }
                
            }
            
        }
        catch { print ("print object failed", error) }
        
    }
    
    
    

}
