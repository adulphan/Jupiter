//
//  AccountValidation.swift
//  Jupiter
//
//  Created by adulphan youngmod on 19/8/18.
//  Copyright © 2018 goldbac. All rights reserved.
//

import Foundation


extension Account {
    
    enum errorCode: Int {
        case requiredFieldNotMet = 0

    }

    public override func validateForInsert() throws {
        try super.validateForInsert()
        
        let errorDomain = "Account Insert"
        
        var error: NSError? = nil
        let areAllReqiredFieldsEntered = name != nil && identifier != nil && company != nil
        
        if !areAllReqiredFieldsEntered {
            let description = " - Required fields are not all entered"
            error = NSError(domain: errorDomain, code: errorCode.requiredFieldNotMet.rawValue, userInfo: [ NSLocalizedDescriptionKey : errorDomain + description] )
             if let error = error { throw error }
        }

    }
    
}
