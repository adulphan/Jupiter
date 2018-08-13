//
//  CloudkitConnect.swift
//  Jupiter
//
//  Created by adulphan youngmod on 13/8/18.
//  Copyright © 2018 goldbac. All rights reserved.
//

import Foundation
import CloudKit

extension CloudkitConnect {
    
    var personalZoneID: CKRecordZoneID { get { return CloudKit.personalZoneID } }
    var accountType: String { get { return CloudKit.recordType.account.rawValue } }
    var companyType: String { get { return CloudKit.recordType.company.rawValue } }
    var database: CKDatabase { get { return CloudKit.database } }
    
}
