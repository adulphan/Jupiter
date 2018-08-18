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
        UserDefaults.standard.workingCompanyID = nil
//        UserDefaults.standard.financialDataChangeToken = nil
//
//        fetchChangesFromCloudKit {
//            print("finished")
//            SimulateData.shared.printOutCoreData()
//        }
        
//        let wallet = ExistingAccount(name: "Wallet")
//        wallet?.beginBalance = 1000
//        saveCoreData()
        
        SimulateData.shared.simulateData()
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

