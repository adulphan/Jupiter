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
        guard let context = notification.object as? NSManagedObjectContext else { return }
        guard context == writeContext else { return }
        
        if CloudKit.operationQueueIsEmpty {
            fetchRecords { _ in }
        }
    }
    
    @objc func coreDataWillSave(_ notification: Notification) {
        
        guard let context = notification.object as? NSManagedObjectContext else { return }
        guard context == writeContext else { return }
        cachePendingRecordNames()
        //updateMonthFlows()
        
    }
    
    private func cachePendingRecordNames() {
        let financialDataType = dataType.coreValues.map{$0.rawValue}
        for object in writeContext.registeredObjects {
            if financialDataType.contains(object.entity.name!) {
                object.proceedToCloud()
            }
        }
    }
    
    private func updateMonthFlows() {
        let transactions = writeContext.registeredObjects.filter { (object) -> Bool in
            object.entity == Transaction.entity()
        }
        for object in transactions {
            let transaction = object as! Transaction
            transaction.updateMonthFlows()
        }
    }

}










