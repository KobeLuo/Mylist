//
//  UIColor+Ext.swift
//  Mylist
//
//  Created by Kobe on 2019/9/11.
//  Copyright © 2019 Kobe. All rights reserved.
//

//#if TARGET_OS_IPHONE
import UIKit

extension UIColor {
    
    convenience init(_ r: Int, _ g: Int, _ b: Int) {
        
        self.init(r, g, b, 1.0)
    }
    
    convenience init(_ r: Int, _ g: Int, _ b: Int, _ a: CGFloat) {
        
        self.init(red: CGFloat(r)/255.0, green: CGFloat(g)/255.0, blue: CGFloat(b)/255.0, alpha: a)
    }
    
    convenience init(_ hex: Int) { self.init(hex, 1.0) }
    convenience init(_ hex: Int, _ a: CGFloat) {
        
        self.init((hex >> 0x10) & 0xFF, (hex >> 0x08) & 0xFF, hex & 0xFF, a)
    }
}


//#endif
