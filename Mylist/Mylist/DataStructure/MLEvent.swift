//
//  MLEvent.swift
//  Mylist
//
//  Created by Kobe on 2018/12/7.
//  Copyright © 2018 Kobe. All rights reserved.
//

import UIKit

struct MLEvent {
    
    //the event unique identifier
    var e_id: Int16
    //the name or title of given event
    var e_body: String?
    
    var e_title: String?
    
    var e_subtitle: String?
    
    //the type of event
    var e_type: MLEventType?
    
    //the qos of the event
    var e_qos:  MLEventQos?
    
    //the trigger date of the event
    var e_triggerDate: TimeInterval?
    
    //the event repeat type.
    var e_repeatType: MLEventRepeatScheme?
    
    //indicator whether the event need alarm or not
    var e_isAlarm: Bool = false
    
    //the alarm fire date fo the event
    var e_alarmDate: TimeInterval?

    //the alarm repeat type
    var e_alarmRepeatType: MLEventRepeatScheme?
    
    //event description
    var e_note: String?
    
    //the local path of the event icon
    var e_icAdr: String?
    
    init(id: Int16? = nil,
         body: String? = nil,
         title: String? = nil,
         subtitle: String? = nil,
         type: MLEventType? = nil,
         qos: MLEventQos? = nil,
         rpt: MLEventRepeatScheme? = nil,
         trigger: TimeInterval? = nil,
         alarm: TimeInterval? = nil,
         note: String? = nil,
         icAdr: String? = nil) {
        
        var eid = id
        if eid == nil { eid = MLEvent.generateEventId() }
        self.e_id = eid!
        
        self.e_body = body
        self.e_title = title
        self.e_subtitle = subtitle
        self.e_type = type
        self.e_qos = qos
        self.e_repeatType = rpt
        self.e_triggerDate = trigger
        self.e_alarmDate = alarm
        self.e_note = note
        self.e_icAdr = icAdr
    }
    
    static func generateEventId() -> Int16 {
        
        let key = "eventIdSerial"
        guard let id = UserDefaults.standard.value(forKey: key) as? Int16 else {
            
            UserDefaults.standard.set(1, forKey: key); return 1
        }
        return id + 1
    }
}
