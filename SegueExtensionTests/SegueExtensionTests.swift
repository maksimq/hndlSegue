//
//  SegueExtensionTests.swift
//  SegueExtensionTests
//
//  Created by matyushenko on 17.06.16.
//  Copyright © 2016 matyushenko. All rights reserved.
//

import XCTest
@testable import SegueExtension

/// Some test cases, what need to check
/// 1) Check that original method prepareForSegue for ViewController was called and he is called only once.
/// 2) Check that call method performSegue with handler, invoke handler and origin method only once.
/// 3) Check performSegueWithId for multiple segues one controller. All handlers and origin prepareForSegue methods must invoked once for performSegue.
/// 4) Check segue and sender arguments in block, they must store right value.
/// 5) Check that call performForSegue one controller does not affect the perform segues of other controller.
/// 6) Check ARS in blocks. All blocks must clean their strong reference.
/// 7) Check how work this extension for class inheritance. Superclass can't change subclass's.

class SegueExtensionTests: XCTestCase {
    
    var window: UIWindow?
    var storyboard: UIStoryboard?
    
    var firstViewController: TestedViewController?
    var secondViewController: TestedSubViewController?
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        window = UIWindow(frame: UIScreen.main.bounds)
        storyboard = UIStoryboard.init(name: "MainStoryboard", bundle: Bundle(for: type(of: self)))
        window?.rootViewController = storyboard?.instantiateInitialViewController()
        
        firstViewController = storyboard?.instantiateViewController(withIdentifier: "testViewID") as? TestedViewController
        firstViewController?.testDelegate = self
        
        secondViewController = storyboard?.instantiateViewController(withIdentifier: "SecondViewID") as? TestedSubViewController
        secondViewController?.testDelegate = self
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    //  1) Check that original method prepareForSegue for ViewController was called and he is called only once.
    func testIvokedOriginMethod() {
        firstViewController!.makePureSegue("SegueID1", fromSender: "Self")
    }
   
    //  2) Check that call method performSegue with handler, invoke handler and origin method only once.
    func testIvokeWithHandler() {
        let sender = "FirstViewController"
        firstViewController?.makeSegueWithHandler("SegueID1", fromSender: sender)
    }
    
    //  3) Check performSegueWithId for multiple segues one controller. All handlers and origin prepareForSegue methods must invoked once for performSegue.
    func testSeveralSeguesForOneController() {
        self.measure{
            self.firstViewController?.makeSeveralSeguesWithDiffHandlers("SegueID1", fromSender: "FirstController")
        }
    }
    
    //  4) Check segue and sender arguments in block, they must store right value.
    func testArgumentsInBlock() {
        firstViewController?.makeSegueToValidArguments("SegueID1", withSender: "FirstController")
    }
    
    //  5) Check that call performForSegue one controller does not affect the perform segues of other controller.
    //  7) Check how work this extension for class inheritance. Superclass can't change subclass's.
    func testSubClassMethods() {
        
        firstViewController?.makePureSegue("SegueID", fromSender: "FirstController")
        secondViewController?.makePureSegue("SegueID", fromSender: "SecondController")
        
        firstViewController?.makeSeveralSeguesWithDiffHandlers("SegueID", fromSender: "FirstController")
        secondViewController?.makeSeveralSeguesWithDiffHandlers("SegueID", fromSender: "SecondController")
    }
    
    //  6) Check ARS in blocks. All blocks must clean their strong reference.
    func testMemoryReleased() {
        firstViewController?.makeSegueToCheckRefConter("SegueID1", withSender: "FirstController")
    }
}

extension SegueExtensionTests: TestedViewControllerDelegate {
    func checkOriginMethodInvoked(_ count: Int, forController controller: TestedViewController) {
        XCTAssertTrue(controller.isOriginMethodInvoked)
        XCTAssertEqual(controller.originMethodInvokeCount, count)
    }
    
    func checkHandlerBlockInvoked(_ count: Int, forController controller: TestedViewController){
        XCTAssertTrue(controller.isHandlerInvoked)
        XCTAssertEqual(controller.handlerInvokeCount, count)
    }
    
    func checkHandlerBlockInvokedOnceForSender(_ sender: Any?, forController controller: TestedViewController){
        checkHandlerBlockInvoked(1, forController: controller)
        XCTAssertEqual(controller.sender as? String, sender as? String)
    }
    
    func checkArguments(_ segue: UIStoryboardSegue, andSender sender: Any?, forContoroller controller: TestedViewController) {
        XCTAssertEqual(controller, segue.source)
        XCTAssertEqual(sender as? String, controller.sender as? String)
    }
    func checkWeakReference(_ controller: TestedViewController) {
        XCTAssertNil(controller.weakRef)
    }
}
