//
//  CompanyFunctions.swift
//  Jupiter
//
//  Created by adulphan youngmod on 12/8/18.
//  Copyright © 2018 goldbac. All rights reserved.
//
//
//import Foundation
//
//extension Company {
//    
//       
//    func addNewToCoreData() -> CompanyData {
//        
//        let company = CompanyData(context: CoreData.context)        
//        company.recordID = UUID().uuidString
//        company.name = self.name
//        company.modifiedLocal = self.modifiedLocal
//        company.imageData = self.imageData
//        company.note = self.note
//        
//        return company
//    }
//    
//    
//    
//    func getAllAccounts() -> [Account] {
//        if let data = self.coreData, let accountData = data.accountData?.array {
//            var array:[Account] = []
//            for data in accountData as! [AccountData] {
//                let account = Account(coreData: data)
//                array.append(account)
//            }
//            return array
//        } else {
//            return []
//        }
//    }
//    
//    func printOut() {
//        
//        print("name: \(self.name)")
//        print("image: \(self.image)")
//        print("modifiedLocal: \(self.modifiedLocal)")
//        print("note: \(self.note)")
//        print("accounts: \(self.accounts.map{$0.name})")
//        
//        
//    }
//    
//    
//    
//    
//}
