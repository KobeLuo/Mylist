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
    
    static func ==(lp: MLEventType, rp: MLEventType) -> Bool {
        
        return lp.description() == rp.description()
    }
    
    func description()-> String {
        
        switch self {
        case .et_btd: return "生日"
        case .et_cdt:   return "信用"
        default: return "其它"
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
}

enum MLEventRepeatScheme {
    
    case er_nr //never
    case er_ed //every day
    case er_ew //every week
    case er_em //every month
    case er_ey //every year
    
    func description() -> String {
        
        switch self {
        case .er_ed: return "每天"
        case .er_ew: return "每周"
        case .er_em: return "每月"
        case .er_ey: return "每年"
        default:     return "从不"
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
    var e_name: String
    //the type of event
    var e_type: MLEventType
    //the qos of the event
    var e_qos:  MLEventQos
    //the trigger date of the event
    var e_triggerDate: TimeInterval
    //the alarm fire date fo the event
    var e_alarmDate: TimeInterval
    //event description
    var e_note: String
    //the local path of the event icon
    var e_icAdr: String
    
}
