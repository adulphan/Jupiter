//
//  TransactionProtocol.swift
//  Jupiter
//
//  Created by adulphan youngmod on 17/8/18.
//  Copyright © 2018 goldbac. All rights reserved.
//

import Foundation

extension Transaction: CachedTransactionValues {

    
}

protocol CachedTransactionValues {
    
    var date: Date? { get set }
    var accounts: [Account] { get set }
    var flows: [Int64]? { get set }
    
}
