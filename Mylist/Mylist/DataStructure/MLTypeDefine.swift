//
//  MLTypeDefine.swift
//  Mylist
//
//  Created by ANine on 2019/8/27.
//  Copyright © 2019 Kobe. All rights reserved.
//

import Foundation


protocol MLTypeProtocol {
    
    func typeDesc() -> String
}

enum MLEventType: RawRepresentable, Equatable, MLTypeProtocol {

    case et_btd //birthday
    case et_cdt //credit
    case et_pdt //pay debt
    case et_nml //normal
    case et_ctd //count down
    case et_amb //alarm bell
    
    typealias RawValue = Int32
    
    var rawValue: RawValue {
        
        switch self {
        case .et_btd:   return 1
        case .et_cdt:   return 2
        case .et_pdt:   return 3
        case .et_ctd:   return 4
        case .et_nml:   return 5
        case .et_amb:   return 6
        }
    }
    
    init?(rawValue: RawValue) {
        switch rawValue {
        case 1:     self = MLEventType.et_btd
        case 2:     self = MLEventType.et_cdt
        case 3:     self = MLEventType.et_pdt
        case 4:     self = MLEventType.et_ctd
        case 5:     self = MLEventType.et_nml
        case 6:     self = MLEventType.et_amb
        default:    self = MLEventType.et_nml
            
        }
    }
    
    static func ==(lp: MLEventType, rp: MLEventType) -> Bool {
        
        return lp.desc == rp.desc
    }
    
    var desc: String {
        
        switch self {
        case .et_btd:   return "事件类型: 生　日"
        case .et_cdt:   return "事件类型: 信　用"
        case .et_pdt:   return "事件类型: 还　债"
        case .et_ctd:   return "事件类型: 倒计时"
        case .et_nml:   return "事件类型: 常　规"
        case .et_amb:   return "事件类型: 闹　铃"
        }
    }
    
    func typeDesc() -> String { return desc }
}

enum MLEventQos: RawRepresentable, MLTypeProtocol {
    
    case eq_egy //emergency
    case eq_ipt //important
    case eq_cmn //common
    case eq_lwl //lower level
    
    typealias RawValue = Int32
    
    init?(rawValue: RawValue) {
        
        switch rawValue {
        case 0: self = MLEventQos.eq_lwl
        case 2: self = MLEventQos.eq_ipt
        case 3: self = MLEventQos.eq_egy
        case 1: self = MLEventQos.eq_cmn
        default:self = MLEventQos.eq_cmn
        }
    }
    
    var rawValue: RawValue {
        
        switch self {
        case .eq_egy: return 3
        case .eq_ipt: return 2
        case .eq_cmn: return 1
        case .eq_lwl: return 0
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
    
    func typeDesc() -> String { return desc }
}

enum MLEventRepeatScheme: RawRepresentable, MLTypeProtocol {
    
    case er_nr //never
    case er_eh //every hour
    case er_ed //every day
    case er_ew //every week
    case er_em //every month
    case er_ey //every year
    
    typealias RawValue = Int32
    init?(rawValue: RawValue) {
        switch rawValue {
        case 1:     self = MLEventRepeatScheme.er_nr
        case 2:     self = MLEventRepeatScheme.er_eh
        case 3:     self = MLEventRepeatScheme.er_ed
        case 4:     self = MLEventRepeatScheme.er_ew
        case 5:     self = MLEventRepeatScheme.er_em
        case 6:     self = MLEventRepeatScheme.er_ey
        default:    self = MLEventRepeatScheme.er_nr
        }
    }
    var rawValue: RawValue {
        
        switch self {
        case .er_nr:   return 1
        case .er_eh:   return 2
        case .er_ed:   return 3
        case .er_ew:   return 4
        case .er_em:   return 5
        case .er_ey:   return 6
        }
    }
    
    var desc: String {
        
        switch self {
        case .er_ed: return "每天 重复"
        case .er_eh: return "每时 重复"
        case .er_ew: return "每周 重复"
        case .er_em: return "每月 重复"
        case .er_ey: return "每年 重复"
        case .er_nr: return "从不 重复"
        }
    }
    
    func typeDesc() -> String { return desc }
}

enum MLEventStatus: RawRepresentable, MLTypeProtocol {
    
    case es_nml // event statsu normal
    case es_aph // event status approach the trigger date
    case es_cpl // event completed
    case es_epr // event did expire
    
    typealias RawValue = Int32
    init?(rawValue: RawValue) {
        
        switch rawValue {
        case 1:     self = .es_nml
        case 2:     self = .es_aph
        case 3:     self = .es_cpl
        case 4:     self = .es_epr
        default:    self = .es_nml
        }
    }
    
    var rawValue: RawValue {
        
        switch self {
        case .es_nml:   return 1
        case .es_aph:   return 2
        case .es_cpl:   return 3
        case .es_epr:   return 4
        }
    }
    
    var desc: String {
        
        switch self {
        case .es_nml:       return "状态: 常　规"
        case .es_aph:       return "状态: 临　近"
        case .es_cpl:       return "状态: 已完成"
        case .es_epr:       return "状态: 已过期"
        }
    }
    
    func typeDesc() -> String { return desc }
}

enum MLEventAlarmScheme: RawRepresentable, MLTypeProtocol {
    
    case ea_nr //never alarm
    case ea_tb1h //before event trigg one hours
    case ea_tbhd //before event trigg half day
    case ea_tbnd(days: Int32) //before event trigg n days
    case ea_tbnw(weeks: Int32) //before event trigg n week
    case ea_tbnm(months: Int32) //before event trigg n month
    
    static let od: Int32 = 10 //offset days
    static let ow: Int32 = 50 //offset weeks
    static let om: Int32 = 60 //offset months
    
    typealias RawValue = Int32
    init?(rawValue: RawValue) {
        
        switch rawValue {
        case 1:             self = .ea_tb1h
        case 2:             self = .ea_tbhd
        case 11...41:       self = .ea_tbnd(days: rawValue - MLEventAlarmScheme.od)
        case 51...57:       self = .ea_tbnw(weeks: rawValue - MLEventAlarmScheme.ow)
        case 61...72:       self = .ea_tbnm(months:rawValue - MLEventAlarmScheme.om)
        default:            self = .ea_nr
        }
    }
    
    var rawValue: RawValue {
        
        switch self {
        case .ea_nr:                    return 0
        case .ea_tb1h:                  return 1
        case .ea_tbhd:                  return 2
        case .ea_tbnd(days: let n):     return n + MLEventAlarmScheme.od
        case .ea_tbnw(weeks: let n):    return n + MLEventAlarmScheme.ow
        case .ea_tbnm(months: let n):   return n + MLEventAlarmScheme.om
        }
    }
    
    var desc: String {
            
            switch self {
            case .ea_nr:                    return "从不提醒"
            case .ea_tb1h:                  return "提前一小时提醒"
            case .ea_tbhd:                  return "提前半天提醒"
            case .ea_tbnd(days: let n):     return "提前\(n)天提醒"
            case .ea_tbnw(weeks: let n):    return "提前\(n)周提醒"
            case .ea_tbnm(months: let n):   return "提前\(n)个月提醒"
            }
    }
        
    func typeDesc() -> String { return desc }
}
