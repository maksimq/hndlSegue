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
    
    private class __HandlersPool: AnyObject {
        private static var handlers = Dictionary<String,SegueHandler>()
        static func setHandler(segueID: String, handler: SegueHandler) {
            self.handlers[segueID] = handler
        }
        static func getHandler(segueID: String) -> SegueHandler? {
            return self.handlers[segueID]
        }
    }
//    private struct AssociatedKeys {
//        static let handlerPoolDescription = "segueHandlerPool"
//    }
//    
//    private var handlerPool:__HandlersPool? {
//        get {
//            return objc_getAssociatedObject(self, AssociatedKeys.handlerPoolDescription) as? __HandlersPool
//        }
//        set {
//            if let newValue = newValue {
//                objc_setAssociatedObject(self, AssociatedKeys.handlerPoolDescription, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
//            }
//        }
//    }
    
    public override class func initialize() {
        struct Static {
            static var performToken: dispatch_once_t = 0
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
        __HandlersPool.setHandler(identifier, handler: handler)
        self.performSegueWithIdentifierSE(identifier, sender: sender)
    }
    
    func prepareForSegueSE(segue: UIStoryboardSegue, sender: AnyObject?) {
        self.prepareForSegueSE(segue, sender: sender)
        guard let identifier = segue.identifier else {
            return
        }
        if let handler = __HandlersPool.getHandler(identifier) {
            handler!(segue: segue, sender: sender)
        }
    }
}