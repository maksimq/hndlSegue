//
//  SegueExtension.swift
//  SegueExtension
//
//  Created by matyushenko on 17.06.16.
//  Copyright © 2016 matyushenko. All rights reserved.
//

import Foundation

public typealias SegueHandler = (@convention(block) (segue: UIStoryboardSegue, sender:AnyObject?) -> Void)?

var AssociatedObjectHandle: UInt8 = 0

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
    
    private class func swizzlePrepareForSegue(inout dispOnce: dispatch_once_t) {
        dispatch_once(&dispOnce) {
            let originalSelector = Selector("prepareForSegue:sender:")
            let swizzledSelector = Selector("swizzledPrepareForSegue:sender")
            
            let originalMethod = class_getInstanceMethod(self, originalSelector)
            let swizzledMethod = class_getInstanceMethod(self, swizzledSelector)
            
            method_exchangeImplementations(originalMethod, swizzledMethod)
        }
    }
    
    public final func performSegueWithIdentifier(identifier: String, sender: AnyObject?, withHandler handler: SegueHandler) {
        
        var dispatchOneSwitch: dispatch_once_t = 0
        var dispatchOneSwitchBack: dispatch_once_t = 0
        
        self.dynamicType.swizzlePrepareForSegue(&dispatchOneSwitch)
        
        handlerPool[identifier] = handler
        self.performSegueWithIdentifier(identifier, sender: sender)
        
        self.dynamicType.swizzlePrepareForSegue(&dispatchOneSwitchBack)
        
    }
    
    func swizzledPrepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        guard let identifier = segue.identifier else {
            return
        }
        if let handler = self.handlerPool[identifier] {
            handler?(segue: segue, sender: sender)
        }
    }
}