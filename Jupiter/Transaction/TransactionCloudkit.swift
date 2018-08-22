//
//  TransactionCloudkit.swift
//  Jupiter
//
//  Created by adulphan youngmod on 18/8/18.
//  Copyright © 2018 goldbac. All rights reserved.
//

import Foundation
import CloudKit

extension Transaction: AccessCoreData, CloudKitProtocol {
    
    func prepareToUpload(record: CKRecord) {
        var accountReferenceList: [CKReference] = []
        for account in accounts {
            let recordName = account.recordName
            let recordID = CKRecordID(recordName: recordName, zoneID: CloudKit.financialDataZoneID)
            let referenceAccount = CKReference(recordID: recordID, action: .none)
            accountReferenceList.append(referenceAccount)
        }
        record.setObject(accountReferenceList as CKRecordValue, forKey: "accounts")
        record.parent = accountReferenceList.first!

    }
    
    
    func prepareToDownload(record: CKRecord) {
        self.identifier = record.recordID.recordName.uuid()
        let accountReferences = record.value(forKey: "accounts") as! [CKReference]
        var accountArray: [Account] = []
        for reference in accountReferences {
            let recordName = reference.recordID.recordName
            guard let account = ExistingAccount(recordName: recordName) else {
                print("Error: downloading transacton has no match referenceed account") ; return
            }
            accountArray.append(account)
        }
        self.accounts = accountArray
        
    }

    
}









