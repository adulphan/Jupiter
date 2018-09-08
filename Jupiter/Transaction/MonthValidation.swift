//
//  MonthExtensions.swift
//  Jupiter
//
//  Created by adulphan youngmod on 17/8/18.
//  Copyright © 2018 goldbac. All rights reserved.
//

import Foundation

extension Month {

    public override func willSave() {
        super.willSave()
        validateDate()
    }

    private func validateDate() {
        if endDate != endDate?.standardized {
            endDate = endDate?.standardized
        }
    }
    

}
