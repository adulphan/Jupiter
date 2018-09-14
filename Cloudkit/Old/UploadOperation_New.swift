//
//  UploadOperation_New.swift
//  Jupiter
//
//  Created by adulphan youngmod on 13/9/18.
//  Copyright © 2018 goldbac. All rights reserved.
//

import Foundation
import CloudKit

class UploadDataOperation: CKModifyRecordsOperation {
    
    override func main() {

        super.main()
    }
    
    
    
}

extension OperationCloudKit {
    
    func uploadData() {
        let operation = UploadDataOperation()

        operation.modifyRecordsCompletionBlock = { (savedRecords, deletedIDs, error) in
            if let error = error {
                print(error)
            }
            
            for id in deletedIDs! {
                print("\(id.recordName) is deleted from Cloud")
            }
            for record in savedRecords! {
                print("\(record.recordID.recordName) is saved on Cloud")
            }
            
            
            
        }

    }
    
    
}















