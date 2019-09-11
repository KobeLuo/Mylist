//
//  MLEventDBBiz.swift
//  Mylist
//
//  Created by Kobe on 2019/9/2.
//  Copyright © 2019 Kobe. All rights reserved.
//

import Foundation

class MLEventDBBiz {
    
    static let shared = MLEventDBBiz()
    var db: FMDatabase
    
    init() {
        
        // create table if needed
        db = FMDatabase(path: MLEventDBBiz.dbPath())
        if db.open() == false {
            
            print("open database error")
            return
        }
        guard createTableIfNeeded() == nil else { return }
        
        db.close()
    }
    
    //MARK: public methods
    /** Added it if event not exist, otherwise update it use new event.
     */
    class func update(event: MLEvent, in type: MLTableName) -> MLDBError? {
        
        var entity: MLEntity = MLEventEntity()
        entity.event = event
        entity.updateTime = Date().dbDesc()
        
        var result: MLDBError?
        
        let table_name = shared.tableName(type: type)

        let queue = shared.dbQueue()
        queue.inDatabase { (cdb) in
            
            let ks = shared.tableKeys()
            let vs = shared.tableValues(entity)
            
            let sql = """
                        replace into \(table_name) (\(ks)) values (\(vs))
                      """

            if cdb.executeUpdate(sql, withArgumentsIn: []) == false {
                
                result = MLDBError("error increasing when add event to db:\(table_name)")
            }
        }
        
        return result
    }
    
    class func delete(event: MLEvent, in type: MLTableName) -> MLDBError? {
        
        let id = event.e_id
        var err: MLDBError?
        
        shared.dbQueue().inDatabase { (cdb) in
            
            let table_name = shared.tableName(type: type)
            let sql = "DELETE FROM \(table_name) WHERE \(MLEventEntity.sqlKey_id)='\(id)'"
            
            if cdb.executeStatements(sql) == false {
                
                err = MLDBError("error increasing when delete from db:\(table_name)")
            }
        }
        
        return err
    }
    
    class func newestExpiredEvents() -> ([MLEvent]?,MLDBError?) {
        
        var events: [MLEvent]?
        var err: MLDBError?
        
        let list = fetchList(type: .list)
        for entity in list {
            
            let fireDate = entity.event.e_triggerDate
            if fireDate == nil {
                err = MLDBError("fire date is not found,title:\(entity.event.e_title!)"); break
            }
            
            if fireDate!.isExpired() == true {
                
                entity.event.e_state = .es_epr
                events?.append(entity.event)
            }
        }
        
        return (events,err)
    }
    
    class func migrateExpiredEvent() -> MLDBError? {
        
        var err: MLDBError?
        
        let list = fetchList(type: .list)
        for entity in list {
            
            let fireDate = entity.event.e_triggerDate
            if fireDate == nil { continue }
            if fireDate!.isExpired() == true {
                
                entity.event.e_state = .es_epr
                
                err = delete(event: entity.event, in: .list)
                if err != nil { print(err!.description) }
                
                err = update(event: entity.event, in: .expiredList)
                if err != nil { print(err!.description) }
            }
        }
        
        return err
    }
    
    class func fetchList(type: MLTableName) -> [MLEventEntity] {
        
        var list = [MLEventEntity]()
        
        shared.dbQueue().inDatabase { (cdb) in
            
            let table_name = shared.tableName(type: type)
            let sql = "SELECT * FROM \(table_name)"

            guard let set = cdb.executeQuery(sql, withArgumentsIn: []) else { return }
            
            while set.next() == true {
                
                let entity = entityFrom(set: set)
                list.append(entity)
            }
        }
        
        return list
    }
    
    class func entityFrom(set: FMResultSet) -> MLEventEntity {
        
        let id = set.int(forColumn: MLEventEntity.sqlKey_id)
        let udate = set.string(forColumn: MLEventEntity.sqlkey_updateDate)
        let body = set.string(forColumn: MLEventEntity.sqlKey_body)
        let title = set.string(forColumn: MLEventEntity.sqlKey_title)
        let subtitle = set.string(forColumn: MLEventEntity.sqlKey_subtitle)
        let type = set.int(forColumn: MLEventEntity.sqlKey_type)
        let qos = set.int(forColumn: MLEventEntity.sqlKey_qos)
        let fireDate = set.string(forColumn: MLEventEntity.sqlKey_fireDate)
        let repeatType = set.int(forColumn: MLEventEntity.sqlKey_repeatType)
        let isAlarm = set.bool(forColumn: MLEventEntity.sqlKey_isAlarm)
        let alarmDate = set.string(forColumn: MLEventEntity.sqlKey_alarmDate)
        let note = set.string(forColumn: MLEventEntity.sqlKey_note)
        let icon = set.string(forColumn: MLEventEntity.sqlKey_icon)
        let status = set.int(forColumn: MLEventEntity.sqlKey_status)
        
