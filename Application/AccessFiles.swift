//
//  FileManager.swift
//  Jupiter
//
//  Created by adulphan youngmod on 18/8/18.
//  Copyright © 2018 goldbac. All rights reserved.
//

import Foundation
import UIKit

protocol AccessFiles {}

extension AccessFiles {
    
    func getImageFrom(fileName: String) -> UIImage? {

        let documentPaths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let imagePath = NSString.path(withComponents: [documentPaths, fileName])
        
        if let image = UIImage(contentsOfFile: imagePath) {
            return image
        } else {
            print("getImageFromDocumentWith(name): No Image")
            return nil
        }
    }
    
    func saveImageTo(data: Data, fileName: String) {
        
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileURL = documentsURL.appendingPathComponent(fileName)
        let imageData = data
        
        do {
            try imageData.write(to: fileURL)
            print("Saved file: \(fileURL)")
        } catch {
            print("error saving file:", error)
        }
        
    }
    
    func getDataFrom(fileName: String) -> Data? {
        
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileURL = documentsURL.appendingPathComponent(fileName)
        
        do {
            let data = try Data(contentsOf: fileURL)
            return data
        } catch {
            print("error loading file:", error)
            return nil
        }
        
    }
    
    func getFolderURL() -> [URL] {
        
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        do {
            let fileURLs = try FileManager.default.contentsOfDirectory(at: documentsURL, includingPropertiesForKeys: nil)
            return fileURLs
        } catch {
            print("Error while enumerating files \(documentsURL.path): \(error.localizedDescription)")
            return []
        }
    }
    
    func clearDocumentFolder() {
        
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        do {
            let fileURLs = try FileManager.default.contentsOfDirectory(at: documentsURL, includingPropertiesForKeys:nil)
            for path in fileURLs {
                try FileManager.default.removeItem(at: path)
            }
        } catch {
            print("Could not clear temp folder: \(error)")
        }
    }
}
