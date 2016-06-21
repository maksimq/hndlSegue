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

class TestedViewController: UIViewController {
    
    var result: String?
    var prepareForSegueCallCount: Int = 0
    var sender: AnyObject?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("View did Load")
    }
    
    func testedMethod(sender: AnyObject?) {
        print("Tested method without handler")
        self.performSegueWithIdentifier("TestSegueID1", sender: sender)
    }
    
    func firstTest() {
        self.performSegueWithIdentifier("TestSegueID1", sender: "SomeSender1") {segue, sender in
            if segue.sourceViewController !== self {
                self.result = "Error"
                return
            }
            self.result = "Handler for first segue"
            self.sender = sender
        }
    }
    
    func secondTest() {
        self.performSegueWithIdentifier("TestSegueID1", sender: "SomeSender2") {segue, sender in
            if segue.sourceViewController !== self {
                self.result = "Error"
                return
            }
            self.result = "Handler for second segue"
            self.sender = sender
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let controller = segue.sourceViewController as? TestedViewController {
            controller.result = "prepareForSegue"
            controller.sender = sender
            if let controller =  segue.destinationViewController as? SecondViewController {
                controller.result = true
            }
        }
    }
}

class SecondViewController: UIViewController {
    
    var result: Bool?
    var desc: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}