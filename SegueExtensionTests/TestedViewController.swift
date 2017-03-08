
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
    var sender: Any? {get set}
}

class TestedViewController: UIViewController, UIViewControllerTestDelegate {

    fileprivate let ONCE = 1
    
    var isOriginMethodInvoked = false
    var originMethodInvokeCount: Int = 0
    
    var isHandlerInvoked = false
    var handlerInvokeCount: Int = 0
    
    var sender: Any?
    var strongRef: SimpleClass?
    weak var weakRef: SimpleClass?
    
    var testDelegate: TestedViewControllerDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // invoke performSegueWithIdentifier without handler.
    func makePureSegue(_ segueID: String, fromSender sender: String) {
        // reset all object properties
        resetAll()
        
        performSegue(withIdentifier: segueID, sender: sender)
        testDelegate?.checkOriginMethodInvoked(ONCE, forController: self)
    }
    
    // perform segue with block
    func makeSegueWithHandler(_ segueID: String, fromSender sender: String) {
        resetAll()
        
        performSegue(withIdentifier: segueID, sender: sender) { [unowned self] segue, sender in
            self.isHandlerInvoked = true
            self.handlerInvokeCount += 1
        }
        testDelegate?.checkOriginMethodInvoked(ONCE, forController: self)
        testDelegate?.checkHandlerBlockInvoked(ONCE, forController: self)
    }
    
    // make pure segue without handler block and two segues with blocks
    func makeSeveralSeguesWithDiffHandlers(_ segueID: String, fromSender sender: String) {
        resetAll()
        
        performSegue(withIdentifier: segueID, sender: sender)
        
        performSegue(withIdentifier: segueID, sender: sender) { [unowned self] segue, sender in
            self.isHandlerInvoked = true
            self.handlerInvokeCount += 1
            self.sender = "FirstHandler"
        }
        testDelegate?.checkHandlerBlockInvokedOnceForSender("FirstHandler", forController: self)
        handlerInvokeCount = 0
        isHandlerInvoked = false
        
        performSegue(withIdentifier: segueID, sender: sender) { [unowned self] segue, sender in
            self.isHandlerInvoked = true
            self.handlerInvokeCount += 1
            self.sender = "SecondSender"
        }
        testDelegate?.checkHandlerBlockInvokedOnceForSender("SecondSender" , forController: self)
        testDelegate?.checkOriginMethodInvoked(3, forController: self)
    }
    
    // perform segue to check argumens in block
    func makeSegueToValidArguments(_ segueID: String, withSender sender: Any) {
        resetAll()
        self.sender = sender
        
        performSegue(withIdentifier: segueID, sender: sender) { [unowned self] segue, sender in
            self.isHandlerInvoked = true
            self.handlerInvokeCount += 1
            
            self.testDelegate?.checkArguments(segue, andSender: sender, forContoroller: self)
        }
    }
    
    // perform segue to check ARC (after block exec, all strong ref clean)
    func makeSegueToCheckRefConter(_ segueID: String, withSender sender: Any) {
        resetAll()
        strongRef = SimpleClass()
        weakRef = strongRef
        
        performSegue(withIdentifier: segueID, sender: sender) { [unowned self] segue, sender in
            let someProp = self.strongRef
            XCTAssertNotNil(someProp)
        }
        strongRef = nil
        testDelegate?.checkWeakReference(self)
    }
    
    // default action for segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        isOriginMethodInvoked = true
        originMethodInvokeCount += 1
        self.sender = sender
        
        testDelegate?.checkArguments(segue, andSender: sender, forContoroller: self)
    }
    
    fileprivate func resetAll(){
        isOriginMethodInvoked = false
        originMethodInvokeCount = 0
        isHandlerInvoked = false
        handlerInvokeCount = 0
    }
}

protocol TestedViewControllerDelegate {
    func checkOriginMethodInvoked(_ count: Int, forController controller: TestedViewController)
    func checkHandlerBlockInvoked(_ count: Int, forController controller: TestedViewController)
    func checkHandlerBlockInvokedOnceForSender(_ sender: Any?, forController controller: TestedViewController)
    func checkArguments(_ segue: UIStoryboardSegue, andSender sender: Any?, forContoroller controller: TestedViewController)
    func checkWeakReference(_ controller: TestedViewController)
}
