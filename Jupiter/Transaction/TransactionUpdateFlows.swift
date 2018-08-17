//
//  Transaction.swift
//  Jupiter
//
//  Created by adulphan youngmod on 17/8/18.
//  Copyright © 2018 goldbac. All rights reserved.
//

import Foundation

extension Transaction {

    func updateBalanceWith(transaction: CachedTransactionValues, isDeleted: Bool) {
        
        let accounts = transaction.accounts
        guard accounts.count != 0 else { return }
        let direction:Int64 = isDeleted ? -1:1
        let flowArray = transaction.flows.map{$0*direction}
        let date = transaction.date!

        for i in 0...accounts.count-1 {
            
            let account = accounts[i]
            let flow = flowArray[i]
            let monthEnd = date.monthEnd.standardized
            
            let monthArray = account.months
            let withSameMonth = monthArray.filter { (month) -> Bool in
                month.endDate == monthEnd
            }
            
//            let index = monthArray.index(where: {$0.endDate! <= monthEnd}) ?? monthArray.count
//
//            
//            
//            
//            
//            
//            
//            
//            
            
            
            
            
            
            if let thisMonth = withSameMonth.first {
                
                thisMonth.flows += flow
                thisMonth.balance += flow
                let index = monthArray.index(of: thisMonth)!
                updateBalanceAbove(index: index, amount: flow, array: account.months)
                
            } else {
                
                let newMonth = Month(context: CoreData.context)
                newMonth.endDate = monthEnd
                newMonth.flows = flow
                
                if let index = monthArray.index(where: {$0.endDate! < monthEnd}) {
                    newMonth.balance = monthArray[index].balance + flow
                    account.months.insert(newMonth, at: index)
                    updateBalanceAbove(index: index, amount: flow, array: account.months)
                    
                } else {
                    newMonth.balance = account.beginBalance + flow
                    account.months.append(newMonth)
                    for month in account.months {
                        if month != newMonth {
                            month.balance += flow
                        }
                    }
                    
                }
            }
        }
        
    }

    
    private func updateBalanceAbove(index: Int, amount: Int64, array: [Month]) {
        if index != 0 {
            for i in 0...index-1 {
                array[i].balance += amount
            }
        }
    }

}

