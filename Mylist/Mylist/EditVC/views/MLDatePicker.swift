//
//  MLDatePicker.swift
//  Mylist
//
//  Created by ANine on 2019/8/28.
//  Copyright © 2019 Kobe. All rights reserved.
//

import Foundation
import UIKit

typealias MLDatePickerResult = (Date?) -> Void

class MLDatePicker: UIView, UIGestureRecognizerDelegate {
    
    var datePicker: UIDatePicker?
    var maxDate: Date?
    var invoke: MLDatePickerResult?
    
    class func showDatePicker(inview superview: UIView,
                              _ maxDate: Date? = nil,
                              completedHandle: @escaping MLDatePickerResult) {
        
        let picker = MLDatePicker.init(frame: superview.bounds)
        picker.invoke = completedHandle
        picker.maxDate = maxDate
        
        superview.addSubview(picker)
        
        picker.intialSubviews(superview: superview)
        picker.backgroundColor = UIColor.init(white: 0, alpha: 0.6)
    }
    
    func intialSubviews(superview: UIView) {
        
        //load tap gesture
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(tap(tap:)))
        tap.delegate = self
        self.addGestureRecognizer(tap)
        
        //load table
        let tableHeight: CGFloat = 200
        let off_y = (superview.height - tableHeight) / 2
        let side: CGFloat = 10
        let rect = CGRect(x: side,
                          y: off_y,
                          width: (superview.width - 2 * side),
                          height: tableHeight)
        datePicker = UIDatePicker.init(frame: rect)
        datePicker!.calendar = Calendar.init(identifier: Calendar.Identifier.chinese)
        datePicker!.maximumDate = maxDate
        datePicker!.minimumDate = Date()
//        NSLocale *locale = [[NSLocale alloc]initWithLocaleIdentifier:@"zh_CN"];
        let locale = Locale.init(identifier: "zh_CN")
        datePicker!.locale = locale
        datePicker!.timeZone = TimeZone.current
        datePicker!.datePickerMode = .dateAndTime
        datePicker!.setCornerRadius(v: 5)
        datePicker!.setBoard(width: 2, color: UIColor(white: 0.9, alpha: 1))
        datePicker!.backgroundColor = UIColor.gray
        self.addSubview(datePicker!)
    }
    
    @objc func tap(tap:UITapGestureRecognizer?) {
        
        revoke(v: nil)
    }
    
    func revoke(v: Date?) {
        
        if invoke != nil {
            
            invoke!(v)
        }
        
        self.removeFromSuperview()
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        
        return touch.view! == self
    }
}

