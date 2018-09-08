//
//  CompanyReader.swift
//  Jupiter
//
//  Created by adulphan youngmod on 15/8/18.
//  Copyright © 2018 goldbac. All rights reserved.
//

import Foundation
import CloudKit

extension Company: CompanyReader {}

protocol CompanyReader: SystemField {
    
    var name: String? { get }
    var modifiedLocal: Date? { get }
    var identifier: UUID? { get }
    var accounts: [Account] { get }
    
}


protocol SystemField: CloudKitProtocol {
    var name: String? { get }
    var modifiedLocal: Date? { get }
    var identifier: UUID? { get }
    var recordData: Data? { get }
    
}

extension SystemField {
    
    var systemRecord: CKRecord? {
        guard let data = recordData else { return nil }
        let unarchiver = NSKeyedUnarchiver(forReadingWith: data)
        unarchiver.requiresSecureCoding = true
        let record = CKRecord(coder: unarchiver)!
        return record
    }
    
}








