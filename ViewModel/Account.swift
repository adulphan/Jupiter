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
    
    private let defaultImage: UIImage
    private let defaultModified: Date
    
    var coreData: AccountData? {
        didSet{ self.company = self.coreData?.companyData != nil ? Company(coreData: (self.coreData?.companyData)!) : nil }
    }
    var name: String
    var image: UIImage { get { return getImage() } }
    
    var imageData: Data?
    var modifiedLocal: Date
    var note: String

    var beginBalance: Int64
    var endBalance: Int64
    var type: Int16
    var favourite: Bool
    var company: Company?
    
    required init(coreData: AccountData) {
        
        self.defaultImage = UIImage()
        self.defaultModified = Date()

        self.coreData = coreData
        self.name = coreData.name ?? "New Account"
        self.imageData = coreData.imageData

        if let date = coreData.modifiedLocal {
            self.modifiedLocal = date
        } else {
            self.modifiedLocal = defaultModified
        }
        
        self.note = coreData.note ?? ""
        self.beginBalance = coreData.beginBalance
        self.endBalance = coreData.endBalance
        self.type = coreData.type
        self.favourite = coreData.favourite
        
        if let data = coreData.companyData {
            self.company = Company(coreData: data)
        }
    }
    
    required init() {
        
        defaultImage = UIImage()
        defaultModified = Date()
        
        coreData = nil
        name = "New Account"
        modifiedLocal = defaultModified
        note = ""
        beginBalance = 0
        endBalance = 0
        type = 0
        favourite = false
        company = nil
    }
    
    private func getImage() -> UIImage {
        if let data = self.imageData, let image = UIImage(data: data) {
            return image
        } else {
            return defaultImage
        }
    }

}





