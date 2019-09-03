//
//  MLALert.swift
//  Mylist
//
//  Created by Kobe on 2019/9/3.
//  Copyright © 2019 Kobe. All rights reserved.
//

import Foundation
import UIKit

typealias MLAlertActionInvoke = (UIAlertAction) -> Void

class MLAlert: NSObject {
    
    class func alert(title: String,
                     message: String,
                     invoke:MLAlertActionInvoke?) {
        
        let c = UIAlertController(title: title, message: message, preferredStyle:.alert)
        if invoke != nil {
            
            c.addAction(UIAlertAction(title: title, style: .default, handler: { (act) in
                
                invoke!(act)
            }))
        }
        
        if var topvc = UIApplication.shared.keyWindow?.rootViewController {
            while let presentedViewController = topvc.presentedViewController {
                
                topvc = presentedViewController
            }
            
            topvc.present(c, animated: true) {}
        }
    }
}
