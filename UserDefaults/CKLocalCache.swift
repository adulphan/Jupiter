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
    
    public var databaseChangeToken: CKServerChangeToken? {
        get {
            guard let data = self.value(forKey: "databaseChangeToken") as? Data else {
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
                self.set(data, forKey: "databaseChangeToken")
            } else {
                self.removeObject(forKey: "databaseChangeToken")
            }
        }
    }
    
    public var zoneChangeToken: CKServerChangeToken? {
        get {
            guard let data = self.value(forKey: "zoneChangeToken") as? Data else {
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
                self.set(data, forKey: "zoneChangeToken")
            } else {
                self.removeObject(forKey: "zoneChangeToken")
            }
        }
    }
}

