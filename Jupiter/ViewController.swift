//
//  ViewController.swift
//  Jupiter
//
//  Created by adulphan youngmod on 11/8/18.
//  Copyright © 2018 goldbac. All rights reserved.
//

import UIKit


class ViewController: UIViewController, CoreDataForAdmin, OperationCloudKit {
    var accountsDictionary: [String : Account] = [:]

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.orange
        
        var count: Int = 0
        _ = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: true) { t in
            print(Date(), "  count : \(count)")
            count += 1

            let grocery = self.ExistingAccount(name: "Grocery")!
            //let random = SimulateData.shared.randomInt(min: 0, max: wallet.transactions.count - 1)
            let transaction = grocery.transactions[0]
            transaction.name = "Update: " + Date().description
            self.saveCoreData()

            if count == 3 {

                print("finish timer loop")
                self.printOutCoreData()
                t.invalidate()

            }

        }
        
        
        
        
        

//        clearCoreData()
//
//        UserDefaults.standard.financialDataChangeToken = nil

        
//        exchangeDataWithCloudKit {
//            print("finished")
//            self.printOutCoreData()
//        }
//        operationRefreshToken(dependency: nil) {
//            print("token Refresh!")
//        }
        
//        SimulateData.shared.simulateData()
        
        
//        let time = DispatchTime.now()
//
//        for i in 0...3 {
//
//            let interval = 30
//            DispatchQueue.main.asyncAfter(deadline: time + Double(i*interval)){
//                print(Date().description, " update")
////                    let wallet = self.ExistingAccount(name: "Wallet")!
////                    let random = SimulateData.shared.randomInt(min: 0, max: wallet.transactions.count - 1)
////                    let transaction = wallet.transactions[random]
////                    transaction.name = "Update: " + Date().description
////                    self.saveCoreData()
//
//            }
//
//            DispatchQueue.main.asyncAfter(deadline: time + Double(i*interval) + 10){
//                print(Date().description, " delete")
////                    let wallet = self.ExistingAccount(name: "Wallet")!
////                    let random = SimulateData.shared.randomInt(min: 0, max: wallet.transactions.count - 1)
////                    let transaction = wallet.transactions[random]
////                    CoreData.context.delete(transaction)
////                    self.saveCoreData()
//            }
//
//            DispatchQueue.main.asyncAfter(deadline: time + Double(i*interval) + 20){
//                print(Date().description, "insert")
////                    let wallet = self.ExistingAccount(name: "Wallet")!
////                    let grocery = self.ExistingAccount(name: "Grocery")!
////                    let transaction = Transaction(context: CoreData.context)
////                    transaction.name = "Creates: " + Date().description
////                    transaction.identifier = UUID()
////                    transaction.date = Date()
////                    transaction.accounts = [wallet, grocery]
////                    transaction.flows = [-888, 888]
////                    self.saveCoreData()
//            }
//
//        }
        
        
        
//       SimulateData.shared.simulateTransaciton()
//        saveCoreData()
//        printOutCoreData()
        
//        saveCoreData()
//        let wallet = ExistingAccount(name: "Wallet")!
//
//        wallet.endBalance = 54321
////
//        saveCoreData()
//        printOutCoreData()
//
        
//        let victim = ExistingTransaction(name: "Villa Paseo BB")
//
//        CoreData.context.delete(victim!)
//
//
//        let transaction = ExistingTransaction(name: "Villa Paseo 2")
//
//        transaction?.name = "Villa device change"
//
//        saveCoreData()
//        let grocery = newAccount(inCompany: workingCompany)
        
        
//        printMonthFor(account: grocery)
//        printMonthFor(account: wallet)
        
//        let transaction = Transaction(context: CoreData.context)
//        transaction.name = "Bad transaction"
//        transaction.identifier = UUID()
//        transaction.date = Date()
//        transaction.modifiedLocal = Date()
//        transaction.accounts = [wallet]
//        transaction.flows = [100, 100]
        
        
//
//        let account = newAccount(inCompany: workingCompany!)
//        account?.name = "Grocery"
//        account?.identifier = UUID()
//        account?.modifiedLocal = Date()
//
//
//        CoreData.context.delete(account!)

 //       saveCoreData()
 //       printOutCoreData()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

