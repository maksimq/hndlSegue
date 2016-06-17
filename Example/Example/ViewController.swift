//
//  ViewController.swift
//  Example
//
//  Created by matyushenko on 17.06.16.
//  Copyright © 2016 matyushenko. All rights reserved.
//

import UIKit
import SegueExtension

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        UIViewController.printHello()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
}

