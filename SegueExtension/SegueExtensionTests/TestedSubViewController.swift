//
//  File.swift
//  SegueExtension
//
//  Created by matyushenko on 27.06.16.
//  Copyright © 2016 matyushenko. All rights reserved.
//

import Foundation
import UIKit
import XCTest

class TestedSubViewController: TestedViewController {

    // true if overriden method prepareForSegue was invoked
    var isOverrideMethodInvoked: Bool = false

    // make performSegue without hamdler block
    override func makePureSegue(segueID: String, fromSender sender: String) {
        isOriginMethodInvoked = true
        isOverrideMethodInvoked = false
        self.performSegueWithIdentifier(segueID, sender: sender)
        
        testDelegate!.checkOverrideMethodIncoked(1, forController: self)
    }
    
    // make performSegue without block and two times with handler block
    override func makeSeveralSeguesWithDiffHandlers(segueID: String, fromSender sender: String) {
        isOriginMethodInvoked = true
        isOverrideMethodInvoked = false
        originMethodInvokeCount = 0
        
        self.performSegueWithIdentifier(segueID, sender: sender)
        testDelegate?.checkOverrideMethodIncoked(1, forController: self)
        
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
        testDelegate?.checkOverrideMethodIncoked(3, forController: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        isOriginMethodInvoked = false
        isOverrideMethodInvoked = true
        originMethodInvokeCount += 1
    }
}

extension TestedViewControllerDelegate {
    func checkOverrideMethodIncoked(count: Int, forController controller: TestedSubViewController) {
        XCTAssertTrue(controller.isOverrideMethodInvoked)
        XCTAssertFalse(controller.isOriginMethodInvoked)
        XCTAssertEqual(controller.originMethodInvokeCount, count)
    }
}
