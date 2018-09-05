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

    }
    
    public override func didSave() {
        super.didSave()

//        print(self.recordName," cachedValues: ",(cachedValues as! [String:Any]).map{$0.key})
//        print(self.recordName," changedValues: ",changedValues().map{$0.key})
        
        let relationshipNames = entity.relationshipsByName.map{$0.key}

        //updateMonthFlows()

        if isDeleted || isInserted  {

            proceedToCloudKit()
            return
        }

        let changedKeys = (cachedValues as! [String:Any]).map{$0.key}
        if !Set(changedKeys).isSubset(of: Set(relationshipNames)) && changedKeys != ["recordData"] {


            proceedToCloudKit()
            return
        }

    }
    



}











