//
//  CompanyReader.swift
//  Jupiter
//
//  Created by adulphan youngmod on 15/8/18.
//  Copyright © 2018 goldbac. All rights reserved.
//

import Foundation

extension Company: CompanyReader {}

protocol CompanyReader: SystemField {
    
    var name: String? { get }
    var modifiedLocal: Date? { get }
    var identifier: UUID? { get }
    var accounts: [Account] { get }
    
}


protocol SystemField {
    var name: String? { get }
    var modifiedLocal: Date? { get }
    var identifier: UUID? { get }
    
}
