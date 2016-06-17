//
//  SegueExtension.swift
//  SegueExtension
//
//  Created by matyushenko on 17.06.16.
//  Copyright © 2016 matyushenko. All rights reserved.
//

import Foundation

extension UIViewController {
    
    private class func swizzlePrepareForSegueWith(handler: (@convention(block) (segue: UIStoryboardSegue, sender:AnyObject?) -> Void)?) {
        
        struct Origin {
            static var originImplementation: IMP!
        }
        Origin.originImplementation = method_getImplementation(class_getInstanceMethod(self, #selector(UIViewController.prepareForSegue(_:sender:))))
        
        if let handler = handler {
            let originalSelector = #selector(UIViewController.prepareForSegue(_:sender:))
            
            let originalMethod = class_getInstanceMethod(self, originalSelector)
            let bitHandler = unsafeBitCast(handler, AnyObject.self)
            let swizzledMethodIMP = imp_implementationWithBlock(bitHandler)
            
            method_setImplementation(originalMethod, swizzledMethodIMP)

        } else {
            let originalSelector = #selector(UIViewController.prepareForSegue(_:sender:))
            let originalMethod = class_getInstanceMethod(self, originalSelector)
            method_setImplementation(originalMethod, Origin.originImplementation)
        }
        
    }
    
//    override func performSegueWithIdentifier(identifier: String, sender sender: AnyObject?) {
//        UIViewController.swizzlePrepareForSegueWith(nil)
//        self.performSegueWithIdentifier(identifier, sender: sender)
//    }
    
    public func performSegueWithIdentifierSE(identifier: String, sender sender: AnyObject?, withSegueHandler handler: (@convention(block) (segue: UIStoryboardSegue, sender:AnyObject?) -> Void)?) {
        UIViewController.swizzlePrepareForSegueWith(handler)
        self.performSegueWithIdentifier(identifier, sender: sender)
    }
    
    public func swizzledPrepareForSegue(segue: UIStoryboardSegue, sender sender: AnyObject?) {
        print("Swizled")
        self.swizzledPrepareForSegue(segue, sender: sender)
    }
}