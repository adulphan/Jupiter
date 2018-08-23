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
            exchangeDataWithCloudKit {
                print("finish data exchange")
                //self.printOutCoreData()
            }
        }
    }
}
