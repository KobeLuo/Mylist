//
//  MLEventDBBiz.swift
//  Mylist
//
//  Created by Kobe on 2019/9/2.
//  Copyright © 2019 Kobe. All rights reserved.
//

import Foundation
import FMDB

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
    }
    //MARK: public methods
    class func add(event: MLEvent) -> Bool {
        
        print(shared)
        return false
    }
    
    class func delete(event: MLEvent) -> Bool {
        
        return false
    }
    
    
}

// db resource
extension MLEventDBBiz {
    
    //MARK: private methods
    func dbQueue() -> FMDatabaseQueue {
        
        return FMDatabaseQueue(path: MLEventDBBiz.dbPath())!
    }
    
    func createTableIfNeeded() -> NSError? {
        
        let biz = MLEventDBBiz()
        // create event table
        var tableName = biz.tableName(type: .es_nml)
        var createSql = """
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
            '\(MLEventEntity.sqlKey_status)' INTEGER,
        )
        """
        
        print(createSql)
        
        // create completed table
        tableName = biz.tableName(type: .es_cpl)
        
        // create expired table
        tableName = biz.tableName(type: .es_epr)
        
        return nil
    }
    
    static func dbPath() -> String {
        
        return Bundle.main.bundlePath + "/myList.db"
    }
    func tableName(type: MLEventStatus) -> String {
        
        var name = ""
        switch type {
        case .es_nml: name = MLEventEntity().tableName()
        case .es_cpl: name = MLEventCompletedEntity().tableName()
        case .es_epr: name = MLEventExpiredEntity().tableName()
        default: break
        }
        return name
    }
}

