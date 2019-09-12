//
//  KBComponentsPicker.swift
//  Mylist
//
//  Created by Kobe on 2019/9/12.
//  Copyright © 2019 Kobe. All rights reserved.
//

import Foundation
import UIKit

typealias KBTagPickerInvoke = ([String]) -> Void

class KBTagPicker: NSObject {
    
    var superview: UIView!
    var list: [String]!
    var invoke: KBTagPickerInvoke!
    var bgv: UIView!
    
    static var singlePicker: KBTagPicker?
    @discardableResult class func pickerFrom(list: [String],
                                             showIn view: UIView,
                                             _ useSingleton: Bool = true,
                                             didChangeInvoke invoke: @escaping KBTagPickerInvoke) -> KBTagPicker {
        
        if useSingleton == true {
            
            if singlePicker != nil { return singlePicker!}
        }
        
        let picker = KBTagPicker()
        picker.superview = view
        picker.list = list
        picker.invoke = invoke
        
        picker.setup()
        
        if useSingleton == true {
            
            singlePicker = picker
        }
        
        return picker
    }
    
    class func removePicker() {
        
        if singlePicker != nil && singlePicker!.bgv.superview != nil {
            
            singlePicker!.bgv.removeFromSuperview()
        }
        singlePicker?.invoke = nil
        singlePicker = nil
    }
    
    func setup() {
        
        bgv = UIView(frame: superview.bounds)
        bgv.backgroundColor = UIColor(0x000000,0.9)
        superview.addSubview(bgv)
        
        let width = superview.width
        var side: CGFloat = 20
        var viewWidth: CGFloat = 60
        var height: CGFloat = 25
        var linecount = Int((width - side) / (side + viewWidth))
        if linecount < 1 {
            
            side = 10;
            viewWidth = width - side * 2
        }else if linecount > 5 {
            
            linecount = 5;
        }
        viewWidth = (width - side * (CGFloat(linecount) + 1)) / CGFloat(linecount)
        height = height * viewWidth / CGFloat(60)
        
        let column = (list.count / linecount) + (list.count % linecount == 0 ? 0 : 1)
        
        for columnIndex in (0...column-1) {
            for lineIndex in (0...linecount-1) {
                
                let offsetx = side + (side + viewWidth) * CGFloat(lineIndex)
                let offsety = side + (side + height) * CGFloat(columnIndex)
                let view = UIView(frame: CGRect(offsetx,offsety,viewWidth,height))
                view.backgroundColor = UIColor.randomColor()
                bgv.addSubview(view)
            }
        }
    }
    
    deinit {
        
        LogInfo(key: .process, detail: "\(self) did dealloc")
    }
}

class KBTextComponents: UILabel {
    
    class func components(text: String) -> KBTextComponents {
        
        let com = KBTextComponents()
        com.text = text
        
        
    }
}

