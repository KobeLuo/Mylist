//
//  MainViewController.swift
//  Mylist
//
//  Created by Kobe on 2018/12/5.
//  Copyright © 2018 Kobe. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    @IBOutlet weak var leftBar: UIBarButtonItem!
    @IBOutlet weak var addBtn: UIButton!
    @IBOutlet weak var listTable: UITableView!
    @IBOutlet weak var menuBtn: UIButton!
    
    var eventMap = [MLEventIdType : MLEvent]()
    var type: MLMainShowType = .all
    var tableDelegator: MLMainTableDelegator!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        addBtn.addAnimatorWhenTapped()
        menuBtn.titleLabel?.adjustsFontSizeToFitWidth = true
        menuBtn.setTitle(storeType().desc, for: .normal)
        LogInfo(key: .database, detail: "db path:\(NSHomeDirectory()+"/Documents/myList.db")")
        
        setupTableView()
        
        fetchDBData()
        prepareShowData()
        listTable.reloadData()
    }

    @IBAction func menuAction(_ button: UIButton) {
        
        var transform = CGAffineTransform.identity
        if button.imageView?.transform.isIdentity == true {
            
            transform = CGAffineTransform.init(rotationAngle: CGFloat.pi/2)
            
            KBTagPicker.pickerFrom(list: MLMainShowType.typeDescList(),
                                   showIn: view) { (oldList,newList) in
                
                let list = self.filterList(oldlist: oldList, newlist: newList)
             
                KBTagPicker.pickerSelected(list: list)
            }
            
            let selectedList = storeType().subTypes.map { (type) -> String in
                
                return type.desc
            }
            
            KBTagPicker.pickerSelected(list: filterList(oldlist: selectedList,
                                                        newlist: selectedList, true))
            
        }else {
            
            KBTagPicker.removePicker()
            
            prepareShowData()
            listTable.reloadData()
        }
        
        UIView.animate(withDuration: 0.1) {
            
            button.imageView?.transform = transform
        }
    }
    
    func filterList(oldlist: [String],newlist: [String]) -> [String] {
        
        return filterList(oldlist: oldlist, newlist: newlist, false)
    }
    
    func filterList(oldlist: [String],newlist: [String],_ onlyfilter: Bool) -> [String] {
        
        var list = newlist
        var oldInfo = [String: Int]()
        var newInfo = [String: Int]()
        let _ = oldlist.map { (v) -> Int in oldInfo[v] = 1; return 0 }
        let _ = newlist.map { (v) -> Int in newInfo[v] = 1; return 0 }
        let allDesc = MLMainShowType.all.desc
        let allList = MLMainShowType.typeDescList()
        var showText = "未选"
        if oldInfo[allDesc] == 1 {
            
            if newInfo[allDesc] == nil {
                
                list = [String]()
                newInfo = [String: Int]()
            }else if newInfo.keys.count < oldInfo.keys.count {
                
                newInfo.removeValue(forKey: allDesc)
                
                list = newInfo.map({ (k,_) -> String in return k })
            }
        }else {
            
            if newInfo[allDesc] == 1 {
                
                list = allList
                newInfo = [String: Int]()
                showText = MLMainShowType.all.desc
            }else if newInfo.keys.count == allList.count - 1 {
                
                newInfo[allDesc] = 1
                list = newInfo.map({ (k,_) -> String in return k })
                showText = MLMainShowType.all.desc
            }
        }
        
        if newInfo.keys.count > 1 {
            
            showText = MLMainShowType.combin(value: 0x120).desc
        }else if newInfo.keys.count == 1 {
            
            showText = MLMainShowType.init(desc: newInfo.keys.first!).desc
        }
        
        if onlyfilter == false {
            
            cacheTypeWith(list: list)
            //update menu button
            menuBtn.setTitle(showText, for: .normal)
        }
        
        return list
    }
    
    func cacheTypeWith(list: [String]) {
        
        var info = [Int32: Int]()
        let _ = list.map { (v) -> Int in
            
            let type = MLMainShowType.init(desc: v)
            info[type.rawValue] = 1
            return 0
        }
        
        var type = MLMainShowType.all
        if info[MLMainShowType.all.rawValue] == 1 || info.keys.count == 0 {}else if info.keys.count == 1 {
            
            type = MLMainShowType.init(rawValue: info.keys.first!)
        }else  {
            
            type = MLMainShowType.combin(value: 0x000)
            type = list.reduce(type) {
                let tmp = MLMainShowType.init(desc: $1)
                return $0 + tmp
            }
        }
        print("cache desc:\(type.cacheDesc())")
        UserDefaults.standard.set(type.cacheDesc(), forKey: MLMainPageDataKey)
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
    
    fileprivate func fetchDBData() {
        
        let list: [MLEvent] = MLEventDBBiz.fetchAllEvents()
        let _ = list.map { (e) -> Int in eventMap[e.e_id] = e; return 0 }
    }
    
    fileprivate func storeType() -> MLMainShowType {
        
        var type: MLMainShowType!
        if let storeData = UserDefaults.standard.value(forKey: MLMainPageDataKey) as? String {
            
            type = MLMainShowType(desc: storeData)
        }else {
            
            type = MLMainShowType.all
            UserDefaults.standard.set(type.cacheDesc(), forKey: MLMainPageDataKey)
        }
        return type
    }
    
    fileprivate func prepareShowData() {
        
        //prepare show list data
        let type = storeType()
        
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
        
        list = eventMap.values.filter { (event) -> Bool in
            
            return event.e_type?.rawValue == type.rawValue
        }
        
        return list
    }
    
    fileprivate func eventsFrom(qos: MLEventQos) -> [MLEvent] {
        
        var list = [MLEvent]()
        
        list = eventMap.values.filter({ (event) -> Bool in
            
            return event.e_qos?.rawValue == qos.rawValue
        })
        
        return list
    }
    
    fileprivate func eventsFrom(eventStatus: MLEventStatus) -> [MLEvent] {
        
        var list = [MLEvent]()
        
        list = eventMap.values.filter({ (event) -> Bool in
            
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

extension UILabel {
    
    func setText(_ value: String) {
        
        self.text = value
    }
}

