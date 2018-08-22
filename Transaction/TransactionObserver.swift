//
//  TransactionObserver.swift
//  Jupiter
//
//  Created by adulphan youngmod on 16/8/18.
//  Copyright © 2018 goldbac. All rights reserved.
//

import Foundation


extension Transaction {
    

    public override func willSave() {
        super.willSave()
        //dateValidation()
//        if oldValues == nil {
//            //oldValues = committedValues(forKeys: ["date","accountSet","flowsObject"]) as NSObject
//        }
        

    }
    
    
    public override func didSave() {
        super.didSave()
//        print(oldValues ?? "no old value")
//        oldValues = nil
   
    }
    
    
    
    private func dateValidation() {
        if date != date?.standardized {
            date = date?.standardized
        }
    }
}








