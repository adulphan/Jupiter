//
//  PrepareForSimulation.swift
//  Jupiter
//
//  Created by adulphan youngmod on 18/8/18.
//  Copyright © 2018 goldbac. All rights reserved.
//

import Foundation
import UIKit

extension SimulateData: AccessFiles {
    
    func prepareForSimulation() {
        
        clearDocumentFolder()
        createDummyImage()

    }
    
    private func createDummyImage() {
        
        let image = UIImage(named: "photo")
        let ciImage = CIImage(image: image!)
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let recordID = UUID().uuidString
        let fileName =  recordID + ".heic"
        let context = CIContext(options: nil)
        let heifData = context.heifRepresentation(of: ciImage!, format: kCIFormatARGB8, colorSpace: colorSpace, options: [kCGImageDestinationLossyCompressionQuality: 0.4])!
  
        saveImageTo(data: heifData, fileName: fileName)
        SimulateData.dummyImageID = fileName

    }
    
}
