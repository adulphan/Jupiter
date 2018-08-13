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
    
    var name: String { get set }
    var image: UIImage { get }
    var imageData: Data? { get set }
    var modified: Date { get set }
    var note: String { get set }
    init()
}

protocol CompanyViewModel: BaseViewModel {
    
    var coreData: CompanyData? { get set }
    var accounts: [Account]  { get set }
    init(coreData: CompanyData)
    
}

protocol AccountViewModel: BaseViewModel {
    
    var coreData: AccountData? { get set }    
    var beginBalance: Int64 { get set }
    var endBalance: Int64 { get set }
    var type: Int16 { get set }
    var favourite: Bool { get set }    
    var company: Company? { get set }
    init(coreData: AccountData)

    
}

protocol TransactionViewModel: BaseViewModel {
    
    var title: String? { get set }
    
}









