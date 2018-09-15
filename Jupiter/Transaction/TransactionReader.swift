//
//  TransactionReader.swift
//  Jupiter
//
//  Created by adulphan youngmod on 17/8/18.
//  Copyright © 2018 goldbac. All rights reserved.
//

import Foundation

extension Transaction: TransactionReader {

}

protocol TransactionReader: SystemField {
    
    var name: String? { get }
    var modifiedLocal: Date? { get }
    var recordName: String? { get }
    
    var date: Date? { get }
    var accounts: [Account] { get }
    var flows: [Int64]? { get }
    var note: String? { get }
    var url: String? { get }
    
    var photoID: UUID? { get }
    var thumbID: UUID? { get }
}




