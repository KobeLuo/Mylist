//
//  MLDBError.swift
//  Mylist
//
//  Created by Kobe on 2019/9/3.
//  Copyright © 2019 Kobe. All rights reserved.
//

import Foundation

class MLDBError: Error {
    
    var description: String
    var code: Int
    init(_ str: String, _ errCode: Int = 0) {
        
        description = str
        code = errCode
    }
}
