//
//  AccountHelper.swift
//  Jupiter
//
//  Created by adulphan youngmod on 12/8/18.
//  Copyright © 2018 goldbac. All rights reserved.
//

import Foundation
import UIKit

extension Account {
    
    func addNewToCoreData() {
        
        let account = AccountData(context: CoreData.context)
        account.recordID = UUID().uuidString
        account.companyData = self.company?.coreData
        account.beginBalance = self.beginBalance
        account.endBalance = self.endBalance
        account.modifiedLocal = self.modifiedLocal
        account.name = self.name
        account.type = self.type
        //account.image = UIImagePNGRepresentation(self.image)
    }
    
    func printOut() {
        
        print("name: \(self.name)")
        print("image: \(self.image)")
        print("modifiedLocal: \(self.modifiedLocal)")
        print("note: \(self.note)")
        print("company: \(self.company?.name ?? "No company")")
        
        print("beginBalane: \(self.beginBalance)")
        print("endBalance: \(self.endBalance)")
        print("type: \(self.type.description)")
        print("favourite: \(self.favourite)")
        
    }
    

    
    
    
}




