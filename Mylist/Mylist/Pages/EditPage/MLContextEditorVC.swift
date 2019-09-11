//
//  MLContextEditorVC.swift
//  Mylist
//
//  Created by Kobe on 2019/8/21.
//  Copyright © 2019 Kobe. All rights reserved.
//

import UIKit

class MLContextEditorVC: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var textView: UITextView!
    var editType: MLEditorContextType?
    var context: String?
    var endInvoke: MLContextInvoke?
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        textView.text = context
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        
        if isMovingFromParentViewController {
            
            if endInvoke != nil { let _ = endInvoke!(textView.text) }
        }
        
//        let observer: AnyObserver<String> = AnyObserver {
//            [weak self] (event) in
//
//            switch event {
//
//            case .next(let value):
//                self?.textView.text = value
//            default: break
//            }
//        }
        
        
    }
    
    func observeEndEditing(invoke: @escaping MLContextInvoke) { endInvoke = invoke }
    
    deinit {
        print("\(self.description) did dealloc")
    }
    
    
}

//extension Reactive where Base: UIView {
//    public var isHidden: Binder<Bool> {
//        return Binder(self.base) { view, hidden in
//            view.isHidden = hidden
//        }
//    }
//}

