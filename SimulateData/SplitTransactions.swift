//
//  SplitTransactions.swift
//  Jupiter
//
//  Created by adulphan youngmod on 18/8/18.
//  Copyright © 2018 goldbac. All rights reserved.
//

import Foundation

extension SimulateData {
    
    func createPeriodicSplitTransactions(from: [Account], to: [Account], title: [String], amount: [Int64], flowSTD:[Int64], note:String?, url:String? , frequency: Calendar.Component, multiple: Int, count: Int, startDate: Int, flexibleDate:Int) {
        
        for i in 0...count-1 {
            
            let accounts = from + to
            let randomAmount = amount[randomInt(min: 0, max: amount.count-1)]
            let flowArray:[Int64] = flowSTD.map{$0*randomAmount}
            let randomTitle = title[randomInt(min: 0, max: title.count-1)]

            let reference = Calendar.current.date(byAdding: .day, value: startDate, to: Date())
            let addFlex = randomInt(min: -flexibleDate, max: +flexibleDate)
            var date = Calendar.current.date(byAdding: frequency, value: -i*multiple, to: reference!)
            date = Calendar.current.date(byAdding: .day, value: addFlex, to: date!)
            
            let transaction = Transaction(context: CoreData.context)
            transaction.recordID = UUID().uuidString
            transaction.accounts = accounts
            transaction.flows = flowArray
            transaction.name = randomTitle
            transaction.note = note ?? nil
            transaction.url = url ?? nil
            transaction.date = date
            transaction.modifiedLocal = Date()
            
        }
        
        
        
    }
    
    
}
