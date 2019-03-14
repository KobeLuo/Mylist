//
//  MLNotificationHelper.swift
//  Mylist
//
//  Created by Kobe on 2019/2/20.
//  Copyright © 2019 Kobe. All rights reserved.
//

import Foundation
import UIKit
import UserNotifications

class MLLocalNotification: NSObject {
    
    class func registerNotification() {

        let opts:UNAuthorizationOptions = [.alert,.sound,.badge]
        UNUserNotificationCenter.current().requestAuthorization(options: opts) { (allow, error) in
         
            if allow {
                print("register success")
            }else {
                
                print("register error:\(error)")
            }
        }
    }
    
    
    class func createNotification(event: MLEvent) {
        
        
    }
}
