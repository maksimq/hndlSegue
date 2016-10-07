//
//  SegueExtension.swift
//  SegueExtension
//
//  Created by matyushenko on 17.06.16.
//  Copyright © 2016 matyushenko. All rights reserved.
//

import Foundation

public typealias SegueHandler = (@convention(block) (_ segue: UIStoryboardSegue, _ sender:AnyObject?) -> Void)?

var AssociatedObjectHandle: UInt8 = 79

extension UIViewController {
    
    fileprivate var handlerPool:Dictionary<String, SegueHandler> {
        get {
            var savedPool = objc_getAssociatedObject(self, &AssociatedObjectHandle) as? Dictionary<String,SegueHandler>
            if savedPool == nil {
                let savedPoolSw = Dictionary<String, SegueHandler>()
                let savedPoolObj = unsafeBitCast(savedPoolSw, to: AnyObject.self)
                objc_setAssociatedObject(self, &AssociatedObjectHandle, savedPoolObj, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                savedPool = objc_getAssociatedObject(self, &AssociatedObjectHandle) as? Dictionary<String, SegueHandler>
            }
            return savedPool ?? [:]
        }
        set {
            let savedPool = unsafeBitCast(newValue, to: AnyObject.self)
            objc_setAssociatedObject(self, &AssociatedObjectHandle, savedPool, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    fileprivate class func swizzlePrepareForSegue() {
        let originalSelector = #selector(UIViewController.prepare(for:sender:))
        let swizzledSelector = #selector(UIViewController.swizzledPrepareForSegue(_:sender:))
            
        let originalMethod = class_getInstanceMethod(self, originalSelector)
        let swizzledMethod = class_getInstanceMethod(self, swizzledSelector)
        
        method_exchangeImplementations(originalMethod, swizzledMethod)
    }
    
    public final func performSegueWithIdentifier(_ identifier: String, sender: AnyObject?, withHandler handler: SegueHandler) {
        
        objc_sync_enter(self)
        type(of: self).swizzlePrepareForSegue()
        self.handlerPool[identifier] = handler
        self.performSegue(withIdentifier: identifier, sender: sender)
        type(of: self).swizzlePrepareForSegue()
        objc_sync_exit(self)
    }
    
    func swizzledPrepareForSegue(_ segue: UIStoryboardSegue, sender: AnyObject?) {
        self.swizzledPrepareForSegue(segue, sender: sender)
        
        if let identifier = segue.identifier {
            if let handler = self.handlerPool[identifier] {
                handler?(segue, sender)
            }
        }
    }
}
