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

    func printOutCoreData() {
        for type in CoreData.dataType.allValues {
            print("")
            printSystemField(type: type)
        }
        
        printMonths()
        //printTransaction()
    }
    
    private func printSystemField(type: CoreData.dataType) {
        
        do {
            
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: type.rawValue)
            let fetchedResults = try CoreData.context.fetch(fetchRequest)
            for object in fetchedResults {

                if let obj = object as? SystemField {
                    print("\(type.rawValue) : \(obj.identifier?.uuidString.dropLast(25) ?? "no id") : \(obj.name ?? "no name")")
                }
            }
            
        }
        catch { print ("print object failed", error) }
        
    }
    
    private func printMonths() {
        do {
            
            let fetchRequest: NSFetchRequest<Account> = Account.fetchRequest()
            let fetchedResults = try CoreData.context.fetch(fetchRequest)
            for object in fetchedResults {
                print("Monthly flows: ",object.name!)
                for month in object.months {
                    print("\(month.endDate?.description.dropLast(8) ?? "no date") flow: \(month.flows) balance: \(month.balance)")
                }
                print("")
            }
            
        }
        catch { print ("print object failed", error) }
        
    }
    
    private func printTransaction() {
        print("-----------------------------transaction dateils----------------------------------")
        print("")
        do {
            
            let fetchRequest: NSFetchRequest<Transaction> = Transaction.fetchRequest()
            let fetchedResults = try CoreData.context.fetch(fetchRequest)
            for object in fetchedResults {
                for prop in object.entity.propertiesByName {
                    let key = prop.key
                    guard !prop.value.isTransient else { continue }

                    if key == "flows" {
                        print("\(key): ", "\(object.value(forKey: key) as! [Int64])")
                    } else if key == "accountSet" {
                        let value = object.value(forKey: key) as! NSOrderedSet
                        let array = value.array as! [Account]
                        print("\(key): ", "\(array.map{$0.name!})")

                    } else {

                        print("\(key): ", "\(object.value(forKey: key) ?? "nil")")
                    }
                }
                print("")
            }
            
        }
        catch { print ("print object failed", error) }
    }


}
