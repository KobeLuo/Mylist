//
//  MLEditorTableViewDelegate.swift
//  Mylist
//
//  Created by Kobe on 2019/8/21.
//  Copyright © 2019 Kobe. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

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
    var rowHeight: CGFloat = 44
    var disposeBag = DisposeBag()
    var naviView: UIView!
    var table: UITableView?
    
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
        return rowHeight
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return ["事件名称","事件细节","事件提醒","备  注"][section]
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        return cellForText(table:tableView, indexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.section {
        case 0:
            if cInvoke != nil {
                
                let value = [0: MLEditorContextType.title, 1: .subtitle][indexPath.row]
                cInvoke!(value!)
            }
        case 1: eventDetailSelect(indexPath: indexPath, tableView: tableView)
        case 2: alarmDetailSelect(indexPath: indexPath, tableView: tableView)
        case 3:
            if cInvoke != nil { cInvoke!(MLEditorContextType.note) }
        default: break
            
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func alarmDetailSelect(indexPath: IndexPath,tableView: UITableView) {
        
        if self.event.e_isAlarm == false { return }
        switch indexPath.row {
        case 0: break
        case 1:
            tableView.isScrollEnabled = false
            MLDatePicker.showDatePicker(inview: self.naviView,self.event.e_triggerDate) { [weak self] (r) in
                
                if r != nil {
                    
                    self?.event.e_alarmDate = r
                    tableView.reloadRows(at: [indexPath], with: .automatic)
                }
                tableView.isScrollEnabled = true
            }
        case 2:
            tableView.isScrollEnabled = false
            MLPicker.showPicker(inView: self.naviView, list: MLEvent.e_repeat_list as [T]) { [weak self] (r) in
                
                if r != nil {
                    
                    self?.event.e_alarmRepeatType = r as? MLEventRepeatScheme
                    tableView.reloadRows(at: [indexPath], with: .automatic)
                }
                tableView.isScrollEnabled = true
            }
            
        default: break
        }
    }
    func eventDetailSelect(indexPath: IndexPath,tableView: UITableView) {
        
        tableView.isScrollEnabled = false
        switch indexPath.row {
        case 0:
            
            MLPicker.showPicker(inView: self.naviView, list: MLEvent.e_type_list as [T]) {[weak self] (r) in
                
                if r != nil {
                    
                    self?.event.e_type = r as? MLEventType
                    tableView.reloadRows(at: [indexPath], with: .automatic)
                }
                
                tableView.isScrollEnabled = true
            }
        case 1:
            
            MLDatePicker.showDatePicker(inview: self.naviView) { [weak self] (r) in
                
                if r != nil {
                    
                    self?.event.e_triggerDate = r
                    tableView.reloadRows(at: [indexPath], with: .automatic)
                }
                
                tableView.isUserInteractionEnabled = true
            }
            
        case 2:
            MLPicker.showPicker(inView: self.naviView, list: MLEvent.e_qos_list) { [weak self] (r) in
                
                if r != nil {
                    
                    self?.event.e_qos = r as? MLEventQos
                    tableView.reloadRows(at: [indexPath], with: .automatic)
                }
                
                tableView.isScrollEnabled = true
            }
        case 3:
            MLPicker.showPicker(inView: self.naviView, list: MLEvent.e_repeat_list) { [weak self] (r) in
                
                if r != nil {
                    
                    self?.event.e_repeatType = r as? MLEventRepeatScheme
                    tableView.reloadRows(at: [indexPath], with: .automatic)
                }
                
                tableView.isScrollEnabled = true
            }
        default: break
        }
    }
    
    // MARK: Observer
    func observeContextEdit(invoke: @escaping MLContextTypeInvoke) { cInvoke = invoke }
    
    
    // MARK: Table Cell
    func cellForText(table: UITableView, indexPath: IndexPath) -> UITableViewCell {
        
        let identifier = "label context"
        var cell = table.dequeueReusableCell(withIdentifier: identifier)
        if nil == cell {
            
            cell = UITableViewCell.init(style: UITableViewCellStyle.default, reuseIdentifier: identifier)
        }
        let textInfo = [IndexPath(row: 0, section: 0): (event.e_title_desc,MLEvent.e_title_ph),
                        IndexPath(row: 1, section: 0): (event.e_subtitle_desc,MLEvent.e_subtitle_ph),
                        
                        IndexPath(row: 0, section: 1): (event.e_type_desc,MLEvent.e_type_ph),
                        IndexPath(row: 1, section: 1): (event.e_triggerDate_desc,MLEvent.e_triggerDate_ph),
                        IndexPath(row: 2, section: 1): (event.e_qos_desc,MLEvent.e_qos_ph),
                        IndexPath(row: 3, section: 1): (event.e_repeat_desc,MLEvent.e_repeat_ph),
                        
                        IndexPath(row: 0, section: 2): (event.e_isAlarm_desc,""),
                        IndexPath(row: 1, section: 2): (event.e_alarmDate_desc,MLEvent.e_alarmDate_ph),
                        IndexPath(row: 2, section: 2): (event.e_alarmType_desc,MLEvent.e_alarmRepeatTye_ph),
                        
                        IndexPath(row: 0, section: 3): (event.e_note_desc,MLEvent.e_note_ph)]
        let tuple = textInfo[indexPath]!
        let text = tuple.0
        let isPlaceholder = text == tuple.1
        let normalColor = UIColor.black
        let placehColor = UIColor.gray
        cell?.textLabel?.textColor = isPlaceholder ? placehColor : normalColor
        cell?.textLabel?.text = text
        
        let tag = 10086
        var sw: UISwitch? = cell?.viewWithTag(tag) as? UISwitch
        
        if indexPath == IndexPath(row: 0, section: 2) {
            
            sw?.isHidden = false
            if sw == nil {
                
                sw = UISwitch()
                sw?.tag = tag
                cell!.addSubview(sw!)
        
                let side:CGFloat = (rowHeight - sw!.height)/2
                let offset_x = table.width - sw!.width - side
                let frame = CGRect.init(offset_x, side, sw!.width,sw!.height)
                sw!.frame = frame
                
                sw!.addTarget(self, action: #selector(valueChange(sw:)), for: .valueChanged)
                sw!.isOn = isPlaceholder
            }
            
        }else {
            
            if sw != nil { sw?.isHidden = true }
        }
        
        return cell!
    }
   
    @objc func valueChange(sw: UISwitch) {
        
        self.event.e_isAlarm = sw.isOn
        table?.reloadData()
    }
}

