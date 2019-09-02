//
//  MLEntity.swift
//  Mylist
//
//  Created by Kobe on 2019/9/2.
//  Copyright © 2019 Kobe. All rights reserved.
//

import Foundation

protocol MLEntity {
  
    var updateTime: TimeInterval! {get set}
    
    func primaryKey() -> String
    func tableName() -> String
}

class MLEventEntity: MLEntity {
    
    var event: MLEvent!
    var updateTime: TimeInterval!
    
    func primaryKey() -> String {
        
        return  "\(self.event.e_id)"
    }
    func tableName() -> String {
        
        return "ml_table_event_list"
    }
}

class MLEventCompletedEntity: MLEventEntity {
    
    override func tableName() -> String {
        
        return "ml_table_event_completed_list"
    }
}

class MLEventExpiredEntity: MLEventEntity {
    
    override func tableName() -> String {
        
        return "ml_table_event_expired_list"
    }
}


// db key
extension MLEventEntity {
    
    static let sqlKey_id            = "id"
    static let sqlkey_updateDate    = "updateDate"
    static let sqlKey_body          = "body"
    static let sqlKey_title         = "title"
    static let sqlKey_subtitle      = "subtitle"
    static let sqlKey_type          = "type"
    static let sqlKey_qos           = "qos"
    static let sqlKey_fireDate      = "fireDate"
    static let sqlKey_repeatType    = "repeatType"
    static let sqlKey_isAlarm       = "isAlarm"
    static let sqlKey_alarmDate     = "alarmDate"
    static let sqlKey_alarmRepeat   = "alartRepeatType"
    static let sqlKey_note          = "note"
    static let sqlKey_icon          = "icon"
    static let sqlKey_status        = "status"
    
}

