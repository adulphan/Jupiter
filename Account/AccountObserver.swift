//
//  AccountData.swift
//  Jupiter
//
//  Created by adulphan youngmod on 12/8/18.
//  Copyright © 2018 goldbac. All rights reserved.
//

import Foundation

extension Account: CloudKitProtocol {
    
    public override func willSave() {
        super.willSave()
        setPrimitiveValue(Date(), forKey: "modifiedLocal")
        setPrimitiveValue(changedValues() as NSObject, forKey: "cachedValues")
    }  
    
    public override func didSave() {
        super.didSave()
        let relationshipNames = entity.relationshipsByName.map{$0.key}
        let changedKeys = (cachedValues as! [String:Any]).map{$0.key}
        if !Set(changedKeys).isSubset(of: Set(relationshipNames)) {
            proceedToCloudKit()
        }
        
        cachedValues = nil
    }
}









