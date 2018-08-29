//
//  TransactionExtensions.swift
//  Jupiter
//
//  Created by adulphan youngmod on 17/8/18.
//  Copyright © 2018 goldbac. All rights reserved.
//

import Foundation

extension Transaction  {

    var accounts: [Account] {
        get{ return accountSet?.array as! [Account] }
        set{
            
//            accountSet = NSOrderedSet(array: newValue)
            let set = NSOrderedSet(array: newValue)
            self.willAccessValue(forKey: "accountSet")
            self.setPrimitiveValue(set, forKey: "accountSet")
            self.didAccessValue(forKey: "accountSet")
        }
    }

}





