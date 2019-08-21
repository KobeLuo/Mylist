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

//https://www.jianshu.com/p/b4e264a7d655

class MLLocalNotification: NSObject {
    
    class func registerNotification() {

        let opts:UNAuthorizationOptions = [.alert,.sound,.badge]
        UNUserNotificationCenter.current().requestAuthorization(options: opts) { (allow, error) in
         
            if allow {
                print("register success")
            }else {
                
                print("register error:\(error!)")
            }
        }
    }
    
    class func createNotification(_ event: MLEvent) {
        
        let content = UNMutableNotificationContent()
        content.title = event.e_title
        content.subtitle = event.e_subtitle
        content.body = event.e_body
        content.sound = UNNotificationSound.default()
        content.badge = 1
//        content.attachments
        let date = Date(timeIntervalSinceNow: 3)
//        let triggerDate = Calendar.current.dateComponents([.year,.month,.day,.hour,.minute,.second], from: date)
//        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)
        
        let identifier = "Local notification"
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { (error) in
            
            if let error = error {
                
                print("Error \(error.localizedDescription)")
            }
        }
    }
}
