//
//  ViewModelProtocol.swift
//  Jupiter
//
//  Created by adulphan youngmod on 11/8/18.
//  Copyright © 2018 goldbac. All rights reserved.
//

import Foundation
import CloudKit

protocol BaseDataModel {
    
    var name: String? { get set }
    var imageFileName: String? { get set }
    var modified: Date? { get set }
    var reference: String? { get set }
    var referenceRecord: CKRecord? { get set }
    
}

protocol AccountDataModel: BaseDataModel {
    
    var beginBalance: Double? { get set }
    var endBalance: Double? { get set }
    var type: Int16? { get set }
    var favourite: Bool? { get set }
    
    var companyRecordID: String? { get set }
    
}

protocol TransactionDataModel: BaseDataModel {
    
    var title: String? { get set }
    
}









