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
        
        let relationshipNames = entity.relationshipsByName.map{$0.key}
        let changedKeys = (cachedValues as! [String:Any]).map{$0.key}
        updateMonthFlows()
        
        if !Set(changedKeys).isSubset(of: Set(relationshipNames)) || isDeleted || isInserted  {
            proceedToCloudKit()
            cachedValues = nil
            return
        }
        
        guard let set = (cachedValues as! [String:Any])["accountSet"] else { return }
        let array = (set as! NSOrderedSet).array as! [Account]
        if array != self.accounts {
            proceedToCloudKit()
            cachedValues = nil
            return
 
        }
        
//
//
//        proceedToCloudKit()

    }
    



}











