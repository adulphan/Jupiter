//
//  CompanyDataObserver.swift
//  Jupiter
//
//  Created by adulphan youngmod on 12/8/18.
//  Copyright © 2018 goldbac. All rights reserved.
//

import Foundation
import UIKit

extension Company: CloudKitProtocol {
    
    public override func willSave() {
        super.willSave()
        
        let changeKeys = changedValues().map{$0.key}
        setPrimitiveValue(committedValues(forKeys: changeKeys) as NSObject, forKey: "cachedValues")
        setPrimitiveValue(Date(), forKey: "modifiedLocal")
    
    }
    
    public override func didSave() {
        super.didSave()
        let relationshipNames = entity.relationshipsByName.map{$0.key}
        let changedKeys = (cachedValues as! [String:Any]).map{$0.key}

        if !Set(changedKeys).isSubset(of: Set(relationshipNames)) || isDeleted || isInserted  {
            proceedToCloudKit()
        }
        
        cachedValues = nil
    }

}
