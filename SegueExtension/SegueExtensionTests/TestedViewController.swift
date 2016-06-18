//
//  TestedClass.swift
//  SegueExtension
//
//  Created by matyushenko on 17.06.16.
//  Copyright © 2016 matyushenko. All rights reserved.
//

import Foundation
import UIKit

class TestedViewController: UIViewController {
    var result: String?
    weak var segue: UIStoryboardSegue?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("View did Load")
    }
    
    func testedMethod( handler: (@convention(block) (segue: UIStoryboardSegue, sender:AnyObject?) -> Void)) {
        print(self.valueForKey("storyboardSegueTemplates"))
        self.performSegueWithIdentifierSE("TestSegueID", sender: "SomeSender", withSegueHandler:  handler)
    }
}

class SecondViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}