//
//  MLEditorTableViewDelegate.swift
//  Mylist
//
//  Created by Kobe on 2019/8/21.
//  Copyright © 2019 Kobe. All rights reserved.
//

import UIKit

typealias MLContextInvoke = (String?) -> Void
typealias MLContextTypeInvoke = (MLEditorContextType) -> Void

enum MLEditorContextType {
    
    case title
    case subtitle
    case note
}

class MLEditorTableDelegate:NSObject,UITableViewDelegate,UITableViewDataSource {
    
    var event: MLEvent!
    var cInvoke: MLContextTypeInvoke?
    override init() {
        
        event = MLEvent.init()
    }
    
    override func `self`() -> Self {
        
        return self
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let sectionRow = [0:2,1:4,2:3,3:1]
        return sectionRow[section]!
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return ["Event Name","Event","Alarm","Note"][section]
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let identifier = "label context"
        var cell = tableView.dequeueReusableCell(withIdentifier: identifier)
        if nil == cell {
            
            cell = UITableViewCell.init(style: UITableViewCellStyle.default, reuseIdentifier: identifier)
        }
        let textInfo = [IndexPath.init(row: 0, section: 0): event.e_title,
                        IndexPath.init(row: 1, section: 0): event.e_subtitle];
        cell?.textLabel?.text = textInfo[indexPath]
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 0 && (cInvoke != nil) {
            
            let value = [0: MLEditorContextType.title, 1: .subtitle][indexPath.row]
            cInvoke!(value!)
        }
    }
    
    // MARK: Observer
    func observeContextEdit(invoke: @escaping MLContextTypeInvoke) { cInvoke = invoke }
}
