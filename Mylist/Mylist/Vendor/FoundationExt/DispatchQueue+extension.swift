//
//  DispatchQueue+extension.swift
//  NDrive_Sync
//
//  Created by Kobe on 2019/5/9.
//  Copyright © 2019 NHN. All rights reserved.
//

import Foundation

extension DispatchQueue {
    
    class func serialQueue(label: String) -> DispatchQueue {
            
        let queue = DispatchQueue(label: label)
        
        let key = DispatchSpecificKey<String>()
        queue.specificKey = key
        
        queue.assertFlag = AssociatedKeys.assertKey
        
        let value = label
        
        queue.setSpecific(key: key, value: value)
        
        return queue
    }
    
    class func safeSyncWithMain(_ closure: @escaping ()->Void) {

        if Thread.current.isMainThread { closure() }else { DispatchQueue.main.sync { closure() } }
    }
    
    /// get one boolean value to indicator whether the queue for current execution context is self
    /// - note: there will throw an exception if self is not initialized from `serialQueue`
    /// - returns: return true if is self,otherwise return false.
    func onCurrentContext() -> Bool {
        
        assert(self.assertFlag != nil , "You can't use this func until use serialQueue to initial")
        
        let key = self.specificKey!
        let value = DispatchQueue.getSpecific(key: key)
        return value == self.label
    }
    
    /// sync dispatch one excution context to self safely.
    /// - note: there will throw an exception if self is not initialized from `serialQueue`
    ///
    /// - parameter excute:  the excution context
    func safeSyncWith(excute closure: @escaping ()->Void) {

        if onCurrentContext() { closure() }else { self.sync { closure() } }
    }
    
    func asyncWith(excute closure: @escaping ()->Void) { self.async { closure() } }
    
    fileprivate struct AssociatedKeys {
        
        static var specificKey = "DispatchSpecificKey"
        static var assertKey = "AssertKey"
    }
    
    var specificKey: DispatchSpecificKey<String>? {
        
        get {
            typealias type = DispatchSpecificKey<String>
            return objc_getAssociatedObject(self, &AssociatedKeys.specificKey) as? type
        }
        
        set {
            
            if let newValue = newValue {
                
                objc_setAssociatedObject(self,
                                         &AssociatedKeys.specificKey,
                                         newValue,
                                         .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
        }
    }
    
    var assertFlag: String? {
        
        get {
            
            return objc_getAssociatedObject(self, &AssociatedKeys.assertKey) as? String
        }
        
        set {
            if let newValue = newValue {
                
                objc_setAssociatedObject(self,
                                         &AssociatedKeys.assertKey,
                                         newValue,
                                         .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
        }
    }
}
