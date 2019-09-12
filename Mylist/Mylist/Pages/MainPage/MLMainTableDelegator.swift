//
//  MLMainTableDelegatoe.swift
//  Mylist
//
//  Created by ANine on 2019/9/11.
//  Copyright © 2019 Kobe. All rights reserved.
//

import Foundation
import UIKit

class MLMainTableDelegator: NSObject, UITableViewDelegate,UITableViewDataSource {
    
    var dataSource: [String : [MLEvent]]!
    
    func setup() {
        
        dataSource = [String:[MLEvent]]()
    }
    
    //MARK: - UITableView Datasource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        return UITableViewCell(style: .default, reuseIdentifier: "default")
    }
    //MARK: - UITableView Delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
