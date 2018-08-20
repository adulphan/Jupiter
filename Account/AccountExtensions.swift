//
//  AccountExtensions.swift
//  Jupiter
//
//  Created by adulphan youngmod on 17/8/18.
//  Copyright © 2018 goldbac. All rights reserved.
//

import Foundation


extension Account {

    var months: [Month] {
        get{
            return monthSet?.array as! [Month]
        }
        
        set{
            monthSet = NSOrderedSet(array: newValue)
        }
    }
    
    var transactions: [Transaction] {
        get{
            return transactionSet?.array as! [Transaction]
        }
        
        set{
            transactionSet = NSOrderedSet(array: newValue)
        }
    }


}






