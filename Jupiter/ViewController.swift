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

        
        deleteAllRecords { error in
            
            print(error.debugDescription)
            
            DispatchQueue.main.sync {
                SimulateData.shared.simulateData()
                //self.loopTransaction(interval: 0.01, times: 5)
            }
        }

        
//        loopTransaction(interval: 0.01, times: 1000)
        
        
        
        //SimulateData.shared.simulateData()
        
//        let object = cloudContext.existingObject(recordName: "7F74B705-9862-4E30-ACB4-5E0C8A9D7FDE") as? Transaction
//        let record = object?.recordToUpload()
//        print(record)
        
//
//        let record = object.recordToUpload()
//
//        print(record)
        
//        writeContext.printAllData(includeMonths: false, transactionDetails: false)
        
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
            
            let wallet = writeContext.existingAccount(name: "Wallet")!
            let grocery = writeContext.existingAccount(name: "Grocery")!
            
            let transaction = wallet.transactions.first!
            writeContext.delete(transaction)

            let update = wallet.transactions.last!
            update.name = "Update: " + Date().description

            
            let newTransaction = Transaction(context: writeContext)
            newTransaction.name = "Creates: " + Date().description
            newTransaction.identifier = UUID()
            newTransaction.date = Date()
            newTransaction.modifiedLocal = Date()
            newTransaction.accounts = [wallet, grocery]
            newTransaction.flows = [-888, 888]
 
            writeContext.saveData()

            if count == times {
                
                print("finish timer loop")
                t.invalidate()
                
            }
            
        }
    }

}

