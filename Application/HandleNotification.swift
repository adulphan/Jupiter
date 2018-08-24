//
//  HandleNotification.swift
//  Jupiter
//
//  Created by adulphan youngmod on 22/8/18.
//  Copyright © 2018 goldbac. All rights reserved.
//

import Foundation


class HandleNotification: OperationCloudKit {
    
    static let shared = HandleNotification()
    @objc func coreDataDidSave(_ notification: Notification) {
        print("contextDidSave")
        
        if !CloudKit.isDownloadingFromCloudKit {
            
            
            print(CloudKit.outgoingSaveRecords.map{$0.recordID.recordName})
            
            
            let recordExchange = RecordExchange()
            recordExchange.start()
        }
        
        CloudKit.outgoingDeleteRecordIDs = []
        CloudKit.outgoingSaveRecords = []
        
//        guard !CloudKit.isDownloadingFromCloudKit else { return }
//        let download = downloadOperation
//        let upload = uploadOperation
//
//        CloudKit.pendingOperations.append(download)
//        CloudKit.pendingOperations.append(upload)
//        upload.addDependency(download)
//
//        if CloudKit.pendingOperations.count > 2  {
//            let index = CloudKit.pendingOperations.index(of: download)
//            let previousOperation = CloudKit.pendingOperations[index!-1]
//            download.addDependency(previousOperation)
//        }
//
//        CloudKit.privateDatabase.add(download)
//        CloudKit.privateDatabase.add(upload)
        
        
//        if !CloudKit.isDownloadingFromCloudKit {
//            exchangeDataWithCloudKit {
//                print("finish data exchange")
//                //self.printOutCoreData()
//            }
//        }
    }
}
