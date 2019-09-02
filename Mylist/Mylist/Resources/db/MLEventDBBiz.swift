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
        
        db.close()
    }
    //MARK: public methods
    class func add(event: MLEvent,in type: MLEventStatus) -> Bool {
        
        let queue = shared.dbQueue()
        let table_name = shared.tableName(type: type)
        guard table_name != "" else { return false }
        queue.inDatabase { (cdb) in
            
            let ks = shared.tableKeys()
            let vs = shared.tableValues(event)
            
            let sql = """
                        replace into \(table_name) (\(ks)) values (\(vs))
                      """
            print(sql)
        }
        
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
    
    func tableKeys() -> String {
        
        return """
                MLEventEntity.sqlKey_id,
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
               """
    }
    
    func tableValues(_ event: MLEvent) -> String {
        
        let str = """
                    '\(event.e_id)',
                  """
        return str
    }
    
    /**
     NSString *sql = FmtStr(@"DELETE FROM %@ WHERE %@='%@'",
     tablename,
     sqlkey_rePath,
     path);
     
     NSString *sql = FmtStr(@"SELECT * FROM %@ where %@='%@'",
     tablename,
     sqlkey_cacheKey,
     [NDAgentCacheInfo rootPathKey]);
     
     NSString *sql = FmtStr(@"SELECT * FROM %@ where %@='%@'",
     tablename,
     sqlkey_cacheKey,
     [NDAgentCacheInfo hostBundleIdKey]);
     **/
    
    
    func generateUpdateDate() -> String {
        
        return Date().dbDesc()
    }
    
    func createTableIfNeeded() -> NSError? {
        
        var err: String?
        [MLEventStatus.es_nml,.es_cpl,.es_epr].forEach { (type) in
         
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

