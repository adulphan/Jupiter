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

        guard CloudKit.operationQueueIsEmpty else { return }
        self.uploadRecords()


    }
    
    @objc func coreDataWillSave(_ notification: Notification) {
        screeningToCloudKit()
        updateMonthFlows()
    }
    
    private func updateMonthFlows() {
        let transactions = CoreData.mainContext.registeredObjects.filter { (object) -> Bool in
            object.entity == Transaction.entity()
        }
        for object in transactions {
            let transaction = object as! Transaction
            transaction.updateMonthFlows()
        }
    }
    
    private func screeningToCloudKit() {
        for object in CoreData.mainContext.registeredObjects {
            
            if let company = object as? Company {
                company.screeningForCloudKit()
            }
            if let account = object as? Account {
                account.screeningForCloudKit()
            }
            if let transaction = object as? Transaction {
                transaction.screeningForCloudKit()
            }
  
        }
    }
    
    

}




