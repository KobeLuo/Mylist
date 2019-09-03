//
//  ViewControllerExtension.swift
//  Mylist
//
//  Created by Kobe on 2019/9/3.
//  Copyright © 2019 Kobe. All rights reserved.
//

import Foundation
import UIKit

extension UIApplication {
    
    class func topvc() -> UIViewController? {
        
        return topvc(c: UIApplication.shared.keyWindow?.rootViewController)
    }
    
    class func topvc(controller: UIViewController?) -> UIViewController? {
        
        var c = controller
        if let navigationController = c as? UINavigationController {
            return topvc(c: navigationController.visibleViewController)
        }
        if let tabController = c as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topvc(c: selected)
            }
        }
        if let presented = c?.presentedViewController {
            return topvc(c: presented)
        }
        return c
    }
}
