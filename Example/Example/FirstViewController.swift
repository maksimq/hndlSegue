//
//  FirstViewController.swift
//  Example
//
//  Created by matyushenko on 17.06.16.
//  Copyright © 2016 matyushenko. All rights reserved.
//

import UIKit
import SegueExtension

class FirstViewController: UIViewController {

    var result: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        performSegue(withIdentifier: "TestSegueID", sender: "SomeSender"){_, _ in
            print("It's work")
            self.result = "It's work"
        }
        print(self.result ?? "-")
        performSegue(withIdentifier: "TestSegueID", sender: "SomeSender"){_, _ in
            print("It's work second time")
        }
        print(self.result ?? "-")
        
        performSegue(withIdentifier: "TestSegueID", sender: "SomeSender")
    }
    
    // default action for segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let isOriginMethodInvoked = true
        let originMethodInvokeCount = 1
    }
}
