//
//  CoreData.swift
//  Jupiter
//
//  Created by adulphan youngmod on 12/8/18.
//  Copyright © 2018 goldbac. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class CoreData {
    
    static let shared = CoreData()
    
    static let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    static var allCompanyInCoreData:[CompanyData] = []
    
    static func reloadCompany() {
        do {
            let fetchRequest: NSFetchRequest<CompanyData> = CompanyData.fetchRequest()
            let companys = try context.fetch(fetchRequest)
            allCompanyInCoreData = companys
            print("Number of company: \(allCompanyInCoreData.count.description)")
        } catch {
            print("Loading company failed")
            allCompanyInCoreData = []
        }
    }
    
    static func getCompanyWith(recordID: String) -> CompanyData? {
        let filtered = allCompanyInCoreData.filter { (data) -> Bool in
            data.recordID == recordID
        }
        if let company = filtered.first {
            return company
        }
        print("No company with recordID: \(recordID)")
        return nil
    }
    
    static func getCompanyWith(name: String) -> CompanyData? {
        let filtered = allCompanyInCoreData.filter { (data) -> Bool in
            data.name == name
        }
        if let company = filtered.first {
            return company
        }
        print("No company with name: \(name)")
        return nil
    }
    
    
    
    
    
    
    
    
    static func saveData(isFromCloudkit: Bool) {
        
        if CoreData.context.hasChanges {
            do {
                try CoreData.context.save()
            } catch {

                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }

    }

    static func clearData() {
        
        do {
            let result = try CoreData.context.fetch(CompanyData.fetchRequest())
            for object in result {
                CoreData.context.delete(object as! NSManagedObject)
            }
        } catch {
            print("Deleting CompanyData failed")
        }
        
        do {
            let result = try CoreData.context.fetch(AccountData.fetchRequest())
            for object in result {
                CoreData.context.delete(object as! NSManagedObject)
            }
        } catch {
            print("Deleting AccountData failed")
        }
        
    }
    
    static func printOutAllCoreData() {
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
