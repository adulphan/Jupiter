//
//  AccountDataCloudkit.swift
//  Jupiter
//
//  Created by adulphan youngmod on 13/8/18.
//  Copyright © 2018 goldbac. All rights reserved.
//

import Foundation
import CloudKit

extension Account: AccessCoreData, CloudKitProtocol {
    func prepareToDownload(record: CKRecord) {
        self.identifier = record.recordID.recordName.uuid()
        guard let companyRecordName = record.parent?.recordID.recordName else {
            print("Error: incoming account has no referenced company") ; return
        }
        guard let company = ExistingCompany(recordName: companyRecordName) else {
            print("Error: no record of downloaded account's company") ; return
        }
        self.company = company
    }
    
    
    func prepareToUpload(record: CKRecord) {
        
        guard let companyRecordName = self.company?.identifier?.uuidString else {
            print("Error: uploading account has no referenced company") ; return
        }
        let companyID = CKRecordID(recordName: companyRecordName, zoneID: CloudKit.financialDataZoneID)
        let referenceCompany = CKReference(recordID: companyID, action: .none)
        record.parent = referenceCompany
    }

}






