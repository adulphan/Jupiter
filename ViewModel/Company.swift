//
//  Company.swift
//  Jupiter
//
//  Created by adulphan youngmod on 11/8/18.
//  Copyright © 2018 goldbac. All rights reserved.
//

import Foundation
import CloudKit
import UIKit

class Company: CompanyViewModel {

    var coreData: CompanyData?

    var name: String
    var image: UIImage
    var modified: Date
    var note: String
    var accounts: [Account] {
        get { return getAllAccounts() }
        set {}
    }
    
    required init(coreData: CompanyData) {
        
        let defaultImage = UIImage()
        let defaultModified = Date()
        
        self.coreData = coreData
        self.name = coreData.name ?? "New Company"
        self.image = defaultImage
        if let data = coreData.image, let image = UIImage(data: data) {
            self.image = image
        }
        self.modified = coreData.modified ?? defaultModified
        self.note = coreData.note ?? "No note"

        self.accounts = []

    }
    
    func getAllAccounts() -> [Account] {
        let accountData = self.coreData?.accountData?.array as! [AccountData]
        var array:[Account] = []
        for data in accountData {
            let account = Account(coreData: data)
            array.append(account)
        }
        return array
    }
    
    func printOut() {
        
        print("name: \(self.name)")
        print("image: \(self.image)")
        print("modified: \(self.modified)")
        print("note: \(self.note)")
        print("accounts: \(self.accounts.map{$0.name})")
        
    }
    
}











