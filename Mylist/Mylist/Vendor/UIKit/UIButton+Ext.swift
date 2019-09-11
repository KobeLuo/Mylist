//
//  UIButton+Ext.swift
//  Mylist
//
//  Created by Kobe on 2019/9/11.
//  Copyright © 2019 Kobe. All rights reserved.
//

import Foundation
//#if TARGET_OS_IPHONE
import UIKit

extension UIButton {
    
    func addAnimatorWhenTapped() {
        
        self.addTarget(self, action: #selector(touchDown), for: .touchDown)
    }
    
    @objc func touchDown() {
        
        var transform = self.transform
        transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseInOut, animations: {
            
            self.transform = transform
        }) { (v) in
            
            UIView.animate(withDuration: 0.1, animations: {
                
                self.transform = CGAffineTransform.identity
            })
        }
    }
}
//#elseif TARGET_OS_MAC
//#endif
