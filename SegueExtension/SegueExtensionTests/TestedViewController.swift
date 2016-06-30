
//
//  TestedClass.swift
//  SegueExtension
//
//  Created by matyushenko on 17.06.16.
//  Copyright © 2016 matyushenko. All rights reserved.
//

import Foundation
import UIKit
import XCTest

protocol UIViewControllerTestDelegate {
    var isOriginMethodInvoked: Bool {get set}
    var isHandlerInvoked: Bool {get set}
    var sender: AnyObject? {get set}
}

class TestedViewController: UIViewController, UIViewControllerTestDelegate {

    private let ONCE = 1
    
    var isOriginMethodInvoked = false
    var originMethodInvokeCount: Int = 0
    
    var isHandlerInvoked = false
    var handlerInvokeCount: Int = 0
    
    var sender: AnyObject?
    var strongRef: SimpleClass?
    weak var weakRef: SimpleClass?
    
    var testDelegate: TestedViewControllerDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("View did Load")
    }
    
    // invoke performSegueWithIdentifier without handler.
    func makePureSegue(segueID: String, fromSender sender: String) {
        // reset all object properties
        resetAll()
        
        self.performSegueWithIdentifier(segueID, sender: sender)
        testDelegate?.checkOriginMethodInvoked(ONCE, forController: self)
    }
    
    // perform segue with block
    func makeSegueWithHandler(segueID: String, fromSender sender: String) {
        resetAll()
        
        self.performSegueWithIdentifier(segueID, sender: sender) {segue, sender in
            self.isHandlerInvoked = true
            self.handlerInvokeCount += 1
        }
        testDelegate?.checkOriginMethodInvoked(ONCE, forController: self)
        testDelegate?.checkHandlerBlockInvoked(ONCE, forController: self)
    }
    
    // make pure segue without handler block and two segues with blocks
    func makeSeveralSeguesWithDiffHandlers(segueID: String, fromSender sender: String) {
        resetAll()
        
        self.performSegueWithIdentifier(segueID, sender: sender)
        
        self.performSegueWithIdentifier(segueID, sender: sender) { segue, sender in
            self.isHandlerInvoked = true
            self.handlerInvokeCount += 1
            self.sender = "FirstHandler" as AnyObject
        }
        testDelegate?.checkHandlerBlockInvokedOnceForSender("FirstHandler", forController: self)
        handlerInvokeCount = 0
        isHandlerInvoked = false
        
        self.performSegueWithIdentifier(segueID, sender: sender) { segue, sender in
            self.isHandlerInvoked = true
            self.handlerInvokeCount += 1
            self.sender = "SecondSender" as AnyObject
        }
        testDelegate?.checkHandlerBlockInvokedOnceForSender("SecondSender", forController: self)
        testDelegate?.checkOriginMethodInvoked(3, forController: self)
    }
    
    // perform segue to check argumens in block
    func makeSegueToValidArguments(segueID: String, withSender sender: AnyObject) {
        resetAll()
        self.sender = sender
        
        self.performSegueWithIdentifier(segueID, sender: sender){ segue, sender in
            self.isHandlerInvoked = true
            self.handlerInvokeCount += 1
            
            self.testDelegate?.checkArguments(segue, andSender: sender, forContoroller: self)
        }
    }
    
    // perform segue to check ARC (after block exec, all strong ref clean)
    func makeSegueToCheckRefConter(segueID: String, withSender sender: AnyObject) {
        resetAll()
        strongRef = SimpleClass()
        weakRef = strongRef
        
        self.performSegueWithIdentifier(segueID, sender: sender){ segue, sender in
            let someProp = self.strongRef
            XCTAssertNotNil(someProp)
        }
        strongRef = nil
        testDelegate?.checkWeakReference(self)
    }
    
    // default action for segue
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        isOriginMethodInvoked = true
        originMethodInvokeCount += 1
        self.sender = sender
        
        testDelegate?.checkArguments(segue, andSender: sender, forContoroller: self)
    }
    
    private func resetAll(){
        isOriginMethodInvoked = false
        originMethodInvokeCount = 0
        isHandlerInvoked = false
        handlerInvokeCount = 0
    }
}

protocol TestedViewControllerDelegate {
    func checkOriginMethodInvoked(count: Int, forController controller: TestedViewController)
    func checkHandlerBlockInvoked(count: Int, forController controller: TestedViewController)
    func checkHandlerBlockInvokedOnceForSender(sender: AnyObject?, forController controller: TestedViewController)
    func checkArguments(segue: UIStoryboardSegue, andSender sender: AnyObject?, forContoroller controller: TestedViewController)
    func checkWeakReference(controller: TestedViewController)
}