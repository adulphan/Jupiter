//
//  ViewController.swift
//  Jupiter
//
//  Created by adulphan youngmod on 11/8/18.
//  Copyright © 2018 goldbac. All rights reserved.
//

import UIKit
import CoreData
import CloudKit

class ViewController: UIViewController, CoreDataForAdmin, OperationCloudKit {
    var accountsDictionary: [String : Account] = [:]

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.orange
        
        
        
        
        
        
//        ensureZoneForFinancialData()
//        deleteAllZone()
//
//        deleteAllRecords { _ in
//            DispatchQueue.main.sync {
//                SimulateData.shared.simulateData()
//            }
//        }
        
        
//        SimulateData.shared.simulateData()
        
//        let company = self.workingCompany!
//        CoreData.context.delete(company)
//        self.saveCoreData(sendToCloudKit: true)
//        self.printOutCoreData(includeMonths: true, transactionDetails: true)
        
//        printOutCoreData(includeMonths: true, transactionDetails: true)
        
        
        
//
//       SimulateData.shared.simulateData()
////
//        let wallet = ExistingAccount(name: "Wallet")!
//        let grocery = ExistingAccount(name: "Grocery")!
//        let bofa = ExistingAccount(name: "Bofa")!
//
//
//        let transaction = wallet.transactions.first!
//
//        transaction.accounts = [bofa,grocery]
//
        
        
        
//        let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
//        context.persistentStoreCoordinator = CoreData.context.persistentStoreCoordinator
//
//        let transaction = ExistingTransaction(name: "Tesco Online")!
//
//        context.delete(transaction)
//
//        do {
//            try context.save()
//        } catch  {
//            print(error)
//        }
//
//        printOutCoreData(includeMonths: true, transactionDetails: false)
        
////        CoreData.context.delete(transaction)
////
////        transaction.accounts = [bofa, grocery]
////
//        saveCoreData(sendToCloudKit: true)
//////
//        printOutCoreData(includeMonths: true, transactionDetails: false)
//
//        let transaction = ExistingTransaction(recordName: "B25B95F9-5056-4EAD-8E55-56CF435B76CB")!
//
//        transaction.name = "New New222"
//
//        saveCoreData(sendToCloudKit: false)
        
//        clearCoreData()
        
//        UserDefaults.standard.financialDataChangeToken = nil
//        fetchRecords { (error) in

            //self.printOutCoreData(includeMonths: true, transactionDetails: true)
//        }
//        printOutCoreData(includeMonths: true, transactionDetails: true)
//
        
//        clearCoreData()
//       SimulateData.shared.simulateData()
        
//       mainContext.printSystemField()
        
//        let company = Company(context: pendingContext)
//        company.name = "Apple in private context"
//        company.identifier = UUID()
//        company.modifiedLocal = Date()
//
//        pendingContext.saveData()
        //pendingContext.printSystemField()
        
        //mainContext.printSystemField()
        
//        let transaction = ExistingTransaction(name: "Big C Mega Bangna")!
//
//        transaction.name = "Big C Mega Bangna 22"
//
//        pendingContext.saveData()
//
//        pendingContext.printSystemField()
        
        deleteAllRecords { _ in
            DispatchQueue.main.sync {
                mainContext.clearData()
                pendingContext.clearData()
                SimulateData.shared.simulateData()
                self.loopTransaction(interval: 0.01, times:10000)
            }
        }
        
//        SimulateData.shared.simulateData()
       
        



    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    func loopTransaction(interval: Double, times: Int) {
        
        var count: Int = 0
        _ = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { t in
            //print(Date(), "  count : \(count)")
            count += 1
            
            let wallet = self.ExistingAccount(name: "Wallet")!
            let grocery = self.ExistingAccount(name: "Grocery")!
            
            let transaction = wallet.transactions.first!
            CoreData.mainContext.delete(transaction)

            let update = wallet.transactions.last!
            update.name = "Update: " + Date().description

            
            let newTransaction = Transaction(context: CoreData.mainContext)
            newTransaction.name = "Creates: " + Date().description
            newTransaction.identifier = UUID()
            newTransaction.date = Date()
            newTransaction.modifiedLocal = Date()
            newTransaction.accounts = [wallet, grocery]
            newTransaction.flows = [-888, 888]
 
            self.saveCoreData(sendToCloudKit: true)

            if count == times {
                
                print("finish timer loop")
                t.invalidate()
                
            }
            
        }
    }

}