        let entity = MLEventEntity()
        entity.updateTime = udate
        
        var event = MLEvent()
        event.e_id = Int16(id)
        event.e_body = body
        event.e_title = title
        event.e_subtitle = subtitle
        event.e_type = MLEventType(rawValue: type)
        event.e_qos = MLEventQos(rawValue: qos)
        event.e_triggerDate = fireDate?.dateFromDBDesc()
        event.e_repeatType = MLEventRepeatScheme(rawValue: repeatType)
        event.e_isAlarm = isAlarm
        event.e_alarmDate = alarmDate?.dateFromDBDesc()
        event.e_note = note
        event.e_icAdr = icon
        event.e_state = MLEventStatus(rawValue: status)
        
        entity.event = event
        
        return entity
    }
}

// db resource
extension MLEventDBBiz {
    
    //MARK: private methods
    func dbQueue() -> FMDatabaseQueue {
        
        return FMDatabaseQueue(path: MLEventDBBiz.dbPath())!
    }
    
    func tableKeys() -> String {
        
        return  [MLEventEntity.sqlKey_id,
                MLEventEntity.sqlkey_updateDate,
                MLEventEntity.sqlKey_body,
                MLEventEntity.sqlKey_title,
                MLEventEntity.sqlKey_subtitle,
                MLEventEntity.sqlKey_type,
                MLEventEntity.sqlKey_qos,
                MLEventEntity.sqlKey_fireDate,
                MLEventEntity.sqlKey_repeatType,
                MLEventEntity.sqlKey_isAlarm,
                MLEventEntity.sqlKey_alarmDate,
                MLEventEntity.sqlKey_note,
                MLEventEntity.sqlKey_icon,
                MLEventEntity.sqlKey_status
            ].reduce("", { return $0 == "" ? $1 : $0 + "," + $1
            })
    }
    
    func tableValues(_ entity: MLEntity) -> String {
        
        let event = entity.event!
        
        let  arr: [String] = ["\(event.e_id)",
                entity.updateTime,
                event.e_body ?? "",
                event.e_title ?? "",
                event.e_subtitle ?? "",
                "\(event.e_type!.rawValue)",
                "\(event.e_qos!.rawValue)",
                event.e_triggerDate!.dbDesc(),
                "\(event.e_repeatType!.rawValue)",
                "\(event.e_isAlarm.hashValue)",
                event.e_alarmDate?.dbDesc() ?? "",
                event.e_note ?? "",
                event.e_icAdr ?? "",
                "\(event.e_state!.rawValue)"]
        return arr.reduce("", { return $0 == "" ? "'\($1)'" : $0 + "," + "'\($1)'"
        })
    }
    
    func generateUpdateDate() -> String {
        
        return Date().dbDesc()
    }
    
    func createTableIfNeeded() -> NSError? {
        
        var err: String?
        [MLTableName.list,.completedList,.expiredList].forEach { (type) in
         
            // create event table
            let tableName = self.tableName(type: type)
            let createSql = """
            CREATE TABLE IF NOT EXISTS '\(tableName)' (
            '\(MLEventEntity.sqlKey_id)' INTEGER PRIMARY KEY,
            '\(MLEventEntity.sqlkey_updateDate)' TEXT,
            '\(MLEventEntity.sqlKey_body)' TEXT,
            '\(MLEventEntity.sqlKey_title)' TEXT,
            '\(MLEventEntity.sqlKey_subtitle)' TEXT,
            '\(MLEventEntity.sqlKey_type)' INTEGER,
            '\(MLEventEntity.sqlKey_qos)' INTEGER,
            '\(MLEventEntity.sqlKey_fireDate)' TEXT,
            '\(MLEventEntity.sqlKey_repeatType)' INTEGER,
            '\(MLEventEntity.sqlKey_isAlarm)' BOOLEAN,
            '\(MLEventEntity.sqlKey_alarmDate)' TEXT,
            '\(MLEventEntity.sqlKey_note)' TEXT,
            '\(MLEventEntity.sqlKey_icon)' TEXT,
            '\(MLEventEntity.sqlKey_status)' INTEGER)
            """

            if db.executeStatements(createSql) == false {
                
                err = "create table:\(tableName) error"
                return
            }else {
                
                print("create table success: \(tableName)")
            }
        }
        
        if err != nil {
            
            return NSError(domain: err!, code: 0, userInfo: nil)
        }
        
        return nil
    }
    
    static func dbPath() -> String {
        
        return Bundle.main.bundlePath + "/myList.db"
    }
    func tableName(type: MLTableName) -> String {
        
        var name = ""
        switch type {
        case .list:             name = MLEventEntity().tableName()
        case .completedList:    name = MLEventCompletedEntity().tableName()
        case .expiredList:      name = MLEventExpiredEntity().tableName()
        default: break
        }
        return name
    }
}

