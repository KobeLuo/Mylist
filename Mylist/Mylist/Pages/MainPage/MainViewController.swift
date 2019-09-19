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
    @IBOutlet weak var listTable: UITableView!
    @IBOutlet weak var menuBtn: UIButton!
    var dbList: [MLEvent]!
    var eventMap = [MLEventIdType : [MLEvent]]()
    var tableDelegator: MLMainTableDelegator!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        addBtn.addAnimatorWhenTapped()
        
        LogInfo(key: .database, detail: "db path:\(NSHomeDirectory()+"/Documents/myList.db")")
        
        setupTableView()
        
        prepareData()
        listTable.reloadData()
    }

    @IBAction func menuAction(_ button: UIButton) {
        
        var transform = CGAffineTransform.identity
        if button.imageView?.transform.isIdentity == true {
            
            transform = CGAffineTransform.init(rotationAngle: CGFloat.pi/2)
            
            KBTagPicker.pickerFrom(list: MLMainShowType.typeDescList(), showIn: view) { (oldList,newList) in
                
                let list = self.filterList(oldlist: oldList, newlist: newList)
             
                KBTagPicker.pickerSelected(list: list)
            }
        }else {
            
            let list = KBTagPicker.removePicker()
            print("end list:\(list)")
            //update hashMap
        }
        
        UIView.animate(withDuration: 0.1) {
            
            button.imageView?.transform = transform
        }
    }
    
    func filterList(oldlist: [String],newlist: [String]) -> [String] {
        
        var list = newlist
        var oldInfo = [String: Int]()
        var newInfo = [String: Int]()
        let _ = oldlist.map { (v) -> Int in oldInfo[v] = 1; return 0 }
        let _ = newlist.map { (v) -> Int in newInfo[v] = 1; return 0 }
        let allDesc = MLMainShowType.all.desc
        let allList = MLMainShowType.typeDescList()
        if oldInfo[allDesc] == 1 {
            
            if newInfo[allDesc] == nil {
                
                list = [String]()
            }else if newInfo.keys.count < oldInfo.keys.count {
                
                newInfo.removeValue(forKey: allDesc)
                
                list = newInfo.map({ (k,_) -> String in return k })
            }
        }else {
            
            if newInfo[allDesc] == 1 {
                
                list = allList
            }else if newInfo.keys.count == allList.count - 1 {
                
                newInfo[allDesc] = 1
                list = newInfo.map({ (k,_) -> String in return k })
            }
        }

        return list
    }
    
    fileprivate func setupTableView() {
        
        tableDelegator = MLMainTableDelegator()
        tableDelegator.setup()
        
        listTable.delegate = tableDelegator
        listTable.dataSource = tableDelegator
    }
}

// Data provider
extension MainViewController {
    
    fileprivate func prepareData() {
        //access db list data
        if dbList == nil {
            
            let list: [MLEvent] = MLEventDBBiz.fetchAllEvents()
            dbList = list
        }
        
        let _ = dbList.map({ (e) in
            
            var list = [MLEvent]()
            if let oldList = eventMap[e.e_id] {
                
                list.append(contentsOf: oldList)
            }
            list.append(e)
            eventMap[e.e_id] = list
        })
        
        //prepare show list data
        var type: MLMainShowType!
        if let storeData = UserDefaults.standard.value(forKey: MLMainPageDataKey) as? String {
            
            type = MLMainShowType(desc: storeData)
        }else {
            
            type = MLMainShowType.all
            UserDefaults.standard.set(type.cacheDesc(), forKey: MLMainPageDataKey)
        }
        
        var types = [MLMainShowType]()
        let _ = type.subTypes.map { (t) in
            
            if let events = self.eventsFrom(subtype: t) {
                
                types.append(t)
                tableDelegator.dataSource[t.typeDesc()] = events
            }
        }
    }
    
    fileprivate func eventsFrom(subtype t: MLMainShowType) -> [MLEvent]? {
        
        var list = [MLEvent]()
        if let type = MLEventType.typeFrom(showType: t) {
            
            list = eventsFrom(type: type)
        }
        
        var qos: MLEventQos?
        var es: MLEventStatus?
        switch t {
        case .emergency:    qos = .eq_egy; fallthrough
        case .important:    qos = .eq_ipt; list = eventsFrom(qos:qos!)
        case .done:         es = .es_cpl; fallthrough
        case .expired:      es = .es_epr; list = eventsFrom(eventStatus: es!)
        default: break
        }
        
        return list.count > 0 ? list : nil
    }
    
    fileprivate func eventsFrom(type: MLEventType) -> [MLEvent] {
        
        var list = [MLEvent]()
        
        list = dbList.filter { (event) -> Bool in
            
            return event.e_type?.rawValue == type.rawValue
        }
        
        return list
    }
    
    fileprivate func eventsFrom(qos: MLEventQos) -> [MLEvent] {
        
        var list = [MLEvent]()
        
        list = dbList.filter({ (event) -> Bool in
            
            return event.e_qos?.rawValue == qos.rawValue
        })
        
        return list
    }
    
    fileprivate func eventsFrom(eventStatus: MLEventStatus) -> [MLEvent] {
        
        var list = [MLEvent]()
        
        list = dbList.filter({ (event) -> Bool in
            
            return event.e_state?.rawValue == eventStatus.rawValue
        })
        
        return list
    }
}

extension MLEventType {
    
    static func typeFrom(showType t: MLMainShowType) -> MLEventType? {
        
        var type: MLEventType?
        switch t {
        case .birthday:     type = .et_btd;
        case .alarmBell:    type = .et_amb;
        case .countDown:    type = .et_ctd;
        case .credit:       type = .et_cdt;
        case .normal:       type = .et_nml;
        case .payDebt:      type = .et_pdt;
        default: break
        }
        return type
    }
}


extension KBTagPicker {
    
    
}

