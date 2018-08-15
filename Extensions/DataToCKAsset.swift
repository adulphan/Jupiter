//
//  DataToCKAsset.swift
//  Jupiter
//
//  Created by adulphan youngmod on 15/8/18.
//  Copyright © 2018 goldbac. All rights reserved.
//

import Foundation
import CloudKit

extension Data {

    func createCKAsset() -> CKAsset {

        let tempName = UUID().uuidString + ".heic"
        let url = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(tempName)
        print("TempFile:  \(tempName)")
        do { try self.write(to: url) } catch { print("Error writing temp file: \(error)") }
        let asset = CKAsset(fileURL: url)
        return asset
    }

}

extension FileManager {
    func clearTempFileForCKAsset() {
        do {
            let tmpDirectory = try contentsOfDirectory(atPath: NSTemporaryDirectory())
            try tmpDirectory.forEach {[unowned self] file in
                if file.hasSuffix(".heic") {
                    let path = String.init(format: "%@%@", NSTemporaryDirectory(), file)
                    print("Clearing:  \(file)")
                    try self.removeItem(atPath: path)
                }
            }
        } catch {
            print(error)
        }
    }
}
