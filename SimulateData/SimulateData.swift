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

class SimulateData: CoreDataForAdmin {

    static let shared = SimulateData()
    static var dummyImageID: String?
    
}

extension SimulateData {
    
    func simulateData() {
        
        clearCoreData()

        simulateCompany()

        simulateAccounts()

        simulateTransaction()

        saveCoreData()

        //printOutCoreData()
        
        
    }
    
    func simulateTransaction() {
        
        let wallet = ExistingAccount(name: "Wallet")!
        let grocery = ExistingAccount(name: "Grocery")!
        //let bofa = ExistingAccount(name: "Bofa")!
        
        createPeriodicTransactions(from: [wallet], to: [grocery], title: ["Big C Mega Bangna", "Villa Paseo", "Tesco Online", "TOPS Mega", "Makro"], amount: [100], note: nil, url: nil, frequency: .year, multiple: 1, count: 6, startDate: 0, flexibleDate:0)

        //510,660,1520,245,2655,345,462
    }
    
    private func simulateSplitTransaction() {
        
        let wallet = ExistingAccount(name: "Wallet")!
        let grocery = ExistingAccount(name: "Grocery")!
        let bofa = ExistingAccount(name: "Bofa")!
        
        createPeriodicSplitTransactions(from: [wallet, bofa], to: [grocery], title: ["Big C Mega Bangna", "Villa Paseo", "Tesco Online", "TOPS Mega", "Makro"], amount: [100], flowSTD: [-1,-1, 2], note: nil, url: nil, frequency: .month, multiple: 1, count: 6, startDate: 0, flexibleDate: 0)
    
    }
    
    func randomInt(min: Int, max: Int) -> Int {
        return min + Int(arc4random_uniform(UInt32(max - min + 1)))
    }
    
}











