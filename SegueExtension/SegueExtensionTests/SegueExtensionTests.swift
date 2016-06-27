//
//  SegueExtensionTests.swift
//  SegueExtensionTests
//
//  Created by matyushenko on 17.06.16.
//  Copyright © 2016 matyushenko. All rights reserved.
//

import XCTest
@testable import SegueExtension

/// План тестирования, что нужно затестить, почему и зачем.
/// 1) Проверить вызов оригинального метода prepareForSegue для ViewController и то, что он вызывается только один раз.
/// 2) Проверить вызов обработчика для segue, который должен расширить поведение для данного segueId. При этом должен выполниться вызов оригинального prepareForSegue затем обработчика. Вызовы должны быть разовыми.
/// 3) Проверить работу для нескольких segueId. Убедится в том, что вызываются соотвествующие обработчики.
/// 4) Убедится в том, что параметры segue и sender переданы в обработчик правильно.
/// 5) Для двух viewController'ов проверить: вызов performForSegue одного не затрагивает метод другого контроллера.
/// 6) Проверить освобождение памяти (Создать строгую и слабую ссылку, ей присвоить nil, соответственно после выхода из блока слабая ссылка должна быть nil)
/// 7) Для иерархии проверить то, что использование расширения в супер калссе не нарушает работу в классе наследнике.

class SegueExtensionTests: XCTestCase {
    
    var window: UIWindow?
    var storyboard: UIStoryboard?
    
    var firstViewController: TestedViewController?
    var secondViewController: TestedSubViewController?
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        self.storyboard = UIStoryboard.init(name: "MainStoryboard", bundle: NSBundle(forClass: self.dynamicType))
        
        firstViewController = storyboard?.instantiateViewControllerWithIdentifier("testViewID") as? TestedViewController
        secondViewController = storyboard?.instantiateViewControllerWithIdentifier("SecondViewID") as? TestedSubViewController
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

//  Проверить вызов оригинального метода prepareForSegue для ViewController.
    func testIvokedOriginMethod() {
        firstViewController!.makePureSegue("SegueID1", fromSender: "Self")
    }
   
//  Проверить вызов обработчика для segue, который должен расширить поведение для данного segueId. При этом должен выполниться вызов оригинального prepareForSegue затем обработчика.
    func testIvokeWithHandler() {
        let sender = "FirstViewController"
        firstViewController?.makeOnceSegueWithHandler("SegueID1", fromSender: sender)
    }
    
//  Проверить работу для нескольких segueId. Убедится в том, что вызываются соотвествующие обработчики.
    func testSeveralSeguesForOneController() {
        self.measureBlock{
            self.firstViewController?.makeSeveralSeguesWithDiffHandlers("SegueID1", fromSender: "FirstController")
        }
    }
    
//  Убедится в том, что параметры segue и sender переданы в обработчик правильно.
    func testArgumentsInBlock() {
        firstViewController?.makeSegueToValidArguments("SegueID1", withSender: "FirstController")
    }
    
//  Для двух viewController'ов проверить: вызов performForSegue одного не затрагивает метод другого контроллера.
//  Для иерархии проверить то, что использование расширения в супер калссе не нарушает работу в классе наследнике.
    func testSubClassMethods() {
        
        firstViewController?.makePureSegue("SegueID", fromSender: "FirstController")
        secondViewController?.makePureSegue("SegueID", fromSender: "SecondController")
        
        firstViewController?.makeSeveralSeguesWithDiffHandlers("SegueID", fromSender: "FirstController")
        secondViewController?.makeSeveralSeguesWithDiffHandlers("SegueID", fromSender: "SecondController")
    }
    
//  проверить освобождение памяти (Создать строгую и слабую ссылку, ей присвоить nil, соответственно после выхода из блока слабая ссылка должна быть nil)
    func testMemoryReleased() {
        firstViewController?.makeSegueToCheckRefConter("SegueID1", withSender: "FirstController")
    }
}
