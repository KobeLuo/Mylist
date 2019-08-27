//
//  MLPicker.swift
//  Mylist
//
//  Created by ANine on 2019/8/27.
//  Copyright © 2019 Kobe. All rights reserved.
//

import Foundation
import UIKit

typealias T = MLTypeProtocol
typealias MLPickerResult = (T) -> Void

class MLPicker: UIView, UITableViewDataSource, UITableViewDelegate {
    
    var invoke: MLPickerResult?
    var list: [T]?
    var table: UITableView?
    
    class func showPicker(inView superview: UIView,
                          list:[T],
                          completeHandle: @escaping MLPickerResult) {
        
        let picker = MLPicker.init(frame: superview.bounds)
        picker.list = list
        picker.invoke = completeHandle
        superview.addSubview(picker)
        
        picker.intialSubviews(superview: superview)
        picker.backgroundColor = UIColor.init(white: 0, alpha: 0.6)
    }
    
    func intialSubviews(superview: UIView) {
        
        let tableHeight: CGFloat = 200
        let off_y = (superview.height - tableHeight) / 2
        let side: CGFloat = 10
        let rect = CGRect(x: side,
                          y: off_y,
                          width: (superview.width - 2 * side),
                          height: tableHeight)
        table = UITableView.init(frame: rect , style: UITableViewStyle.plain)
        table!.delegate = self
        table!.dataSource = self
        table!.backgroundColor = UIColor.init(white: 1, alpha: 0.9)
        
        self.addSubview(table!)
        table!.reloadData()
    }
    
    // MARK: UITableView & datasource
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int { return list!.count }
    
    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat { return 30 }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let identifier = "mlpicker_reusecell"
        var cell: UITableViewCell? = table?.dequeueReusableCell(withIdentifier: identifier)
        if cell == nil {
            
            cell = UITableViewCell.init(style: .default, reuseIdentifier: identifier)
        }
        
        let t: MLTypeProtocol = list![indexPath.row]
        cell?.textLabel?.text = t.typeDesc()
        cell?.textLabel?.textAlignment = .center
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let value = list![indexPath.row]
        guard let resultInvoke = invoke else { return }
        resultInvoke(value)
        
        self.removeFromSuperview()
    }
    
    deinit {
        print("\(self.description) did dealloc")
    }
}
