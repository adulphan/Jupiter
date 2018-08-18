//
//  Date.swift
//  Jupiter
//
//  Created by adulphan youngmod on 15/8/18.
//  Copyright © 2018 goldbac. All rights reserved.
//

import Foundation

extension Date {
    
    var standardized: Date {
        get{
            let calendar = Calendar.standard
            let components = Calendar.current.dateComponents([.day, .month, .year], from: self)
            let date = calendar.date(from: components)!
            return date
        }
    }
    
    
    func readableDisplay() -> String {
        
        let standardFormatter = DateFormatter()
        let dateDisplay: String
        
        let today = Date()
        let yeasterday = Calendar.current.date(byAdding: .day, value: -1, to: today)
        let thisYear = Calendar.current.dateComponents([.year], from: self).year!

        if self == today {
            dateDisplay =  "Today"
            
        } else if self == yeasterday {
            dateDisplay = "Yesterday"
            
        } else if self > Calendar.current.date(byAdding: .day, value: -7, to: today)! {
            standardFormatter.dateFormat = "EEE, MMM d"
            dateDisplay = standardFormatter.string(from: self)
            
        } else if Calendar.current.dateComponents([.year], from: Date()).year == thisYear {
            standardFormatter.dateFormat = "MMM d"
            dateDisplay = standardFormatter.string(from: self)
            
        } else {
            standardFormatter.dateFormat = "MMM d, YYYY"
            dateDisplay = standardFormatter.string(from: self)
            
        }
        
        return dateDisplay
        
    }
    
    
}














