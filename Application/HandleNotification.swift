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
    
    @objc func writeContextWillSave(_ notification: Notification) {
        if !CloudKit.isFetching {
            cachePendingRecordNames()
        }
        updateMonthFlows()
    }
    
    @objc func writeContextDidSave(_ notification: Notification) {
        if CloudKit.operationQueueIsEmpty {
            
            uploadToCloud()
            //fetchRecords { _ in }
        }
    }
    
    @objc func cloudContextWillSave(_ notification: Notification) {

        
    }
    
    @objc func cloudContextDidSave(_ notification: Notification) {

        
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
        
//        let accounts = writeContext.registeredObjects.filter { (object) -> Bool in
//            object.entity == Account.entity()
//        }
        
//        for object in accounts {
//            let account = object as! Account
//            for month in account.months {
//                if month.flows == 0 {
//                    writeContext.delete(month)
//                }
//            }
//        }
        
    }

}










