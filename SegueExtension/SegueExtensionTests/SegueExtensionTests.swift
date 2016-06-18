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
    
    var testedController: TestedViewController?
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        self.storyboard = UIStoryboard.init(name: "MainStoryboard", bundle: NSBundle(forClass: self.dynamicType))
        
        testedController = storyboard?.instantiateViewControllerWithIdentifier("iControllerID") as? TestedViewController
        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.

        testedController?.testedMethod(){_,_ in 
            self.testedController!.result = "Ok"
        }
        XCTAssertEqual(self.testedController!.result, "Ok")
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
//        self.measureBlock {
//            // Put the code you want to measure the time of here.
//        }
    }
    
}
