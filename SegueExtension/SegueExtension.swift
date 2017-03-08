//
//  SegueExtension.swift
//  SegueExtension
//
//  Created by matyushenko on 17.06.16.
//  Copyright © 2016 matyushenko. All rights reserved.
//

import Foundation

public typealias SegueHandler = (@convention(block) (_ segue: UIStoryboardSegue, _ sender: Any?) -> Void)?

fileprivate var handlerPool: [String: SegueHandler] = [:]

extension UIViewController {
    
    fileprivate class func swizzlePrepareForSegue() {
        let originalSelector = #selector(UIViewController.prepare(for:sender:))
        let swizzledSelector = #selector(UIViewController.swizzledPrepareForSegue(_:sender:))
            
        let originalMethod = class_getInstanceMethod(self, originalSelector)
        let swizzledMethod = class_getInstanceMethod(self, swizzledSelector)
        
        method_exchangeImplementations(originalMethod, swizzledMethod)
    }
    
    public final func performSegue(withIdentifier identifier: String, sender: Any?, withHandler handler: SegueHandler) {
        objc_sync_enter(self)
        type(of: self).swizzlePrepareForSegue()
        handlerPool[identifier] = handler
        performSegue(withIdentifier: identifier, sender: sender)
        type(of: self).swizzlePrepareForSegue()
        objc_sync_exit(self)
    }
    
    func swizzledPrepareForSegue(_ segue: UIStoryboardSegue, sender: Any?) {
        swizzledPrepareForSegue(segue, sender: sender)
        
        if let identifier = segue.identifier {
            if let handler = handlerPool[identifier] {
                handler?(segue, sender)
                handlerPool.removeValue(forKey: identifier)
            }
        }
    }
}
