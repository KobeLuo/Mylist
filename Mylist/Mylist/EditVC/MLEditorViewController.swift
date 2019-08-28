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
