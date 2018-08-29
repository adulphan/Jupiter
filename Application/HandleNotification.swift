//
//  HandleNotification.swift
//  Jupiter
//
//  Created by adulphan youngmod on 22/8/18.
//  Copyright © 2018 goldbac. All rights reserved.
//

import Foundation
import CoreData

class HandleNotification: OperationCloudKit {
    
    static let shared = HandleNotification()
    @objc func coreDataDidSave(_ notification: Notification) {
        print("contextDidSave")

        
        
        
        
        
        
        
        
        
        
        
        //print(notification.userInfo)
        
//        guard !CloudKit.isDownloadingFromCloudKit && CloudKit.hasOutgoings else {return}
//        uploadRecords { (error) in
//            print("Call back")
//        }        
//        CloudKit.outgoingSaveRecords = []
//        CloudKit.outgoingDeleteRecordIDs = []

    }
}
