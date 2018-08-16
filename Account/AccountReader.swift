//
//  ReadOnlyProtocol.swift
//  Jupiter
//
//  Created by adulphan youngmod on 15/8/18.
//  Copyright © 2018 goldbac. All rights reserved.
//

import Foundation

extension Account: AccountReader {}

protocol AccountReader: SystemField {
    
    var name: String? { get }
    var modifiedLocal: Date? { get }
    var beginBalance: Int64 { get }
    var endBalance: Int64 { get }
    var type: Int16 { get }
    var company: Company? { get }
    var recordID: String? { get }
    
}


protocol SystemField {
    var name: String? { get }
    var modifiedLocal: Date? { get }
    var recordID: String? { get }
    
}










