//
//  ViewController.swift
//  Jupiter
//
//  Created by adulphan youngmod on 11/8/18.
//  Copyright © 2018 goldbac. All rights reserved.
//

import UIKit


class ViewController: UIViewController, CoreDataForAdmin, FetchCloudKit, SimulateData  {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.orange
        
//        clearCoreData()
//        UserDefaults.standard.zoneChangeToken = nil
//
//        fetchChangesFromCloudKit {
//            print("Yo")
//            self.printOutAllCoreData()
//        }
        
        printOutAllCoreData()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

