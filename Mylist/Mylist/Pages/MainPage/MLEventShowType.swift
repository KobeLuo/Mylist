//
//  MLEventShowType.swift
//  Mylist
//
//  Created by ANine on 2019/9/11.
//  Copyright © 2019 Kobe. All rights reserved.
//

import Foundation

enum MLMainShowType: RawRepresentable, Equatable, MLTypeProtocol {

    case all
    case credit
    case payDebt
    case normal
    case alarmBell
    case countDown
    case birthday
    case emergency
    case important
    case latest
    case done
    case expired
    case combin(value: Int32)
    
    typealias RawValue = Int32
    var rawValue: RawValue {
        
        switch self {
        case .all:          return 0xFFF
        case .credit:       return 0x001
        case .payDebt:      return 0x002
        case .normal:       return 0x004
        case .alarmBell:    return 0x008
        case .countDown:    return 0x010
        case .birthday:     return 0x020
        case .emergency:    return 0x040
        case .important:    return 0x080
        case .latest:       return 0x100
        case .done:         return 0x200
        case .expired:      return 0x400
        case .combin(value: let v): return v
        }
    }
    
    init(rawValue: RawValue) {
        
        switch rawValue {
        case 0x001:       self = .credit
        case 0x002:       self = .payDebt
        case 0x004:       self = .normal
        case 0x008:       self = .alarmBell
        case 0x010:      self = .countDown
        case 0x020:      self = .birthday
        case 0x040:      self = .emergency
        case 0x080:      self = .important
        case 0x100:     self = .latest
        case 0x200:     self = .done
        case 0x400:     self = .expired
        case 0xFFF:     self = .all
        default:        self = .combin(value: rawValue)
        }
    }
    
    init(desc: String) {
        
        switch desc {
        case MLMainShowType.all.desc:       self = .all
        case MLMainShowType.credit.desc:    self = .credit
        case MLMainShowType.payDebt.desc:   self = .payDebt
        case MLMainShowType.normal.desc:    self = .normal
        case MLMainShowType.alarmBell.desc: self = .alarmBell
        case MLMainShowType.countDown.desc: self = .countDown
        case MLMainShowType.birthday.desc:  self = .birthday
        case MLMainShowType.emergency.desc: self = .emergency
        case MLMainShowType.important.desc: self = .important
        case MLMainShowType.latest.desc:    self = .latest
        case MLMainShowType.expired.desc:   self = .expired
        case MLMainShowType.done.desc:      self = .done
        default: self = MLMainShowType(rawValue: Int32(desc)!)
        }
    }
    
    var subTypes: [MLMainShowType] {
        
        let type: MLMainShowType = self
        
        if type == .all {
            return [.emergency,.important,.countDown,.latest,.credit,
                    .payDebt,.alarmBell,.birthday,.normal,.expired,.done]
        }else if type.sameType(type: .combin(value: 0x0FF)) == false {
            
            return [type]
        }
        
        var types = [MLMainShowType]()
        
        if type.contains(type: .emergency) { types.append(.emergency) }
        if type.contains(type: .important) { types.append(.important) }
        if type.contains(type: .countDown) { types.append(.countDown) }
        if type.contains(type: .latest) { types.append(.latest) }
        if type.contains(type: .credit) { types.append(.credit) }
        if type.contains(type: .payDebt) { types.append(.payDebt) }
        if type.contains(type: .alarmBell) { types.append(.alarmBell) }
        if type.contains(type: .birthday) { types.append(.birthday) }
        if type.contains(type: .normal) { types.append(.normal) }
        if type.contains(type: .expired) { types.append(.expired) }
        if type.contains(type: .done) { types.append(.done) }
        
        return types
    }
    
    func cacheDesc() -> String { return String(self.rawValue) }
    func typeDesc() -> String { return desc }
    
    var desc: String {
        
        switch self {
        case .all:          return "全部"
        case .credit:       return "信用"
        case .payDebt:      return "债务"
        case .normal:       return "普通"
        case .alarmBell:    return "闹铃"
        case .countDown:    return "倒计时"
        case .emergency:    return "紧急"
        case .important:    return "重要"
        case .latest:       return "最近"
        case .birthday:     return "生日"
        case .expired:      return "已过期"
        case .done:         return "已完成"
        default:            return "组合"
        }
    }
    
    static func allType() -> [MLMainShowType] {
        
        return [.all, .birthday, .credit, .payDebt,
                .normal, .alarmBell, .countDown, .emergency,
                .important, .latest, .done, .expired]
    }
    static func typeDescList() -> [String] {
        
        return allType().map({ (t) -> String in
            
            return t.typeDesc()
        })
    }
    
    fileprivate func contains(type: MLMainShowType) -> Bool {
        
        return self & type == type
    }
    
    static fileprivate func &(lt: MLMainShowType, rt: MLMainShowType) -> MLMainShowType {
        
        return MLMainShowType(rawValue: lt.rawValue & rt.rawValue)
    }
    
    static internal func ==(lt: MLMainShowType, rt: MLMainShowType) -> Bool {
        
        return lt.rawValue == rt.rawValue
    }
    
    static func +(lt: MLMainShowType, rt: MLMainShowType) -> MLMainShowType {
        
        return MLMainShowType(rawValue: lt.rawValue + rt.rawValue)
    }
    
    static internal func !=(lt: MLMainShowType, rt: MLMainShowType) -> Bool {
        
        return lt.rawValue != rt.rawValue
    }
    
    fileprivate func sameType(type: MLMainShowType) -> Bool {
        
        return self.typeDesc() == type.typeDesc()
    }
}
