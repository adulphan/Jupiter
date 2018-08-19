//
//  CloudkitExtensions.swift
//  Jupiter
//
//  Created by adulphan youngmod on 18/8/18.
//  Copyright © 2018 goldbac. All rights reserved.
//

import Foundation
import CloudKit


extension CKRecord {
    var identifier: UUID {
        return self.recordID.recordName.uuid()!
    }

}