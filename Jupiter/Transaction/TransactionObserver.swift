//
//  TransactionObserver.swift
//  Jupiter
//
//  Created by adulphan youngmod on 17/8/18.
//  Copyright © 2018 goldbac. All rights reserved.
//

import Foundation

class cachedValue: NSObject {
    
    var date: Date? = nil
    var accounts: [Account]? = nil
    var flows: [Int64]? = nil
    
}


extension Transaction {
    
    public override func willSave() {
        super.willSave()
        
        guard oldValues == nil else { return }
        if isUpdated || isDeleted {
            
            let cachedOldValues = cachedValue()
            if let date = committedValues(forKeys: ["date"]).first?.value as? Date {
                cachedOldValues.date =  date
            }
            
            if let accounts = committedValues(forKeys: ["accountSet"]).first?.value as? NSOrderedSet {
                let array = accounts.array as! [Account]
                cachedOldValues.accounts =  array
            }
            
            if let flows = committedValues(forKeys: ["flowsObject"]).first?.value as? NSObject {
                cachedOldValues.flows =  flows as? [Int64]
            }
            
            oldValues = cachedOldValues
            

        }
    }
    
    
    public override func didSave() {
        super.didSave()

        guard oldValues != nil else { return }
        print("------ oldVales -------")
        
        let values = oldValues as! cachedValue
        
        print(values.date?.description ?? "no date")
        print(values.accounts!.map{$0.name})
        print(values.flows!)
        
        oldValues = nil
        
    }
}






