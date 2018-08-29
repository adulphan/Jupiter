//
//  HandleCloudkitError.swift
//  Jupiter
//
//  Created by adulphan youngmod on 25/8/18.
//  Copyright © 2018 goldbac. All rights reserved.
//

import Foundation
import CloudKit

//extension RecordExchange {
//    
//    func handle(error: Error) {
//        
//        if let ckerror = error as? CKError {
//            if ckerror.code == CKError.requestRateLimited {
//                let retryInterval = ckerror.userInfo[CKErrorRetryAfterKey] as? TimeInterval
//                DispatchQueue.main.async {
//                    Timer.scheduledTimer(timeInterval: retryInterval!, target: self, selector: #selector(self.files_saveNotes), userInfo: nil, repeats: false)
//                }
//            } else if ckerror.code == CKError.zoneBusy {
//                let retryInterval = ckerror.userInfo[CKErrorRetryAfterKey] as? TimeInterval
//                DispatchQueue.main.async {
//                    Timer.scheduledTimer(timeInterval: retryInterval!, target: self, selector: #selector(self.files_saveNotes), userInfo: nil, repeats: false)
//                }
//            } else if ckerror.code == CKError.limitExceeded {
//                let retryInterval = ckerror.userInfo[CKErrorRetryAfterKey] as? TimeInterval
//                DispatchQueue.main.async {
//                    Timer.scheduledTimer(timeInterval: retryInterval!, target: self, selector: #selector(self.files_saveNotes), userInfo: nil, repeats: false)
//                }
//            } else if ckerror.code == CKError.notAuthenticated {
//                NotificationCenter.default.post(name: Notification.Name("noCloud"), object: nil, userInfo: nil)
//            } else if ckerror.code == CKError.networkFailure {
//                NotificationCenter.default.post(name: Notification.Name("networkFailure"), object: nil, userInfo: nil)
//            } else if ckerror.code == CKError.networkUnavailable {
//                NotificationCenter.default.post(name: Notification.Name("noWiFi"), object: nil, userInfo: nil)
//            } else if ckerror.code == CKError.quotaExceeded {
//                NotificationCenter.default.post(name: Notification.Name("quotaExceeded"), object: nil, userInfo: nil)
//            } else if ckerror.code == CKError.partialFailure {
//                NotificationCenter.default.post(name: Notification.Name("partialFailure"), object: nil, userInfo: nil)
//            } else if (ckerror.code == CKError.internalError || ckerror.code == CKError.serviceUnavailable) {
//                NotificationCenter.default.post(name: Notification.Name("serviceUnavailable"), object: nil, userInfo: nil)
//            }
//        }
//        
//    }
    
    
//}
