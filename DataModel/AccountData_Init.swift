//
//  AccountData_Init.swift
//  Jupiter
//
//  Created by adulphan youngmod on 13/8/18.
//  Copyright © 2018 goldbac. All rights reserved.
//

import Foundation

extension AccountData {
    convenience init(inCompany: CompanyData) {
        let context = CoreData.context
        self.init(context: context)
        self.companyData = inCompany
        
    }
}
