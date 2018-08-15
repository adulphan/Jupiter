//
//  Company.swift
//  Jupiter
//
//  Created by adulphan youngmod on 11/8/18.
//  Copyright © 2018 goldbac. All rights reserved.
//
//
//import Foundation
//import CloudKit
//import UIKit
//
//class Company: CompanyViewModel {
//    
//    private let defaultImage: UIImage
//    private let defaultModified: Date
//    
//    var coreData: CompanyData?
//
//    var name: String
//    var image: UIImage
//    var imageData: Data?
//    var modifiedLocal: Date
//    var note: String
//    var accounts: [Account] {
//        get { return getAllAccounts() }
//        set {}
//    }
//    
//    required init(coreData: CompanyData) {
//        
//        self.defaultImage = UIImage()
//        self.defaultModified = Date()
//        
//        self.coreData = coreData
//        self.name = coreData.name ?? "New Company"
//        self.image = defaultImage
//        self.imageData = coreData.imageData
//        
//        if let date = coreData.modifiedLocal {
//            self.modifiedLocal = date
//        } else {
//            self.modifiedLocal = defaultModified
//        }
//        
//        self.note = coreData.note ?? ""
//        self.accounts = []
//
//    }
//    
//    required init() {
//       
//        defaultImage = UIImage()
//        defaultModified = Date()
//        
//        coreData = nil
//        name = "New Company"
//        image = defaultImage
//        modifiedLocal = defaultModified
//        note = ""
//    }
//
//}
//
//









