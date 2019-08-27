//
//  MLEvent.swift
//  Mylist
//
//  Created by Kobe on 2018/12/7.
//  Copyright © 2018 Kobe. All rights reserved.
//

import UIKit

enum MLEventType: Equatable {
    
    case et_btd //birthday
    case et_cdt //credit
    case et_nml //normal
    case et_ctd //count down
    
    static func ==(lp: MLEventType, rp: MLEventType) -> Bool {
        
        return lp.desc == rp.desc
    }
    
    var desc: String {
        
        switch self {
        case .et_btd:   return "事件类型: 生　日"
        case .et_cdt:   return "事件类型: 信　用"
        case .et_ctd:   return "事件类型: 倒计时"
        case .et_nml:   return "事件类型: 常　规"
        }
    }
}

enum MLEventQos: RawRepresentable, Equatable {
    
    case eq_egy //emergency
    case eq_ipt //important
    case eq_cmn //common
    case eq_lwl //lower level
    
    typealias RawValue = Int8
    
    init?(rawValue: RawValue) {
        
        switch rawValue {
        case 1 << 0:    self = MLEventQos.eq_lwl
        case 1 << 2:    self = MLEventQos.eq_ipt
        case 1 << 3:    self = MLEventQos.eq_egy
        default:        self = MLEventQos.eq_cmn
        }
    }
    
    var rawValue: RawValue {
        
        switch self {
        case .eq_egy: return 1 << 3
        case .eq_ipt: return 1 << 2
        case .eq_cmn: return 1 << 1
        case .eq_lwl: return 1 << 0
        }
    }
    
    var desc: String {
        
        switch self {
        case .eq_egy: return "事件权重: 紧急"
        case .eq_ipt: return "事件权重: 重要"
        case .eq_lwl: return "事件权重: 低权"
        case .eq_cmn: return "事件权重: 常规"
        }
    }
}

enum MLEventRepeatScheme {
    
    case er_nr //never
    case er_ed //every day
    case er_ew //every week
    case er_em //every month
    case er_ey //every year
    
    var desc: String {
        
        switch self {
        case .er_ed: return "每天 重复"
        case .er_ew: return "每周 重复"
        case .er_em: return "每月 重复"
        case .er_ey: return "每年 重复"
        case .er_nr: return "从不 重复"
        }
    }
}

enum MLEventAlarmScheme {
    
    case ea_nr //never alarm
    case ea_tb1h //before event trigg one hours
    case ea_tbhd //before event trigg half day
    case ea_tbnd(days: Int) //before event trigg n days
    case ea_tbnw(weeks: Int) //before event trigg n week
    case ea_tbnm(months: Int) //before event trigg n month
}

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
