//
//  WriteLocalData.swift
//  Jupiter
//
//  Created by adulphan youngmod on 15/9/18.
//  Copyright © 2018 goldbac. All rights reserved.
//

import Foundation
import CoreData
import CloudKit

class WriteLocalDataOperation: Operation {
    
    override func main() {
        name = "writeOperation"
        super.main()
        writeContext.saveData()
    }
    
}

extension OperationCloudKit {

    func writeLocalData() {
        
        let operationQueue = CloudKit.operationQueue
        let writeOperation = WriteLocalDataOperation()
        let uploadOperation = UploadOperation()
        
        uploadOperation.queuePriority = .normal
        writeOperation.queuePriority = .veryHigh
        
        if operationQueue.operationCount != 0 {
            
            operationQueue.addOperations([writeOperation, uploadOperation], waitUntilFinished: false)
            
//            if executing.name == "uploadOperation" {
//                operationQueue.cancelAllOperations()
//                operationQueue.addOperations([writeOperation, uploadOperation], waitUntilFinished: false)
//            } else {
//                operationQueue.addOperations([writeOperation], waitUntilFinished: false)
//
//            }
        } else {
            operationQueue.addOperations([writeOperation, uploadOperation], waitUntilFinished: false)
        }

        

    }

}





















