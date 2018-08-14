//
//  SaveAndReload.swift
//  Jupiter
//
//  Created by adulphan youngmod on 14/8/18.
//  Copyright © 2018 goldbac. All rights reserved.
//

import Foundation
import CoreData

protocol SaveAndReload {
    
    func saveCoreData()
    func reloadCompanyData()
    func reloadAccountData()
}

extension DataSnatcher: SaveAndReload {
    

    
    
}
