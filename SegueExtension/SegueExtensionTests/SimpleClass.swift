//
//  SimpleClass.swift
//  SegueExtension
//
//  Created by matyushenko on 27.06.16.
//  Copyright © 2016 matyushenko. All rights reserved.
//

import Foundation

class SimpleClass {
    var someProperty: String
    init() {
        someProperty = "Some Property"
    }
    
    deinit {
        print("Deinit")
    }
}