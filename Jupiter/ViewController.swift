//
//  ViewController.swift
//  Jupiter
//
//  Created by adulphan youngmod on 11/8/18.
//  Copyright © 2018 goldbac. All rights reserved.
//

import UIKit
import CoreData


class ViewController: UIViewController, CoreDataForAdmin, OperationCloudKit {
    var accountsDictionary: [String : Account] = [:]

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.orange
        
        
//        let wallet = ExistingAccount(name: "Wallet")!
////        let grocery = ExistingAccount(name: "Grocery")!
//        let bofa = ExistingAccount(name: "Bofa")!
////
//// //       wallet.setPrimitiveValue(Date(), forKey: "modifiedLocal")
//////
//        let tranaction = ExistingTransaction(recordName: "B7711F9E-EFE9-41B5-83FC-25A8BE97A72D")!
////
//////        tranaction.accounts = [bofa, grocery]
//        tranaction.willAccessValue(forKey: "name")
//        tranaction.setPrimitiveValue("New Name 55544333", forKey: "name")
//        tranaction.didAccessValue(forKey: "name")
//
//
//        saveCoreData()
        
        //tranaction.setValue(Date().description, forKey: "name")
        
//
        
//        print(bofa.transactions.map{$0.name!})
        
       printOutCoreData()
//
//    SimulateData.shared.simulateData()
//////

//        fetchRecords { (error) in
//            print("fetch complete")
//            self.printOutCoreData()
//        }
//        SimulateData.shared.simulateTransaction()
        
        
 //       loopTransaction(interval: 0.1, times: 5)
//
 //       saveCoreData()
//
//        saveCoreData()
//        printOutCoreData()
//
 //       saveCoreData()
        
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    func loopTransaction(interval: Double, times: Int) {
        
        var count: Int = 0
        _ = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { t in
            print(Date(), "  count : \(count)")
            count += 1
            
            let wallet = self.ExistingAccount(name: "Wallet")!
            let grocery = self.ExistingAccount(name: "Grocery")!
            
            
            //let random = SimulateData.shared.randomInt(min: 0, max: wallet.transactions.count - 1)
            let transaction = wallet.transactions.first!
            CoreData.context.delete(transaction)
            
            //self.saveCoreData()

            let update = wallet.transactions.last!
            update.name = "Update: " + Date().description

            //self.saveCoreData()
            
            let newTransaction = Transaction(context: CoreData.context)
            newTransaction.name = "Creates: " + Date().description
            newTransaction.identifier = UUID()
            newTransaction.date = Date()
            newTransaction.modifiedLocal = Date()
            newTransaction.accounts = [wallet, grocery]
            newTransaction.flows = [-888, 888]

            self.saveCoreData()
            
            if count == times {
                
                print("finish timer loop")
                //self.printOutCoreData()
                t.invalidate()
                
            }
            
        }
    }

}

