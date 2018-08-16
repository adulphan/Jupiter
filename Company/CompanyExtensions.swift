//
//  CompanyConvenientExtensions.swift
//  Jupiter
//
//  Created by adulphan youngmod on 15/8/18.
//  Copyright © 2018 goldbac. All rights reserved.
//

import Foundation

extension Company {
    
    var accounts: [Account] {
        get {
            return accountSet?.array as! [Account]
        }
    }
    
    public override func validateValue(_ value: AutoreleasingUnsafeMutablePointer<AnyObject?>, forKey key: String) throws {
        if key == "name" && self.isInserted {
            
        }
        
    }
    
}







