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
        
        return ["事件名称","事件细节","事件提醒","备  注"][section]
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        return cellForText(table:tableView, indexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 0 && (cInvoke != nil) {
            
            let value = [0: MLEditorContextType.title, 1: .subtitle][indexPath.row]
            cInvoke!(value!)
        }
    }
    
    // MARK: Observer
    func observeContextEdit(invoke: @escaping MLContextTypeInvoke) { cInvoke = invoke }
    
    
    // MARK: Table Cell
    func cellForText(table: UITableView, indexPath: IndexPath) -> UITableViewCell {
        
        let identifier = "label context"
        var isPlaceHolder = true
        var cell = table.dequeueReusableCell(withIdentifier: identifier)
        if nil == cell {
            
            cell = UITableViewCell.init(style: UITableViewCellStyle.default, reuseIdentifier: identifier)
        }
        let textInfo = [IndexPath.init(row: 0, section: 0): event.e_title_desc,
                        IndexPath.init(row: 1, section: 0): event.e_subtitle_desc,
                        
                        IndexPath.init(row: 0, section: 1): event.e_type_desc,
                        IndexPath.init(row: 1, section: 1): event.e_triggerDate_desc,
                        IndexPath.init(row: 2, section: 1): event.e_qos_desc,
                        IndexPath.init(row: 3, section: 1): event.e_repeat_desc,
                        
                        IndexPath.init(row: 0, section: 2): event.e_isAlarm_desc,
                        IndexPath.init(row: 1, section: 2): event.e_alarmDate_desc,
                        IndexPath.init(row: 2, section: 2): event.e_alarmType_desc,
                        
                        IndexPath.init(row: 0, section: 3): event.e_note_desc,]
        let text: String = textInfo[indexPath]!
        cell?.textLabel?.text = text
        
        let isPlaceHolderInfo = [IndexPath.init(row: 0, section: 0): (text == MLEvent.e_title_ph),
                                 IndexPath.init(row: 1, section: 0): (text == MLEvent.e_subtitle_ph),
                                 
                                 IndexPath.init(row: 0, section: 1): (text == MLEvent.e_type_ph),
                                 IndexPath.init(row: 1, section: 1): (text == MLEvent.e_triggerDate_ph),
                                 IndexPath.init(row: 2, section: 1): (text == MLEvent.e_qos_ph),
                                 IndexPath.init(row: 3, section: 1): (text == MLEvent.e_repeat_ph),
                                 
                                 IndexPath.init(row: 0, section: 2): false,
                                 IndexPath.init(row: 1, section: 2): (text == MLEvent.e_alarmDate_ph),
                                 IndexPath.init(row: 2, section: 2): (text == MLEvent.e_alarmRepeatTye_ph),
                                 
                                 IndexPath.init(row: 0, section: 3): (text == MLEvent.e_note_ph),]
        
        let normalColor = UIColor.black
        let placehColor = UIColor.gray
        cell?.textLabel?.textColor = isPlaceHolderInfo[indexPath] == true ? placehColor : normalColor
        
        return cell!
    }
}
