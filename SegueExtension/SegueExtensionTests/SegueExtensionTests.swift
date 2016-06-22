//
//  SegueExtensionTests.swift
//  SegueExtensionTests
//
//  Created by matyushenko on 17.06.16.
//  Copyright © 2016 matyushenko. All rights reserved.
//

import XCTest
@testable import SegueExtension

class SegueExtensionTests: XCTestCase {
    
    var window: UIWindow?
    var storyboard: UIStoryboard?
    
    var firstViewController: TestedViewController?
    var secondViewController: SecondViewController?
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        self.storyboard = UIStoryboard.init(name: "MainStoryboard", bundle: NSBundle(forClass: self.dynamicType))
        
        firstViewController = storyboard?.instantiateViewControllerWithIdentifier("testViewID") as? TestedViewController
        secondViewController = storyboard?.instantiateViewControllerWithIdentifier("SecondViewID") as? SecondViewController
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testForFirstController() {
        
        firstViewController?.testedMethod("SomeSenderSecond")
        checkAndReset(firstViewController!, result: "prepareForSegue", sender: "SomeSenderSecond")
        
        firstViewController?.firstTest()
        checkAndReset(firstViewController!, result: "Handler for first segue", sender: "SomeSender1")
        
        firstViewController?.secondTest()
        checkAndReset(firstViewController!, result: "Handler for second segue", sender: "SomeSender2")
    }
    
    func testForSecondController() {
        
        secondViewController?.firstTest()
        checkAndReset(secondViewController!, result: "Handler for first segue", sender: "SomeSender1")
    }
    
    func testPerformanceForFirstControllerOS() {
        // invocate origin performSegeuWith..
        // after that invocate performSegueWith..+handler
        self.measureBlock { [weak self] in
           
            self!.firstViewController?.testedMethod("SomeSenderSecond")
            self!.checkAndReset(self!.firstViewController!, result: "prepareForSegue", sender: "SomeSenderSecond")
            
            self!.firstViewController?.firstTest()
            self!.checkAndReset(self!.firstViewController!, result: "Handler for first segue", sender: "SomeSender1")
        }
    }
    
    func testPerformanceForFirstControllerSS() {
        // alternate method invocation 
        // both methods invoked with handlers for different segeuIDs
        self.measureBlock { [weak self] in
            
            self!.firstViewController?.firstTest()
            self!.checkAndReset(self!.firstViewController!, result: "Handler for first segue", sender: "SomeSender1")
            
            self!.firstViewController?.secondTest()
            self!.checkAndReset(self!.firstViewController!, result: "Handler for second segue", sender: "SomeSender2")
        }
    }
    
    func testPerformanceBothControllers() {
        self.measureBlock{ [weak self] in
            self!.firstViewController?.firstTest()
            self!.checkAndReset(self!.firstViewController!, result: "Handler for first segue", sender: "SomeSender1")
            
            self!.secondViewController?.firstTest()
            self!.checkAndReset(self!.secondViewController!, result: "Handler for first segue", sender: "SomeSender1")
        }
    }
    
    func checkAndReset(var controller: UIViewControllerTestDelegate, result: String?, sender: String?) {
        XCTAssertEqual(controller.result, result)
        XCTAssertEqual(controller.sender as? String, sender)
        controller.result = nil
        controller.sender = nil
    }
}
