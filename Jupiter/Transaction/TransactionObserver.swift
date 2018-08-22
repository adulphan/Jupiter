//
//  TransactionObserver.swift
//  Jupiter
//
//  Created by adulphan youngmod on 17/8/18.
//  Copyright © 2018 goldbac. All rights reserved.
//

import Foundation

extension Transaction {
    
    public override func willSave() {
        super.willSave()
        setPrimitiveValue(Date(), forKey: "modifiedLocal")
        setPrimitiveValue(changedValues() as NSObject, forKey: "cachedValues")
    }
    
    public override func didSave() {
        super.didSave()
        proceedToCloudKit()
        updateMonthFlows()
        cachedValues = nil
    }
    



}











