//
//  CreateNewCoreData.swift
//  Jupiter
//
//  Created by adulphan youngmod on 22/8/18.
//  Copyright © 2018 goldbac. All rights reserved.
//

import Foundation
import CoreData

protocol CreateNewCoreData {}

extension CreateNewCoreData {
    
    func newAccount(inCompany: Company) -> Account? {
        let account = Account(context: CoreData.context)
        account.company = inCompany
        return account
    }
    
}
