//
//  Cloudkit.swift
//  Jupiter
//
//  Created by adulphan youngmod on 12/8/18.
//  Copyright © 2018 goldbac. All rights reserved.
//

import Foundation
import CloudKit

class CloudKit {
    
    enum recordType : String {
        case company = "Company"
        case account = "Account"
        case transaction = "Transaction"
    }
    
    static let database = CKContainer(identifier: "iCloud.goldbac-Inc.goldbac").privateCloudDatabase
    static let personalZoneID = CKRecordZone(zoneName: "Personal").zoneID
    
}

protocol CloudkitConnect {
    
}

extension CloudkitConnect {
    
    var personalZoneID: CKRecordZoneID { get { return CloudKit.personalZoneID } }
    var accountType: String { get { return CloudKit.recordType.account.rawValue } }
    var companyType: String { get { return CloudKit.recordType.company.rawValue } }
    var database: CKDatabase { get { return CloudKit.database } }
    
}






