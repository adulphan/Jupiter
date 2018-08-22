//
//  CompanyDataCloudKit.swift
//  Jupiter
//
//  Created by adulphan youngmod on 13/8/18.
//  Copyright © 2018 goldbac. All rights reserved.
//

import Foundation
import CloudKit

extension Company: CloudKitProtocol {
    func prepareToDownload(record: CKRecord) {
        self.identifier = record.recordID.recordName.uuid()
    }

    func prepareToUpload(record: CKRecord) {}

}
