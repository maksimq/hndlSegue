//
//  SegueExtension.swift
//  SegueExtension
//
//  Created by matyushenko on 17.06.16.
//  Copyright © 2016 matyushenko. All rights reserved.
//

import Foundation

// extend UIViewController because methods prepareForSegue and performSegueWithId.. define here
extension UIViewController {
    
    public override class func initialize() {
        struct Static {
            static var token: dispatch_once_t = 0
        }
        if self !== UIViewController.self {
            return
        }
        dispatch_once(&Static.token) {
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
    
    private class func swizzlePrepareForSegueWith(handler: (@convention(block) (weakSelf: UIViewController, segue: UIStoryboardSegue, sender:AnyObject?) -> Void)?) {
        
        struct Origin {
            static var originImplementation: IMP?
        }
        
        if let handler = handler {
            
            let originalSelector = Selector("prepareForSegue:sender:")
            Origin.originImplementation = method_getImplementation(class_getInstanceMethod(self, originalSelector))
            
            let originalMethod = class_getInstanceMethod(self, originalSelector)
            let bitHandler = unsafeBitCast(handler, AnyObject.self)
            let swizzledMethodIMP = imp_implementationWithBlock(bitHandler)
            
            method_setImplementation(originalMethod, swizzledMethodIMP)
        } else {
            guard let originImplementation = Origin.originImplementation else {
                return
            }
            let originalSelector = Selector("prepareForSegue:sender:")
            let originalMethod = class_getInstanceMethod(self, originalSelector)
            method_setImplementation(originalMethod, originImplementation)
        }
    }
    
    func performSegueWithIdentifierSE(identifier: String, sender: AnyObject?) {
        self.dynamicType.swizzlePrepareForSegueWith(nil)
        self.performSegueWithIdentifierSE(identifier, sender: sender)
    }
    
    public final func performSegueWithIdentifier(identifier: String, sender: AnyObject?, withHandler handler: (@convention(block) (weakSelf: UIViewController, segue: UIStoryboardSegue, sender:AnyObject?) -> Void)) {
        self.dynamicType.swizzlePrepareForSegueWith(handler)
        self.performSegueWithIdentifierSE(identifier, sender: sender)
    }
}