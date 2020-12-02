//
//  Person.swift
//  SwiftObject
//
//  Created by warden on 2020/11/19.
//

import Foundation

class Person {
    var name: String = ""
    var age: Int = 0

    init(name: String) {
        self.name = name
    }

    func eat() {
        print("吃")
    }
}

extension Person {
    func  asdasd() {
        
    }
}

class AA: Person {
    func run() {}
}

//extension Person {
//    func run() {
//        print("跑")
//    }
//}
//
struct PersonStruct {
    let Kind: UnsafePointer<TargetHeapMetadata>
    let refCounts: uintptr_t
    var name: String
    var age: Int
//    var year: Int = 0
}
