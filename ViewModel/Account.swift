//
//  Account.swift
//  Jupiter
//
//  Created by adulphan youngmod on 11/8/18.
//  Copyright © 2018 goldbac. All rights reserved.
//

import Foundation
import CloudKit
import UIKit

class Account: AccountViewModel {

    var coreData: AccountData?
    var name: String
    var image: UIImage
    var modified: Date
    var note: String

    var beginBalance: Int64
    var endBalance: Int64
    var type: Int16
    var favourite: Bool
    var company: Company? {
        get { return getCompany() }
        set {}
    }
    
    required init(coreData: AccountData) {
        
        let defaultImage = UIImage()
        let defaultModified = Date()

        self.coreData = coreData
        self.name = coreData.name ?? "New Account"
        self.image = defaultImage
        if let data = coreData.image, let image = UIImage(data: data) {
            self.image = image
        }
        self.modified = coreData.modified ?? defaultModified
        self.note = coreData.note ?? "No note"
        
        self.beginBalance = coreData.beginBalance
        self.endBalance = coreData.endinBalance
        self.type = coreData.type
        self.favourite = coreData.favourite
        
    }
    
    func getCompany() -> Company? {
        if let data = self.coreData, let companyData = data.companyData {
            let company = Company(coreData: companyData)
            return company
        } else {
            return nil
        }
    }
    
    func printOut() {
        
        print("name: \(self.name)")
        print("image: \(self.image)")
        print("modified: \(self.modified)")
        print("note: \(self.note)")
        print("company: \(self.company?.name ?? "No company")")
        
        print("beginBalane: \(self.beginBalance)")
        print("endBalance: \(self.endBalance)")
        print("type: \(self.type.description)")
        print("favourite: \(self.favourite)")
        
    }

}





