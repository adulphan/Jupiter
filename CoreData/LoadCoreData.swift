//
//  LoadCoreData.swift
//  Jupiter
//
//  Created by adulphan youngmod on 13/8/18.
//  Copyright © 2018 goldbac. All rights reserved.
//

import Foundation
import CoreData

extension AccessCoreData {
    
    func reloadCompanyData() {
        do {
            let fetchRequest: NSFetchRequest<CompanyData> = CompanyData.fetchRequest()
            let companys = try CoreData.context.fetch(fetchRequest)
            CoreData.allCompanyInCoreData = companys
            print("Number of company: \(CoreData.allCompanyInCoreData.count.description)")
        } catch {
            print("Loading company failed")
            CoreData.allCompanyInCoreData = []
        }
    }


}
