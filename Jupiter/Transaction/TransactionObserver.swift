//
//  TransactionObserver.swift
//  Jupiter
//
//  Created by adulphan youngmod on 17/8/18.
//  Copyright © 2018 goldbac. All rights reserved.
//

import Foundation

extension Transaction: CloudKitProtocol {
    
    public override func willSave() {
        super.willSave()
        setPrimitiveValue(changedValues() as NSObject, forKey: "cachedValues")
        setPrimitiveValue(Date(), forKey: "modifiedLocal")
    }
    
    public override func didSave() {
        super.didSave()
        
        proceedToCloudKit()
        updateMonthFlows()
        cachedValues = nil
    }
    



}











