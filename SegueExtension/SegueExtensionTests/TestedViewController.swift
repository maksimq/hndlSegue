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
        self.performSegueWithIdentifier("FirstSegueID1", sender: sender)
    }
    
    func firstTest() {
        self.performSegueWithIdentifier("FirstSegueID1", sender: "SomeSender1") {segue, sender in
            if segue.sourceViewController !== self {
                self.result = "Error"
                return
            }
            self.result = "Handler for first segue"
            self.sender = sender
        }
    }
    
    func secondTest() {
        self.performSegueWithIdentifier("FirstSegueID2", sender: "SomeSender2") {segue, sender in
            if segue.sourceViewController !== self {
                self.result = "Error"
                return
            }
            self.result = "Handler for second segue"
            self.sender = sender
        }
    }
    
    func thirdTest() {
        self.performSegueWithIdentifier("FirstSegueID1", sender: "SomeSenderSecond", withHandler: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let controller = segue.sourceViewController as? TestedViewController {
            controller.result = "prepareForSegue"
            controller.sender = sender
        }
    }
}

class SecondViewController: UIViewController {
    
    var result: String?
    var sender: AnyObject?

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func firstTest() {
        self.performSegueWithIdentifier("SecondSegueID", sender: "SomeSender1") {segue, sender in
            if segue.sourceViewController !== self {
                self.result = "Error"
                return
            }
            self.result = "Handler for first segue"
            self.sender = sender
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        print("That")
    }
}