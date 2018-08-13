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
    
    static let shared = CloudKit()
    
    enum recordType : String {
        case company = "Company"
        case account = "Account"
        case transaction = "Transaction"
    }
    
    static var isFetchingFromCloudKit:Bool = false
    static let database = CKContainer(identifier: "iCloud.goldbac-Inc.goldbac").privateCloudDatabase
    static let personalZoneID = CKRecordZone(zoneName: "Personal").zoneID
    
}







