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
    
    class func removeAllDeliverNotification() {
        
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
    }
    
    class func getAllDeliveredNotification() {
        
        let center = UNUserNotificationCenter.current()
        center.getDeliveredNotifications { (results) in
            
            let _ = results.enumerated().map({ (arg) in
                
                let (_, notify) = arg
                center.removeDeliveredNotifications(withIdentifiers: [notify.request.identifier])
            })
        }
        
        center.removeAllDeliveredNotifications()
        center.removeAllPendingNotificationRequests()
    }
    
    class func createNotification(_ event: MLEvent) {
        
        let content = UNMutableNotificationContent()
        content.title = event.e_title ?? "Unknow title"
        content.subtitle = event.e_subtitle ?? ""
        content.body = event.e_body ?? ""
        let sound = event.e_type?.sound()
        content.sound = sound
        content.badge = 0
        
        let date = Date(timeIntervalSinceNow: 15)
        let calendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.chinese)!
//        let triggerDate = Calendar.current.dateComponents([.year,.month,.day,.hour,.minute,.second], from: date)
        
//        let weekday = calendar.component(.weekday, from: date)
        let triggerDate = calendar.components([.weekday], from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: true)
//        var date = DateComponents()
//        date.second = 30
//        let trigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: false)
        
        print("trigger.nextTriggerDate():\(String(describing: trigger.nextTriggerDate()))")
//        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)
        
        let identifier = "Local notification"
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { (error) in
            
            if let error = error {
                
                print("Error \(error.localizedDescription)")
            }else {
                
                print("no error")
            }
        }
    }
    
    class func calenderComponents(component: Calendar.Component) -> Set<Calendar.Component> {
        
        var components: Set<Calendar.Component>
        switch component {
        case .year:     components = [.month,.day,.hour,.minute,.second]
        case .month:    components = [.day,.hour,.minute,.second]
        case .day:      components = [.hour,.minute,.second]
        case .weekday:  components = [.weekday]
        case .hour:     components = [.minute,.second]
        case .minute:   components = [.second]
        default:        components = [.year,.month,.day,.hour,.minute,.second]
        }
        return components
    }
}
