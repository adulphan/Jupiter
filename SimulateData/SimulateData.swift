//
//  SimulateCoreData.swift
//  Jupiter
//
//  Created by adulphan youngmod on 12/8/18.
//  Copyright © 2018 goldbac. All rights reserved.
//

import Foundation
import CoreData
import UIKit


class SimulateData {
    
    static let shared = SimulateData()
    
    let context = CoreData.context
    

    func simulateData() {

        let company = CompanyData(context: context)
        company.name = "FaceBook Inc."
        company.note = "note note go go"
        company.recordID = UUID().uuidString
        
        CoreData.saveData(isFromCloudkit: false)
        CoreData.reloadCompany()
        
        let get = CoreData.getCompanyWith(recordID: company.recordID!)

        let account = AccountData(inCompany: get!)
        //account.companyData = company
        account.name = "Bofa"
        account.favourite = false
        account.recordID = UUID().uuidString
        account.type = 2
        
        CoreData.saveData(isFromCloudkit: false)
    }



}











