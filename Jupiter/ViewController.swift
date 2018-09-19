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

class ViewController: UIViewController, OperationCloudKit  {
    var accountsDictionary: [String : Account] = [:]

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        cloudContext.saveData()
        //ensureZoneForFinancialData()
        //SimulateData.shared.simulateData()
        
//
//        deleteAllRecords { error in
//            print(error.debugDescription)
//            DispatchQueue.main.sync {
//                SimulateData.shared.simulateData()
//                //self.loopTransaction(interval: 1, times: 10)
//            }
//        }
//        UserDefaults.standard.financialDataChangeToken = nil
//       self.loopTransaction(interval: 1, times: 500)
//        writeContext.printSystemField()
//        UserDefaults.standard.financialDataChangeToken = nil
        
//        writeContext.clearData()
//        fetchRecords { (error) in
//            print(error.debugDescription)
//            print("finished")
//        }
//
//        writeContext.printAllData(includeMonths: true, transactionDetails: true)
        
//        writeContext.saveData()
        
//        loopTransaction(interval: 0.01, times: 1000)
        
        
        
        //SimulateData.shared.simulateData()
        
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
            
            writeContext.performAndWait {
                writeContext.refreshAllObjects()
                let wallet = writeContext.existingAccount(name: "Wallet")!
                let grocery = writeContext.existingAccount(name: "Grocery")!
                
                
                let count = wallet.transactions.count
                let limit = 10
                let overLimit = max(count - limit, 1)
                let victims = Array(wallet.transactions.dropLast(count-overLimit))
                writeContext.delete(objects: victims)
                
                let update = wallet.transactions.last!
                update.name = "Update: " + Date().description
                
                
                let random = SimulateData.shared.randomInt(min: 0, max: 36)
                let date = Calendar.standard.date(byAdding: .month, value: -random, to: Date())
                
                let newTransaction = Transaction(context: writeContext)
                newTransaction.name = "Creates: " + Date().description
                newTransaction.identifier = UUID()
                newTransaction.date = date
                newTransaction.modifiedLocal = Date()
                newTransaction.accounts = [wallet, grocery]
                newTransaction.flows = [-5000, 5000]
                
                writeContext.saveData()
            }

            if count == times {
                
                print("finish timer loop")
                t.invalidate()
                
            }
            
        }
    }

}

