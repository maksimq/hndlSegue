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

    // true если выполняется вызов переопределенного метода prepareForSegue
    var isOverrideMethodInvoke: Bool = false

    // выполнение perform без блока
    override func makePureSegue(segueID: String, fromSender sender: String) {
        isOverrideMethodInvoke = false
        super.makePureSegue(segueID, fromSender: sender)
        XCTAssertTrue(isOverrideMethodInvoke)
    }
    
    // выполнение perform с блоком
    override func makeSeveralSeguesWithDiffHandlers(segueID: String, fromSender sender: String) {
        isOverrideMethodInvoke = false
        super.makeSeveralSeguesWithDiffHandlers(segueID, fromSender: sender)
        XCTAssertTrue(isOverrideMethodInvoke)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        isOriginMethodInvoked = true
        isOverrideMethodInvoke = true
        originMethodInvokeCount += 1
    }
}
