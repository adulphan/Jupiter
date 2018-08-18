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
        let monthEnd = (transaction.date)!.monthEnd.standardized

        for i in 0...accounts.count-1 {
            
            let account = accounts[i]
            let flow = flowArray[i]
            let monthArray = account.months
            let index = monthArray.index(where: {$0.endDate! <= monthEnd}) ?? monthArray.count
            let isExisted = monthArray.contains { (month) -> Bool in
                month.endDate == monthEnd
            }
            
            if isExisted {
                monthArray[index].flows += flow
                monthArray[index].balance += flow
                updateBalanceAbove(index: index, amount: flow, array: account.months)
                
            } else {
                let newMonth = Month(context: CoreData.context)
                newMonth.endDate = monthEnd
                newMonth.flows = flow
                let previousBalance = index == monthArray.count ? account.beginBalance : monthArray[index].balance
                newMonth.balance = previousBalance + flow
                account.months.insert(newMonth, at: index)
                updateBalanceAbove(index: index, amount: flow, array: account.months)
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

