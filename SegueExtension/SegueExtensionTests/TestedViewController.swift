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

protocol UIViewControllerTestDelegate {
    var isOriginMethodInvoked: Bool {get set}
    var isHandlerInvoked: Bool {get set}
    var sender: AnyObject? {get set}
}

class TestedViewController: UIViewController, UIViewControllerTestDelegate {
    
    var sender: AnyObject?
    var isOriginMethodInvoked = false
    var originMethodInvokeCount: Int = 0
    
    var isHandlerInvoked = false
    var handlerInvokeCount: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("View did Load")
    }
    
    // метод инициирует переход без обработчика
    func makePureSegue(segueID: String, fromSender sender: String) {
        // сброс проверяемых аргументов.
        originMethodInvokeCount = 0
        isOriginMethodInvoked = false
        
        self.performSegueWithIdentifier(segueID, sender: sender)
        
        isOriginOnceInvoke()
    }
    
    // метод инициирует переход с передачей дополтительного обработчика
    func makeSegueWithHandler(segueID: String, fromSender sender: String) {
        originMethodInvokeCount = 0
        isOriginMethodInvoked = false
        handlerInvokeCount = 0
        isHandlerInvoked = false
        
        self.performSegueWithIdentifier(segueID, sender: sender) {segue, sender in
            self.isHandlerInvoked = true
            self.handlerInvokeCount += 1
        }
        
        isHandlerOnceInvoke()
        isOriginOnceInvoke()
    }
    
    // реализация дефолтного обработчкика переходов
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let controller = segue.sourceViewController as? TestedViewController {
            isOriginMethodInvoked = true
            controller.sender = sender
            originMethodInvokeCount += 1
        }
    }
    
    private func isOriginOnceInvoke(){
        // проверка необходимых условий (вызов метода + колическво вызовов = 1)
        XCTAssertTrue(isOriginMethodInvoked)
        XCTAssertEqual(originMethodInvokeCount, 1)
    }
    
    private func isHandlerOnceInvoke(){
        // проверка необходимых условий (вызов метода + колическво вызовов = 1)
        XCTAssertTrue(isHandlerInvoked)
        XCTAssertEqual(handlerInvokeCount, 1)
        
    }
}