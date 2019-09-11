//
//  KBCancelClosure.swift
//  mxcBrowser
//
//  Created by Kobe on 2019/9/9.
//  Copyright © 2019 MXC. All rights reserved.
//
class KBCancelClosure {
    
    var closure: (() -> Void)?
    var queue: DispatchQueue
    var isCancelled: Bool { return self.closure == nil }
    
    init(closure: (()->Void)? = nil,
         delay: DispatchTime = DispatchTime.now() + 2,
         queue: DispatchQueue = DispatchQueue.main) {
        
        self.closure = closure
        self.queue = queue
        queue.asyncAfter(deadline: delay, execute: { [weak self] in self?.closure?() })
    }
    
    func cancel() {  queue.safeSyncWith { self.closure = nil } }
}

