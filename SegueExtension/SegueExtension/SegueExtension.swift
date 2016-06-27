//
//  SegueExtension.swift
//  SegueExtension
//
//  Created by matyushenko on 17.06.16.
//  Copyright © 2016 matyushenko. All rights reserved.
//

import Foundation

public typealias SegueHandler = (@convention(block) (segue: UIStoryboardSegue, sender:AnyObject?) -> Void)?

var AssociatedObjectHandle: UInt8 = 79

extension UIViewController {
    
    private var handlerPool:Dictionary<String, SegueHandler> {
        get {
            var savedPool = objc_getAssociatedObject(self, &AssociatedObjectHandle)
            if savedPool == nil {
                let savedPoolSw = Dictionary<String, SegueHandler>()
                let savedPoolObj = unsafeBitCast(savedPoolSw, AnyObject.self)
                objc_setAssociatedObject(self, &AssociatedObjectHandle, savedPoolObj, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                savedPool = objc_getAssociatedObject(self, &AssociatedObjectHandle)
            }
            return unsafeBitCast(savedPool, Dictionary<String,SegueHandler>.self)
        }
        set {
            let savedPool = unsafeBitCast(newValue, AnyObject.self)
            objc_setAssociatedObject(self, &AssociatedObjectHandle, savedPool, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    private class func swizzlePrepareForSegue() {
        let originalSelector = #selector(UIViewController.prepareForSegue(_:sender:))
        let swizzledSelector = #selector(UIViewController.swizzledPrepareForSegue(_:sender:))
            
        let originalMethod = class_getInstanceMethod(self, originalSelector)
        let swizzledMethod = class_getInstanceMethod(self, swizzledSelector)
        
        method_exchangeImplementations(originalMethod, swizzledMethod)
    }
    
    public final func performSegueWithIdentifier(identifier: String, sender: AnyObject?, withHandler handler: SegueHandler) {
        
        objc_sync_enter(self)
        self.dynamicType.swizzlePrepareForSegue()
        self.handlerPool[identifier] = handler
        self.performSegueWithIdentifier(identifier, sender: sender)
        self.dynamicType.swizzlePrepareForSegue()
        objc_sync_exit(self)
    }
    
    func swizzledPrepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        self.swizzledPrepareForSegue(segue, sender: sender)
        
        if let identifier = segue.identifier {
            if let handler = self.handlerPool[identifier] {
                handler?(segue: segue, sender: sender)
            }
        }
    }
}