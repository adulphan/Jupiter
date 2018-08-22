//
//  TransactionExtensions.swift
//  Jupiter
//
//  Created by adulphan youngmod on 16/8/18.
//  Copyright © 2018 goldbac. All rights reserved.
//

import Foundation


extension Transaction {
    
    var flows: [Int64] {
        get {
            return flowsObject as! [Int64]
        }
        
        set{
            let object = newValue as NSObject
            flowsObject = object
            
        }        
    }
    
    var accounts: [Account] {
        get {
            return accountSet?.array as! [Account]
        }
        
        set {
            for account in newValue {
                self.addToAccountSet(account)
            }
        }
        
    }

}
