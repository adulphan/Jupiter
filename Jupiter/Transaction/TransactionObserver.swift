//
//  TransactionObserver.swift
//  Jupiter
//
//  Created by adulphan youngmod on 17/8/18.
//  Copyright © 2018 goldbac. All rights reserved.
//

import Foundation
import UIKit

extension Transaction: CloudKitProtocol {
    
    
    public override func willSave() {
        super.willSave()
        let changeKeys = changedValues().map{$0.key}
        setPrimitiveValue(committedValues(forKeys: changeKeys) as NSObject, forKey: "cachedValues")
        setPrimitiveValue(Date(), forKey: "modifiedLocal")
        screeningForCloudKit()

    }
    
    public override func didSave() {
        super.didSave()
        updateMonthFlows()
        

    }

}











