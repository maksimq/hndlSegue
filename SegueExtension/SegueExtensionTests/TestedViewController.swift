
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

    private let ONCE = 1
    
    var isOriginMethodInvoked = false
    var originMethodInvokeCount: Int = 0
    
    var isHandlerInvoked = false
    var handlerInvokeCount: Int = 0
    
    var sender: AnyObject?
    var strongRef: SimpleClass?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("View did Load")
    }
    
    // метод инициирует переход без обработчика
    func makePureSegue(segueID: String, fromSender sender: String) {
        // сброс проверяемых аргументов.
        resetAll()
        
        self.performSegueWithIdentifier(segueID, sender: sender)
        
        isOriginInvoked(ONCE)
    }
    
    // метод инициирует переход с передачей в perform обработчика
    func makeOnceSegueWithHandler(segueID: String, fromSender sender: String) {
        resetAll()
        
        self.performSegueWithIdentifier(segueID, sender: sender) {segue, sender in
            self.isHandlerInvoked = true
            self.handlerInvokeCount += 1
        }
        
        isHandlerInvoked(ONCE)
        isOriginInvoked(ONCE)
    }
    
    // метод инициирует три перехода: один обычный и два с передачей дополтительного обработчика
    func makeSeveralSeguesWithDiffHandlers(segueID: String, fromSender sender: String) {
        resetAll()
        
        self.performSegueWithIdentifier(segueID, sender: sender)
        
        self.performSegueWithIdentifier(segueID, sender: sender) { segue, sender in
            self.isHandlerInvoked = true
            self.handlerInvokeCount += 1
            self.sender = "FirstHandler" as AnyObject
        }
        isHandlerInvokeOnceFromSender("FirstHandler")
        handlerInvokeCount = 0
        isHandlerInvoked = false
        
        self.performSegueWithIdentifier(segueID, sender: sender) { segue, sender in
            self.isHandlerInvoked = true
            self.handlerInvokeCount += 1
            self.sender = "SecondSender" as AnyObject
        }
        isHandlerInvokeOnceFromSender("SecondSender")

        isOriginInvoked(3)
    }
    
    func makeSegueToValidArguments(segueID: String, withSender sender: AnyObject) {
        
        resetAll()
        self.sender = sender
        
        self.performSegueWithIdentifier(segueID, sender: sender){ segue, sender in
            self.isHandlerInvoked = true
            self.handlerInvokeCount += 1
            
            XCTAssertEqual(self, segue.sourceViewController)
            XCTAssertEqual(sender as? String, self.sender as? String)
        }
        
        isHandlerInvoked(ONCE)
        isOriginInvoked(ONCE)
    }
    
    func makeSegueToCheckRefConter(segueID: String, withSender sender: AnyObject) {
        resetAll()
        self.strongRef = SimpleClass()
        
        self.performSegueWithIdentifier(segueID, sender: sender){ segue, sender in
            let someProp = self.strongRef
            XCTAssertNotNil(someProp)
        }
        
        weak var weakRef = strongRef
        strongRef = nil
        XCTAssertNil(weakRef)
    }
    
    // реализация дефолтного обработчкика переходов
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        isOriginMethodInvoked = true
        originMethodInvokeCount += 1
    
        // проверка на то, что текущий контроллер является источником segue
        XCTAssertEqual(self, segue.sourceViewController)
    }
    
    private func isOriginOnceInvoke(){
        // проверка необходимых условий (вызов метода + колическво вызовов = 1)
        XCTAssertTrue(isOriginMethodInvoked)
        XCTAssertEqual(originMethodInvokeCount, 1)
    }
    
    private func isHandlerInvokeOnceFromSender(sender: AnyObject?){
        isHandlerInvoked(ONCE)
        XCTAssertEqual(self.sender as? String, sender as? String)
        self.isHandlerInvoked = false
    }
    
    private func isHandlerInvoked(count: Int){
        XCTAssertTrue(isHandlerInvoked)
        XCTAssertEqual(handlerInvokeCount, count)
        
    }
    
    private func resetAll(){
        isOriginMethodInvoked = false
        originMethodInvokeCount = 0
        isHandlerInvoked = false
        handlerInvokeCount = 0
    }
    
    private func isOriginInvoked(count: Int) {
        // проверка необходимых условий (вызов метода + колическво вызовов = count)
        XCTAssertTrue(isOriginMethodInvoked)
        XCTAssertEqual(originMethodInvokeCount, count)
    }
}