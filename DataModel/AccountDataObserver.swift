//
//  AccountData.swift
//  Jupiter
//
//  Created by adulphan youngmod on 12/8/18.
//  Copyright © 2018 goldbac. All rights reserved.
//

import Foundation
import UIKit

extension AccountData {
    
    convenience init(inCompany: CompanyData) {
        let context = CoreData.context
        self.init(context: context)
        self.companyData = inCompany
        
        
    }
    
//    convenience init(recordID: String) {
//        let company = UserDefaults.standard.workingCompanyID
//        self.init(inCompany: company)
//        
//        
//    }
    
    
    public override func didSave() {
        
        if isInserted {
            //CloudKit.shared.saveToCloudkit(account: self)
        }
    }

}




