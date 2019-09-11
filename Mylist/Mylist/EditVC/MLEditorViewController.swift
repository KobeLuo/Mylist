//
//  MLEditorViewController.swift
//  Mylist
//
//  Created by Kobe on 2019/2/20.
//  Copyright © 2019 Kobe. All rights reserved.
//

import UIKit

class MLEditorViewController: UIViewController,UITextFieldDelegate,UITextViewDelegate {
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    var tableDelegate: MLEditorTableDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        initialTable()
    }
    
    func initialTable() {
        
        tableDelegate = MLEditorTableDelegate()
        tableView.delegate = tableDelegate
        tableView.dataSource = tableDelegate
        tableDelegate.table = tableView
        tableDelegate.naviView = self.navigationController?.view
        
        tableView.tableHeaderView = UIView.init(frame: CGRect(0,0,tableView.width,20))
        tableView.reloadData()
        
        tableDelegate.observeContextEdit { [weak self] (value) in
            
            self?.pushContextVC(type: value)
        }
//        self.tableView.backgroundColor = UIColor.red;
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: UITextFieldDelegate
    func textFieldDidEndEditing(_ textField: UITextField) {
    }
    
    @IBAction func saveAction(_ sender: Any) {
        
        
        if let msg = eventValidate() {
            
            MLAlert.alert(title: "保存失败", message: msg)
            
            return
        }
        
        if cacheDB(tableDelegate.event!) {
            
            MLAlert.alert(title: "保存成功", message: "", { (act) in
                
                    self.navigationController?.popViewController(animated: true)
                })
        }
    }
    
    func eventValidate() -> String? {
        
        var str = ""
        let event = tableDelegate.event!
        guard event.e_title != nil else {
            
            str = event.e_title_desc
            return str
        }
        
        guard event.e_type != nil else {
            
            str = event.e_type_desc
            return str
        }
        
        guard event.e_qos != nil else {
            
            str = event.e_qos_desc
            return str
        }
        
        guard event.e_triggerDate != nil else {
            
            str = event.e_triggerDate_desc
            return str
        }
        
        guard event.e_repeatType != nil else {
            
            str = event.e_repeat_desc
            return str
        }
        
        if event.e_isAlarm == true {
            
            guard tableDelegate.event.e_alarmDate != nil else {
                
                str = tableDelegate.event.e_alarmDate_desc
                return str
            }
            
            guard tableDelegate.event.e_alarmRepeatType != nil else {
                
                str = tableDelegate.event.e_alarmType_desc
                return str
            }
        }
        return nil
    }
    
    func cacheDB(_ e: MLEvent) -> Bool {
        
        var event = e
        if event.e_state == nil {
            
            event.e_state = MLEventStatus.es_nml
        }
        
        let err = MLEventDBBiz.update(event: event, in: .list)
        guard err == nil else {
            
            LogError(key: .process, detail: "add event to db error:\(err!.description)")
            return false
        }
        return true
    }
    
    // MARK: push context viewcontroller
    func pushContextVC(type: MLEditorContextType) {
        
        print("push context vc")
        let event = self.tableDelegate.event!
        let info = [MLEditorContextType.title:      event.e_title,
                    MLEditorContextType.subtitle:   event.e_subtitle,
                    MLEditorContextType.note:       event.e_note]
        
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let controller = sb.instantiateViewController(withIdentifier: "MLContextEditorVC") as! MLContextEditorVC
        controller.editType = type
        controller.context = info[type]!
        controller.observeEndEditing { [weak self] (v) -> Void in
            
            var value = v
            if value == "" { value = nil }
            
            switch type {
            case .title:
                self?.tableDelegate.event.e_title = value
            case .subtitle:
                self?.tableDelegate.event.e_subtitle = value
            case .note:
                self?.tableDelegate.event.e_note = value
            }
            self?.tableView.reloadData()
        }

        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    
    deinit {
        print("\(self.description) did dealloc")
    }
}
