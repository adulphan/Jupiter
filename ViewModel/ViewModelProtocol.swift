//
//  ViewModelProtocol.swift
//  Jupiter
//
//  Created by adulphan youngmod on 11/8/18.
//  Copyright © 2018 goldbac. All rights reserved.
//

import Foundation
import UIKit
import CoreData

protocol BaseViewModel {
    
    var name: String? { get set }
    var image: UIImage? { get set }
    var modified: Date? { get set }
    var note: String? { get set }

}

protocol CompanyViewModel: BaseViewModel {
    
    var coreData: CompanyData? { get set }
    var accounts: [Account]?  { get set }
    init?(coreData: CompanyData)
    
}

protocol AccountViewModel: BaseViewModel {
    
    var coreData: AccountData? { get set }    
    var beginBalance: Double? { get set }
    var endBalance: Double? { get set }
    var type: Int16? { get set }
    var favourite: Bool? { get set }    
    var company: Company? { get set }
    init?(coreData: AccountData)
    
}

protocol TransactionViewModel: BaseViewModel {
    
    var title: String? { get set }
    
}








