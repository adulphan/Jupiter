//
//  CompanyDataObserver.swift
//  Jupiter
//
//  Created by adulphan youngmod on 12/8/18.
//  Copyright © 2018 goldbac. All rights reserved.
//

import Foundation

extension Company {
    
    public override func willSave() {
        super.willSave()
        proceedToCloudKit()
    }

}
