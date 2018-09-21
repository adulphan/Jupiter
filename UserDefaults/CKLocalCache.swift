//
//  CKLocalCache.swift
//  Jupiter
//
//  Created by adulphan youngmod on 13/8/18.
//  Copyright © 2018 goldbac. All rights reserved.
//

import Foundation
import CloudKit

public extension UserDefaults {
    
    public var financialDataChangeToken: CKServerChangeToken? {
        get {
            guard let data = self.value(forKey: "financialDataChangeToken") as? Data else {
                return nil
            }
            
            guard let token = NSKeyedUnarchiver.unarchiveObject(with: data) as? CKServerChangeToken else {
                return nil
            }
            
            return token
        }
        set {
            if let token = newValue {
                let data = NSKeyedArchiver.archivedData(withRootObject: token)
                self.set(data, forKey: "financialDataChangeToken")
            } else {
                self.removeObject(forKey: "financialDataChangeToken")
            }
        }
    }
    
    public var financialDataChangeTokenData: Data? {
        return self.value(forKey: "financialDataChangeToken") as? Data
    }
    
    
}








