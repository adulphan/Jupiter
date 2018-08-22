//
//  ViewController.swift
//  Jupiter
//
//  Created by adulphan youngmod on 11/8/18.
//  Copyright © 2018 goldbac. All rights reserved.
//

import UIKit


class ViewController: UIViewController, CoreDataForAdmin, FetchCloudKit {
    var accountsDictionary: [String : Account] = [:]

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.orange
        

        clearCoreData()
//        UserDefaults.standard.workingCompanyID = nil
        UserDefaults.standard.financialDataChangeToken = nil

        fetchChangesFromCloudKit {
            print("finished")
            self.printOutCoreData()
        }
        
//        SimulateData.shared.simulateData()
//        printOutCoreData()
        
//        saveCoreData()
        //let wallet = ExistingAccount(name: "Wallet")!
        //let grocery = ExistingAccount(name: "Grocery")!
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
//        let account = newAccountInWorkingCompany()
//        account?.name = "Wallet"
//        account?.identifier = UUID()
//        account?.modifiedLocal = Date()
 

        
 //       printOutCoreData()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

