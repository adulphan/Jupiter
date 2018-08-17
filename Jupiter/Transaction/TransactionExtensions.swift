//
//  TransactionExtensions.swift
//  Jupiter
//
//  Created by adulphan youngmod on 17/8/18.
//  Copyright © 2018 goldbac. All rights reserved.
//

import Foundation

extension Transaction  {
  
    var flows: [Int64] {
        get{
            return flowsObject as! [Int64]
        }
        set{
            flowsObject = newValue as NSObject
        }
    }
    
    var accounts: [Account] {
        get{
            return accountSet?.array as! [Account]
        }
        
        set{
            accountSet = NSOrderedSet(array: newValue)
        }
        
    }
    
    
}





