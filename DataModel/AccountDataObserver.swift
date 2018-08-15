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

extension AccountData: ViewModel {

    func sdfg() {
        

    }
}

protocol ViewModel {
    
    var name: String? { get set }
    var imageData: Data? { get set }
    var modifiedLocal: Date? { get set }
    var note: String? { get set }
    var beginBalance: Int64 { get set }
    var endBalance: Int64 { get set }
    var type: Int16 { get set }
    var favourite: Bool { get set }
    var companyData: CompanyData? { get set }
    var testAttribute: NSObject? { get set }
    
}

import UIKit

extension ViewModel {
    
    var testArray: [Int64] {
        get {
            return testAttribute as! [Int64]
        }
        set {
            testAttribute = newValue as NSObject
        }
    }
    
    var image: UIImage {
        get {
            guard let data = imageData else { return UIImage() }
            guard let image = UIImage(data: data) else { return UIImage() }            
            return image
        }
    }
    
}








