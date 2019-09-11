//
//  KBLog.swift
//  mxcBrowser
//
//  Created by Kobe on 2019/9/5.
//  Copyright © 2019 MXC. All rights reserved.
//

public enum LogLevel: String {
    
    case Info
    case Debug
    case Warnning
    case Error
    case Fatal
    case Important
}

public class LogConfigure {
    
    static var showFunction: Bool = false
    static var showLine: Bool = false
    static var showLevel: Bool = false
    static var showFileName: Bool = false
    static var showLineNumber: Bool = false
    static var showDate: Bool = true
}

public func LogDebug(key: LogKey, detail: String, file: String = #file, function: String = #function, line: Int = #line) {
    
    doLog(level: .Debug, key: key, detail: detail, file: file, function: function, line: line)
}

public func LogInfo(key: LogKey, detail: String, file: String = #file, function: String = #function, line: Int = #line) {
    
    doLog(level: .Info, key: key, detail: detail, file: file, function: function, line: line)
}


public func LogWarn(key: LogKey, detail: String, file: String = #file, function: String = #function, line: Int = #line) {
    
    doLog(level: .Warnning, key: key, detail: detail, file: file, function: function, line: line)
}

public func LogError(key: LogKey, detail: String, file: String = #file, function: String = #function, line: Int = #line) {
    
    doLog(level: .Error, key: key, detail: detail, file: file, function: function, line: line)
}

public func LogFatal(key: LogKey, detail: String, file: String = #file, function: String = #function, line: Int = #line) {
    
    doLog(level: .Fatal, key: key, detail: detail, file: file, function: function, line: line)
}

public func LogImportant(key: LogKey, detail: String, file: String = #file, function: String = #function, line: Int = #line) {
    
    doLog(level: .Important, key: key, detail: detail, file: file, function: function, line: line)
}


public  func Log(level: LogLevel, key: LogKey, detail: String, file: String = #file, function: String = #function, line: Int = #line) {
    
    doLog(level: level, key: key, detail: detail, file: file, function: function, line: line)
}

let logQueue_ = DispatchQueue(label: "label.queue.log.kobe")
fileprivate func logQueue() -> DispatchQueue { return logQueue_ }

fileprivate func doLog(level: LogLevel, key: LogKey, detail: String, file: String, function: String, line: Int) {
    
    let leveI: String = LogConfigure.showLevel ? "\(level.rawValue)\t" : ""
    let mustLog = (level == .Error || level == .Fatal || level == .Warnning)
    let logFlag = mapLogKey(key: key.rawValue)
    
    if logFlag == 0 && mustLog == false { return }
    
    let dated: String = LogConfigure.showDate ? milTimeString() : ""
    let filed: String = LogConfigure.showFileName ? file.name : ""
    let fnctd: String = LogConfigure.showFunction ? function : ""
    let lined: String = LogConfigure.showLine ? "[line: \(line)]" : ""
    
    var levelFlag = ""
    switch level {
    case .Error: fallthrough
    case .Fatal:
        levelFlag = "😡"
    case .Warnning:
        levelFlag = "😠"
    case .Important:
        levelFlag = "❗"
    default: break
    }
    
    let logContent = "\(levelFlag)\(leveI) \(dated) \(filed) \(fnctd) \(lined): \(detail)"
    
    print(logContent)
    //        if mustLog || logFlag == 2 {
    //
    //            self.logInLocalAndNelo(level: level, key: key, logContent: logContent) ; return
    //        }
    //
    //        if logFlag == 1 { self.logInLocal(logContent: logContent); return }
}

// this function is expend time so much
func milTimeString(_ date: Date = Date()) -> String {
    
    let dformatter = DateFormatter()
    dformatter.dateFormat = "y-MM-dd H:m:ss.SSSS"
    return dformatter.string(from:date)
}
fileprivate func mapLogKey(key:String) -> Int {
    return logLevelDictionary()[key] ?? 0
}


