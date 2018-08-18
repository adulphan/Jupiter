//
//  Number.swift
//  Jupiter
//
//  Created by adulphan youngmod on 15/8/18.
//  Copyright © 2018 goldbac. All rights reserved.
//

import Foundation

extension Int64 {
    
    func currencyDisplay() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currencyAccounting
        formatter.currencySymbol = "$"
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
        let decimal: Decimal = Decimal(self)/100
        let absolute = abs(decimal)
        let amountString: String = formatter.string(from: absolute as NSNumber)!

        return amountString
    }
    
}

extension Int {
    


}











