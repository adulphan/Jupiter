//
//  UserLocalCache.swift
//  Jupiter
//
//  Created by adulphan youngmod on 13/8/18.
//  Copyright © 2018 goldbac. All rights reserved.
//

import Foundation

public extension UserDefaults {

    public var workingCompanyID: UUID? {
        get {
            guard let data = self.value(forKey: "workingCompanyID") as? Data else {
                return nil
            }
            guard let companyID = NSKeyedUnarchiver.unarchiveObject(with: data) as? UUID else {
                return nil
            }
            
            return companyID
        }
        set {
            
            
            if let companyID = newValue {
                
                let data = NSKeyedArchiver.archivedData(withRootObject: companyID)
                self.set(data, forKey: "workingCompanyID")
                
                
            } else {
                self.removeObject(forKey: "workingCompanyID")
            }
        }
    }
    
    public var clientChangeTokenData: Data? {
        get {
            guard let data = self.value(forKey: "clientChangeTokenData") as? Data else {
                return nil
            }
            return data
        }        
        set {
            self.set(newValue, forKey: "clientChangeTokenData")
        }
        
    }

}
