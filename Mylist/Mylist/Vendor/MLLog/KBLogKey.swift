//
//  KBLogKey.swift
//  Mylist
//
//  Created by Kobe on 2019/9/11.
//  Copyright © 2019 Kobe. All rights reserved.
//

public enum LogKey: String {
    
    case editEvent
    case addEvent
    case process
}
// 0 -> both not print , 1 -> just print in local ,
// 2 -> print both in local and nelo
func logLevelDictionary() -> [String : Int]{
    return [
        LogKey.editEvent.rawValue :         2,
        LogKey.addEvent.rawValue :          2,
        LogKey.process.rawValue :           2,
    ]
}
