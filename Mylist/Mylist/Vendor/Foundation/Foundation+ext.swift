//
//  Foundation+ext.swift
//  Mylist
//
//  Created by Kobe on 2019/9/12.
//  Copyright © 2019 Kobe. All rights reserved.
//

import Foundation

public func randomeDigitor(in count: UInt32) -> Int {
    
    return Int(arc4random() % count)
}
