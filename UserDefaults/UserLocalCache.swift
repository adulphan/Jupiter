//
//  UserLocalCache.swift
//  Jupiter
//
//  Created by adulphan youngmod on 13/8/18.
//  Copyright © 2018 goldbac. All rights reserved.
//

import Foundation

public extension UserDefaults {

    public var workingCompanyID: String? {
        get {
            guard let companyID = self.value(forKey: "workingCompanyID") as? String else {
                return nil
            }            
            return companyID
        }
        set {
            if let companyID = newValue {
                self.set(companyID, forKey: "workingCompanyID")
            } else {
                self.removeObject(forKey: "workingCompanyID")
            }
        }
    }

}
