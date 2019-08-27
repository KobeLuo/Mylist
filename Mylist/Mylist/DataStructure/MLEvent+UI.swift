//
//  MLEvent+UI.swift
//  Mylist
//
//  Created by Kobe on 2019/8/27.
//  Copyright © 2019 Kobe. All rights reserved.
//

import Foundation

extension MLEvent {
    
    static let e_body_ph = "请输入内容"
    static let e_title_ph = "请输入标题"
    static let e_subtitle_ph = "请输入子标题"
    static let e_type_ph = "请选择事件类型"
    static let e_repeat_ph = "请选择事件是否需要重复"
    static let e_qos_ph = "请选择事件权重"
    static let e_triggerDate_ph = "请选择事件触发时间"
    static let e_alarmDate_ph = "请选择事件提醒时间"
    static let e_alarmRepeatTye_ph = "请选择重复提醒方案"
    static let e_note_ph = "更多细节，请填写于此"
    
    
    var e_title_desc: String {
        
        if e_title == nil { return MLEvent.e_title_ph }
        return e_title!
    }
    
    var e_subtitle_desc: String {
        
        if e_subtitle == nil { return MLEvent.e_subtitle_ph }
        return e_subtitle!
    }
    
    var e_repeat_desc: String {
        
        if e_repeatType == nil { return MLEvent.e_repeat_ph }
        return e_repeatType!.desc
    }
    
    var e_type_desc: String {
        
        if e_type == nil {
            
            return MLEvent.e_type_ph
        }
        return e_type!.desc
    }
    
    var e_qos_desc: String {
        
        if e_type == nil {
            
            return MLEvent.e_qos_ph
        }
        return e_qos!.desc
    }
    
    var e_triggerDate_desc: String {
        
        if e_alarmDate == nil {
            
            return MLEvent.e_triggerDate_ph
        }
        return e_alarmDate!.formatDesc()
    }
    
    var e_isAlarm_desc: String {
        
        return e_isAlarm == true ? "需要提醒" : "不需要提醒"
    }
    
    var e_alarmDate_desc: String {
        
        if e_isAlarm == false {
            return ""
        } else if e_alarmDate == nil {
            
            return MLEvent.e_alarmDate_ph
        }
        return e_alarmDate!.formatDesc()
    }
    
    var e_alarmType_desc: String {
        
        if e_isAlarm == false { return "" }
        if e_alarmRepeatType == nil { return MLEvent.e_alarmRepeatTye_ph }
        return e_alarmRepeatType!.desc
    }
    
    var e_note_desc: String {
        
        return e_note ?? MLEvent.e_note_ph
    }
}
