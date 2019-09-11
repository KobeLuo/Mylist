//
//  MainViewController.swift
//  Mylist
//
//  Created by Kobe on 2018/12/5.
//  Copyright © 2018 Kobe. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    @IBOutlet weak var addBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        addBtn.addAnimatorWhenTapped()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

