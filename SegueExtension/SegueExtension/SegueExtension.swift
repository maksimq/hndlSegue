//
//  SegueExtension.swift
//  SegueExtension
//
//  Created by matyushenko on 17.06.16.
//  Copyright © 2016 matyushenko. All rights reserved.
//

import Foundation

public typealias SegueHandler = (@convention(block) (segue: UIStoryboardSegue, sender:AnyObject?) -> Void)?

extension UIViewController {
    
    private struct AssociatedKeys {
        static let handlerDescription = "handlerBlockIMP"
    }
    
    private var segueHandler: SegueHandler {
        get {
            let handler = objc_getAssociatedObject(self, AssociatedKeys.handlerDescription)
            return unsafeBitCast(handler, SegueHandler.self)
        }
        set {
            if let newValue = newValue {
                let bitHandler = unsafeBitCast(newValue, AnyObject.self)
                objc_setAssociatedObject(self, AssociatedKeys.handlerDescription, bitHandler, .OBJC_ASSOCIATION_COPY)
            } else {
                objc_setAssociatedObject(self, AssociatedKeys.handlerDescription, nil, .OBJC_ASSOCIATION_COPY)
            }
        }
    }
    
    public override class func initialize() {
        struct Static {
            static var performToken: dispatch_once_t = 0
//            static var prepareToken: dispatch_once_t = 0
        }
        if self !== UIViewController.self {
            return
        }
        dispatch_once(&Static.performToken) {
            let originalSelector = Selector("performSegueWithIdentifier:sender:")
            let swizzledSelector = Selector("performSegueWithIdentifierSE:sender:")
            
            let originalMethod = class_getInstanceMethod(self, originalSelector)
            let swizzledMethod = class_getInstanceMethod(self, swizzledSelector)
            
            let addMethod = class_addMethod(self, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod))
            if addMethod {
                class_replaceMethod(self, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod))
            } else {
                method_exchangeImplementations(originalMethod, swizzledMethod)
            }
        }
    }
    
    private class func swizzlePrepareForSegue() {
        struct Static {
            static var prepareToken: dispatch_once_t = 0
        }
        dispatch_once(&Static.prepareToken) {
            let originalSelector = Selector("prepareForSegue:sender:")
            let swizzledSelector = Selector("prepareForSegueSE:sender:")
            
            let originalMethod = class_getInstanceMethod(self, originalSelector)
            let swizzledMethod = class_getInstanceMethod(self, swizzledSelector)
            
            let addMethod = class_addMethod(self, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod))
            if addMethod {
                class_replaceMethod(self, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod))
            } else {
                method_exchangeImplementations(originalMethod, swizzledMethod)
            }
        }
    }
    
    func performSegueWithIdentifierSE(identifier: String, sender: AnyObject?) {
        self.performSegueWithIdentifierSE(identifier, sender: sender)
    }
    
    public final func performSegueWithIdentifier(identifier: String, sender: AnyObject?, withHandler handler: SegueHandler) {
        self.dynamicType.swizzlePrepareForSegue()
        segueHandler = handler
        self.performSegueWithIdentifierSE(identifier, sender: sender)
    }
    
    func prepareForSegueSE(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let handler = segueHandler {
            handler(segue: segue, sender: sender)
            segueHandler = nil
            return
        }
        self.prepareForSegueSE(segue, sender: sender)
    }
}