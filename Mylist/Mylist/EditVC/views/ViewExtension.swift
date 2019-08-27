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
    var x: CGFloat { get { return self.frame.origin.x } }
    var y: CGFloat { get { return self.frame.origin.y } }
    var height: CGFloat { get { return self.frame.size.height } }
    var width: CGFloat { get { return self.frame.size.width } }
    var top: CGFloat { get { return self.y } }
    var left: CGFloat { get { return self.x } }
    var bottom: CGFloat { get { return self.y + self.height } }
    var right: CGFloat { get { return self.x + self.width } }
    
    func setCornerRadius(v: CGFloat) {
        
        self.layer.cornerRadius = v
        self.clipsToBounds = true
    }
    
    
}

extension CGRect {
    
    init(_ x: CGFloat, _ y: CGFloat, _ width: CGFloat, _ height: CGFloat) {
        
        self.init(x: x, y: y, width: width, height: height)
    }
}

extension CALayer {
    
    
}
