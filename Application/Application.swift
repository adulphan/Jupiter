//
//  Application.swift
//  Jupiter
//
//  Created by adulphan youngmod on 13/8/18.
//  Copyright © 2018 goldbac. All rights reserved.
//

import Foundation
import CoreData
import CloudKit

//class Application {
//    
//    static var connectedToCloudKit: Bool = true
//    
//}

var cloudIsEnable: Bool = true

enum dataType : String {
    case company = "Company"
    case account = "Account"
    case transaction = "Transaction"
    case month = "Month"
    
    static let coreValues = [company, account, transaction]
    static let allValues = [company, account, transaction, month]
}

protocol SystemField  {
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
