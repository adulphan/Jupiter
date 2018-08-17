//
//  String.swift
//  Jupiter
//
//  Created by adulphan youngmod on 16/8/18.
//  Copyright © 2018 goldbac. All rights reserved.
//

import Foundation

extension String {
    func createUUID() -> UUID? {
        return UUID(uuidString: self)
    }
    
}
