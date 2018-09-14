//
//  TransactionValidation.swift
//  Jupiter
//
//  Created by adulphan youngmod on 19/8/18.
//  Copyright © 2018 goldbac. All rights reserved.
//

import Foundation


extension Transaction {
    
    enum errorCode: Int {
        case requiredFieldNotMet = 0
        case accountNotMatchFlows = 1
        case flowsNotAddUp = 2
    }
    
//    public override func validateForInsert() throws {
//        try super.validateForInsert()
//        
//        let errorDomain = "Transaction Insert"
//        
//        var error: NSError? = nil
//        let areAllReqiredFieldsEntered = name != nil && identifier != nil && date != nil && flows != nil && accounts != []
//        if !areAllReqiredFieldsEntered {
//            let description = " - Required fields are not all entered"
//            error = NSError(domain: errorDomain, code: errorCode.requiredFieldNotMet.rawValue, userInfo: [ NSLocalizedDescriptionKey : errorDomain + description] )
//            if let error = error { throw error }
//        }
//        
//        if accounts.count != flows?.count {
//            let description = " - Number of accounts(\(accounts.count)) does not match number of flows(\(flows?.count.description ?? "nil"))"
//            error = NSError(domain: errorDomain, code: errorCode.accountNotMatchFlows.rawValue, userInfo: [ NSLocalizedDescriptionKey : errorDomain + description] )
//            if let error = error { throw error }
//        }
//
//        let sum = flows!.reduce(0,+)
//        if sum != 0 {
//            let description = " - Sum of all flows(\(sum)) is not equal zero"
//            error = NSError(domain: errorDomain, code: errorCode.flowsNotAddUp.rawValue, userInfo: [ NSLocalizedDescriptionKey : errorDomain + description] )
//            if let error = error { throw error }
//        }
//
//    }
}
