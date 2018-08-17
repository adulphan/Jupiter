//
//  String.swift
//  Jupiter
//
//  Created by adulphan youngmod on 17/8/18.
//  Copyright © 2018 goldbac. All rights reserved.
//

import Foundation


extension String {
    
    func uuid() -> UUID? {
        if let id = UUID(uuidString: self) {
            return id
        } else {
            print("string is not UUID")
            return nil
        }
    }

}
