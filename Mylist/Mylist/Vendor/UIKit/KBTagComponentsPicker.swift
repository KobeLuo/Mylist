//
//  KBComponentsPicker.swift
//  Mylist
//
//  Created by Kobe on 2019/9/12.
//  Copyright © 2019 Kobe. All rights reserved.
//

import Foundation
import UIKit

typealias KBTagPickerInvoke = ([String],[String]) -> Void
typealias KBTagComponentsSelected = (Bool) -> Void
class KBTagPicker: NSObject {
    
    var superview: UIView!
    var list: [String]!
    var selectedInfo = [String:Int]()
    var invoke: KBTagPickerInvoke!
    var bgv: UIView!
    
    static var singlePicker: KBTagPicker?
    @discardableResult class func pickerFrom(list: [String],
                                             showIn view: UIView,
                                             _ selectedList: [String]? = nil,
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
        
        var selectedList = selectedList
        if selectedList == nil { selectedList = list }
        self.pickerSelected(list: selectedList!)
        
        return picker
    }
    
    class func pickerSelected(list: [String]) {
        
        singlePicker?.pickerSelected(list: list)
    }
    
    func pickerSelected(list: [String]) {
        
        self.selectedInfo.removeAll()
        let _ = list.map({ (item) -> Int in
            
            self.selectedInfo[item] = 1
            return 0
        })
        
        for view in bgv.subviews {
            
            if let component = view as? KBTextComponents {
                
                if let text = component.text, selectedInfo[text] == 1 {
                    
                    component.selected = true
                }else {
                    
                    component.selected = false
                }
            }
        }
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
        bgv.backgroundColor = UIColor(0x000000,0.6)
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
                
                let text = list[columnIndex*linecount + lineIndex]
                let view = KBTextComponents.components(text: text)
                view.selected = selectedInfo[text] == 1
                view.observeComponentSelectedInvoke { (select) in
                    
                    let oldList = self.selectedInfo.map({ (k,_) -> String in return k })
                    if select {
                        
                        self.selectedInfo[text] = 1
                        
                    }else {
                        
                        self.selectedInfo.removeValue(forKey: text)
                    }
                    self.componentsDidChange(oldList)
                }
                view.frame = CGRect(offsetx,offsety,viewWidth,height)
//                let view = UIView(frame: CGRect(offsetx,offsety,viewWidth,height))
                view.specifyColor = UIColor.randomColor()
                bgv.addSubview(view)
            }
        }
    }
    
    func componentsDidChange(_ oldList: [String]) {
        
        if invoke != nil {
            
            let list = selectedInfo.map { (k,_) -> String in return k }
            invoke(oldList,list)
        }
    }
    
    deinit {
        
        LogInfo(key: .process, detail: "\(self) did dealloc")
    }
}

class KBTextComponents: UILabel, UIGestureRecognizerDelegate {
    
    var animation: Bool = false
    var specifyColor: UIColor?
    var invoke: KBTagComponentsSelected?
    
    private var internalS: Bool = false
    var selected: Bool {
        
        get { return internalS }
        set { internalS = newValue; self.componetSelected(internalS) }
    }
    
    func componetSelected(_ value: Bool) {
        
        var bgColor = MLMainWhiteColor
        var textColor = MLMainBlackColor
        var font = UIFont.systemFont(ofSize: UIFont.systemFontSize)
        if selected {
            
            bgColor = specifyColor ?? MLMainBlackColor
            textColor = MLMainWhiteColor
            font = UIFont.systemFont(ofSize: UIFont.systemFontSize, weight: .heavy)
        }
        
        self.textColor = textColor
        self.backgroundColor = bgColor
        self.font = font
    }
    
    class func components(text: String,
                          _ selected: Bool = false,
                          _ invoke: KBTagComponentsSelected? = nil) -> KBTextComponents {
        
        let com = KBTextComponents()
        com.text = text
        com.textAlignment = .center
        com.textColor = MLMainWhiteColor
        com.isUserInteractionEnabled = true
        com.componetSelected(selected)
        com.setBoard(width: 1, color: MLMainWhiteColor)
        
        //load tap gesture
        let tap = UITapGestureRecognizer.init(target: com, action: #selector(tap(tap:)))
        tap.delegate = com
        com.addGestureRecognizer(tap)
        
        return com
    }
    
    func observeComponentSelectedInvoke(i: @escaping KBTagComponentsSelected) { invoke = i }
    
    @objc func tap(tap:UITapGestureRecognizer?) {
        
        self.selected = self.selected ? false : true
        
        if let i = invoke { i(self.selected) }
    }
}

