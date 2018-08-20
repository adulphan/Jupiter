//
//  Transaction.swift
//  Jupiter
//
//  Created by adulphan youngmod on 17/8/18.
//  Copyright © 2018 goldbac. All rights reserved.
//

import Foundation

extension Transaction {
    
    func updateMonthFlows() {

        if isDeleted {
            updateBalanceWith(transaction: cachedOldValues, isDeleted: true)
            return
        } else if isInserted {
            updateBalanceWith(transaction: self, isDeleted: false)
            return
        } else if isUpdateNeeded {
            updateBalanceWith(transaction: cachedOldValues, isDeleted: true)
            updateBalanceWith(transaction: self, isDeleted: false)
            return
        }
    }

    private func updateBalanceWith(transaction: CachedTransactionValues, isDeleted: Bool) {
        
        let accounts = transaction.accounts
        guard accounts.count != 0 else { return }
        let direction:Int64 = isDeleted ? -1:1
        let flowArray = transaction.flows.map{$0*direction}
        let monthEnd = getMonthEndfrom(date: date!)

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
    
    private var isUpdateNeeded: Bool {
        let old = cachedOldValues
        let new = (self as CachedTransactionValues)
        let isAccountChange = old.accounts != new.accounts
        let isDateChange = old.date != new.date
        let isFlowsChange = old.flows != new.flows
        return isAccountChange || isDateChange || isFlowsChange
        
    }
    
    private var cachedOldValues: CachedValue {
        
        let cachedOldValues = CachedValue()
        let changeValues = cachedValues as! [String: Any]
        
        if let oldDate = changeValues["date"] as? Date {
            cachedOldValues.date =  oldDate
        } else { cachedOldValues.date = self.date }
        
        if let oldAccounts = changeValues["accountSet"] as? NSOrderedSet {
            let array = oldAccounts.array as! [Account]
            cachedOldValues.accounts =  array
        } else { cachedOldValues.accounts = self.accounts }
        
        
        if let flows = changeValues["flowsObject"] as? NSObject {
            cachedOldValues.flows =  (flows as? [Int64])!
        } else { cachedOldValues.flows = self.flows }
        
        return cachedOldValues
    }
    
    private class CachedValue: NSObject, CachedTransactionValues {
        
        var date: Date? = nil
        var accounts: [Account] = []
        var flows: [Int64] = []
        
    }
    
    private func updateBalanceAbove(index: Int, amount: Int64, array: [Month]) {
        if index != 0 {
            for i in 0...index-1 {
                array[i].balance += amount
            }
        }
    }
    
    private func getMonthEndfrom(date: Date) -> Date {
        let calendar = Calendar.standard
        let components = calendar.dateComponents([.year, .month], from: date)
        let startOfMonth = calendar.date(from: components)!
        let firstNextMonth = calendar.date(byAdding: .month, value: 1, to: startOfMonth)!
        let endOfMonth = calendar.date(byAdding: .day, value: -1, to: firstNextMonth)!
        return endOfMonth
    
    }

}

