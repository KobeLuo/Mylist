//
//  FoundationExtension.swift
//  Mylist
//
//  Created by Kobe on 2019/8/26.
//  Copyright © 2019 Kobe. All rights reserved.
//

import Foundation

extension TimeInterval {
    
    func formatDesc() -> String {
        
        return ""
    }
}

extension Date {
    
    func formatDesc() -> String {
        
        let fmt = DateFormatter()
        fmt.dateFormat = "yyyy年MM月dd日 HH:mm"
        
        return fmt.string(from: self)
    }
    
    func dbDesc() -> String {
        
        let fmt = DateFormatter()
        fmt.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        
        return fmt.string(from: self)
    }
    
    func isExpired() -> Bool {
        
        let current = Date()
        if self.timeIntervalSinceReferenceDate < current.timeIntervalSinceReferenceDate {
            
            return true
        }
        return false
    }
}

extension String {
    
    func dateFromDBDesc() -> Date? {
        
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        format.locale = Locale(identifier: "en_US_POSIX")
        let date = format.date(from: self)
        return date
    }
}

