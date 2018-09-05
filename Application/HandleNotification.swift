//
//  HandleNotification.swift
//  Jupiter
//
//  Created by adulphan youngmod on 22/8/18.
//  Copyright © 2018 goldbac. All rights reserved.
//

import Foundation
import CoreData

class HandleNotification: OperationCloudKit {
    
    static let shared = HandleNotification()
    @objc func coreDataDidSave(_ notification: Notification) {
        print("CoreDataNotification: contextDidSave")

        guard CloudKit.hasOutgoings else { return }
        guard CloudKit.operationQueueIsEmpty else { return }
        uploadRecords()

    }
}
