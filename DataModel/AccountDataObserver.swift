//
//  AccountData.swift
//  Jupiter
//
//  Created by adulphan youngmod on 12/8/18.
//  Copyright © 2018 goldbac. All rights reserved.
//

import Foundation

extension AccountData {

    public override func didSave() {
        
        if isInserted {
            self.saveToCloudkit()
        }
    }

}




//extension AccountData: ViewModel {
//
//    func testMethod() {
//        
//
//    }
//    
//}
//
//
//protocol ViewModel {
//    
//    var name: String? { get }
//    var imageData: Data? { get }
//    var modifiedLocal: Date? { get }
//    var note: String? { get }
//    var beginBalance: Int64 { get }
//    var endBalance: Int64 { get }
//    var type: Int16 { get }
//    var favourite: Bool { get }
//    var companyData: CompanyData? { get }
//    //var testAttribute: NSObject? { get }
//    
//    var image: UIImage { get }
//    var testArray: [Int64] { get }
//    
//}
//
//import UIKit
//
//extension AccountData {
//
//    var testArray: [Int64] {
//        get {
//            return testAttribute as! [Int64]
//        }
//        set {
//            testAttribute = newValue as NSObject
//        }
//    }
//    
//    var image: UIImage {
//        get {
//            guard let data = imageData else { return UIImage() }
//            guard let image = UIImage(data: data) else { return UIImage() }
//            return image
//        }
//    }
//    
//}








