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
        

        
        
//        clearCoreData()
//        UserDefaults.standard.workingCompanyID = nil
//        UserDefaults.standard.financialDataChangeToken = nil
//
//        fetchChangesFromCloudKit {
//            print("finished")
//            self.printOutCoreData()
//        }
        
        
        
       let wallet = ExistingAccount(name: "Grocery")!
        
        let entity = wallet.transactions[0].entity
        
        //print(entity.managedObjectModel.configurations)
        
        let attributes = entity.attributesByName
        
        for att in attributes {

            let type = att.value.attributeValueClassName
            
            print("\(att.key)  type: \(type ?? "nil")")
            
        }
        

        
//        let properties = entity.properties
        
//        for prop in properties {
//
//            print("\(prop.name) type : \(prop))")
//
//        }
//
        

        //printOutCoreData()
        
        //SimulateData.shared.simulateData()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

