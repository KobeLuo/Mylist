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
        
        return topvc(controller: UIApplication.shared.keyWindow?.rootViewController)
    }
    
    class func topvc(controller: UIViewController?) -> UIViewController? {
        
        var c = controller
        if let navigationController = c as? UINavigationController {
            return topvc(controller: navigationController.visibleViewController)
        }
        if let tabController = c as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topvc(controller: selected)
            }
        }
        if let presented = c?.presentedViewController {
            return topvc(controller: presented)
        }
        return c
    }
}
