//
//  Company.swift
//  Jupiter
//
//  Created by adulphan youngmod on 11/8/18.
//  Copyright © 2018 goldbac. All rights reserved.
//

import Foundation
import CloudKit

class Company: BaseDataModel {

    var name: String?
    var imageFileName: String?
    var modified: Date?
    var reference: String?
    var referenceRecord: CKRecord?
    
//    required init?(record: CKRecord) {
//        
//        referenceRecord = record
//        
//        name = record.value(forKey: "name") as? String
//        imageFileName = (record.value(forKey: "imageRecordID") as! CKReference).recordID.recordName
//        modified = record.modificationDate
//        reference = record.value(forKey: "reference") as? String
//    }

}











