//
//  MLEventType+Sound.swift
//  Mylist
//
//  Created by Kobe on 2019/8/28.
//  Copyright © 2019 Kobe. All rights reserved.
//

import Foundation
import UserNotifications
extension MLEventType {
    
    func sound() -> UNNotificationSound {
        
        var source: String?
        switch self {
        case .et_amb: source = "surprise.aiff"
        case .et_cdt: source = "credential.wav"
        case .et_ctd: source = "bb.wav"
        case .et_pdt: source = "payDebt.wav"
        default: break
        }
        if source == nil { return UNNotificationSound.default() }
        
        return UNNotificationSound(named: source!)
    }
}
