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

class SimulateData {

    static let shared = SimulateData()
    static var dummyImageID: String?
    
}

extension SimulateData {
    
    func simulateData() {
        
        writeContext.clearData()

        simulateCompanyAndAccounts()

        simulateTransaction()
        
        //simulateSplitTransaction()

        writeContext.saveData()

        writeContext.printAllData(includeMonths: true, transactionDetails: false)
        
    }
    
    func simulateTransaction() {
        
        let wallet = writeContext.existingAccount(name: "Wallet")!
        let grocery = writeContext.existingAccount(name: "Grocery")!
        
        createPeriodicTransactions(from: [wallet], to: [grocery], title: ["Big C Mega Bangna", "Villa Paseo", "Tesco Online", "TOPS Mega", "Makro"], amount: [100], note: nil, url: nil, frequency: .month, multiple: 1, count: 6, startDate: 0, flexibleDate:0)
        
    }
    
    private func simulateSplitTransaction() {
        
        let wallet = writeContext.existingAccount(name: "Wallet")!
        let grocery = writeContext.existingAccount(name: "Grocery")!
        let bofa = writeContext.existingAccount(name: "Bofa")!
        
        createPeriodicSplitTransactions(from: [wallet, bofa], to: [grocery], title: ["Big C Mega Bangna", "Villa Paseo", "Tesco Online", "TOPS Mega", "Makro"], amount: [100], flowSTD: [-1,-1, 2], note: nil, url: nil, frequency: .month, multiple: 1, count: 6, startDate: 0, flexibleDate: 0)
    
    }
    
    func randomInt(min: Int, max: Int) -> Int {
        return min + Int(arc4random_uniform(UInt32(max - min + 1)))
    }
    
}











