//
//  AccountData.swift
//  Jupiter
//
//  Created by adulphan youngmod on 12/8/18.
//  Copyright © 2018 goldbac. All rights reserved.
//

import Foundation

extension AccountData {

    public override func didSave() {
        
        if isInserted {
            self.saveToCloudkit()
        }
    }

}




