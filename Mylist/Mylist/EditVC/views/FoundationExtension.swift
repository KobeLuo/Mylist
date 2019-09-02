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
}
