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
    
    var result: Bool?
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
    
    func testedMethod() {
        self.performSegueWithIdentifier("TestSegueID1", sender: nil) {[weak self] _, segue, sender in
            if segue.sourceViewController !== self {
                self?.result = false
                return
            }
            self?.result = true
            self?.sender = sender
            if let controller =  segue.destinationViewController as? SecondViewController {
                controller.result = true
            }
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if self === segue.sourceViewController {
            let controller = segue.sourceViewController as? TestedViewController
            controller?.result = true
            controller?.sender = sender
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