//
//  AppDelegate.swift
//  Mylist
//
//  Created by Kobe on 2018/12/5.
//  Copyright © 2018 Kobe. All rights reserved.
//

import UIKit
import RxSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        MLLocalNotification.registerNotification()
        
        let event = MLEvent.init(id: 123, title: "demo test", type: .et_pdt, trigger: Date(), alarm: Date())
//        MLLocalNotification.removeAllDeliverNotification()
        MLLocalNotification.getAllDeliveredNotification()
//        MLLocalNotification.createNotification(event)
//        test()
        
        return true
    }

    func test() {
        
        let a = 1.24e2
        print("\(a)")
        
        let b = 0xEp3
        print("\(b)")
        
        let h1 = 0xAp0
        let h2 = 0xA.1p0
        let h3 = 0xA.2p0
        let h4 = 0xA.3p0
        let h5 = 0xA.4p0
        print("\(h1),\(h2),\(h3),\(h4),\(h5)")
        
        // 0xA.BpC = (A+B/16) * power(2,C)
        let h6 = 0xAp1
        let h7 = 0xA.1p1
        let h8 = 0xA.2p1
        let h9 = 0xA.3p1
        let h10 = 0xA.4p1
        print("\(h6),\(h7),\(h8),\(h9),\(h10)")
        
        
        let h11 = 0xAp2
        let h12 = 0xA.1p-1
        let h13 = 0xA.2p-1
        let h14 = 0xA.3p-1
        let h15 = 0xA.4p-1
        print("\(h11),\(h12),\(h13),\(h14),\(h15)")
        
        let h16 = 0xA.0p1
        print("\(h16)")
        
//        let tooBig: Int8 = Int8.max + 1
//        print("\(tooBig)")
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    
}

