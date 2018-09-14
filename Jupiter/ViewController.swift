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

        printOutCoreData(includeMonths: false, transactionDetails: false)


        print(mainContext.registeredObjects.count)
        
        let transaction = ExistingTransaction(name: "NNNNNNNNNN888")!
        
        
        print(mainContext.registeredObjects.count)
        
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

