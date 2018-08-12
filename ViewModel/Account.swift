//
//  Account.swift
//  Jupiter
//
//  Created by adulphan youngmod on 11/8/18.
//  Copyright © 2018 goldbac. All rights reserved.
//

import Foundation
import CloudKit
import UIKit

class Account: AccountDataModel {

    var name: String?
    var imageFileName: String?
    var modified: Date?
    var reference: String?
    var referenceRecord: CKRecord?
    
    var beginBalance: Double?
    var endBalance: Double?
    var type: Int16?
    var favourite: Bool?
    var companyRecordID: String?
    
    var image: UIImage?
    
    
    

//    required init?(record: CKRecord) {
//
//        referenceRecord = record
//
//        name = record.value(forKey: "name") as? String
//        imageFileName = (record.value(forKey: "imageRecordID") as! CKReference).recordID.recordName
//        modified = record.modificationDate
//        reference = record.value(forKey: "reference") as? String
//
//        beginBalance = record.value(forKey: "beginBalance") as? Double
//        endBalance = record.value(forKey: "endBalance") as? Double
//        type = record.value(forKey: "type") as? Int16
//        favourite = record.value(forKey: "favourite") as? Bool
//
//        companyRecordID = (record.value(forKey: "company") as! CKReference).recordID.recordName
//
//    }

    init?() {
        
    }
    
    
}







