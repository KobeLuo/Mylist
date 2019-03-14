//
//  MLEditorViewController.swift
//  Mylist
//
//  Created by Kobe on 2019/2/20.
//  Copyright © 2019 Kobe. All rights reserved.
//

import UIKit

class MLEditorViewController: UIViewController,UITextFieldDelegate,UITextViewDelegate {
    @IBOutlet weak var titleF: UITextField!
    @IBOutlet weak var noteT: UITextView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var confirmB: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: UITextFieldDelegate
    func textFieldDidEndEditing(_ textField: UITextField) {
    }
    
    
    // MARK: confirm action
    @IBAction func confirmAction(_ sender: Any) {
        
        guard let title = self.titleF.text else { return }
        let date = datePicker.date
        
        
    }
    
}
