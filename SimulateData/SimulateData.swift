//
//  SimulateCoreData.swift
//  Jupiter
//
//  Created by adulphan youngmod on 12/8/18.
//  Copyright © 2018 goldbac. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class SimulateData: AccessCoreData {

    static let shared = SimulateData()
}

extension SimulateData {
    
    func simulateData() {
        

        simulateAccounts()
        simulateTransaciton()
        
        printTransaction()
        
        saveCoreData()
        
        let wallet = ExistingAccount(name: "Wallet")!
        let grocery = ExistingAccount(name: "Grocery")!
        printMonthFor(account: wallet)
        printMonthFor(account: grocery)
        
    }
    
    
    func simulateTransaciton() {
        
        let wallet = ExistingAccount(name: "Wallet")!
        let grocery = ExistingAccount(name: "Grocery")!
        
        createPeriodicTransactions(from: [wallet], to: [grocery], title: ["Big C Mega Bangna", "Villa Paseo", "Tesco Online", "TOPS Mega", "Makro"], amount: [510,660,1520,245,2655,345,462], note: nil, url: nil, frequency: .month, multiple: 1, count: 12, startDate: 0, flexibleDate:0)
    }
    
    func randomInt(min: Int, max: Int) -> Int {
        return min + Int(arc4random_uniform(UInt32(max - min + 1)))
    }
    
}











