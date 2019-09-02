//
//  ViewExtension.swift
//  Mylist
//
//  Created by Kobe on 2019/8/21.
//  Copyright © 2019 Kobe. All rights reserved.
//

import UIKit

extension UIView {
    
// MARK: Position extension
    var x: CGFloat {    get { return self.frame.origin.x }
                        set(v) { self.frame.origin.x = v }
    }
    var y: CGFloat {    get { return self.frame.origin.y }
                        set(v) { self.frame.origin.y = v }
        
    }
    var height: CGFloat {   get { return self.frame.size.height }
                            set(v) { self.frame.size.height = v }
    }
    var width: CGFloat {    get { return self.frame.size.width }
                            set(v) { self.frame.size.width = v }
    }
    var top: CGFloat {  get { return self.y }
                        set(v) { self.y = v}
    }
    var left: CGFloat { get { return self.x }
                        set(v) { self.x = v }
    }
    var bottom: CGFloat { get { return self.y + self.height } }
    var right: CGFloat { get { return self.x + self.width } }
    
    func setCornerRadius(v: CGFloat) {
        
        self.layer.cornerRadius = v
        self.clipsToBounds = true
    }
    func setBoard(width:CGFloat,color: UIColor) {
        
        self.layer.borderWidth = width
        self.layer.borderColor = color.cgColor
    }
    
}

extension CGRect {
    
    init(_ x: CGFloat, _ y: CGFloat, _ width: CGFloat, _ height: CGFloat) {
        
        self.init(x: x, y: y, width: width, height: height)
    }
}

extension CALayer {
    
    
}
