//
//  main.swift
//  ClassStruct
//
//  Created by warden on 2020/5/6.
//  Copyright © 2020 warden. All rights reserved.
//

import Foundation

import SwiftClass

class Person {
    var name: String
    var age: Int
    
    init(name: String, age: Int) {
        self.name = name
        self.age = age
    }
    
    func printData() {
        print("name=\(name), age=\(age)")
    }
}

// Person实例对象对应的结构体
struct PersonStruct {
    // 指向类对象的指针
    let metaData: UnsafeRawPointer
    let refCounts: __uint64_t
    var name: String
    var age: Int
}

//print(class_getSuperclass(Person.self))

//var person = Person(name: "swift", age: 6)
//
//let pPointer = Unmanaged.passUnretained(person).toOpaque()
//var pStructPointer = pPointer.bindMemory(to: PersonStruct.self, capacity: personSize)
//print(pStructPointer)
//
//pStructPointer.pointee.name = "struct"
//pStructPointer.pointee.age = 1
//person.printData()
//
//print(String(format: "0x%02lx", pPointer.load(as: __uint64_t.self)))
//
//let personMetaData = pStructPointer.pointee.metaData.bindMemory(to: TargetClassMetadata.self, capacity: MemoryLayout<TargetClassMetadata>.stride).pointee
//print(personMetaData.InstanceSize)
//let personSize = malloc_size(pPointer)
//print("person对象占用的内存大小:", personSize)
////String(format: "0x%02lx", pStructPointer.pointee.metaData)
//
///// 类对象地址指针
//let clsAddress = pStructPointer.pointee.metaData
///// Person元类对象地址
//let metaAddress = String(format: "0x%02lx", personMetaData.Kind)
//print("Person类对象地址: \(clsAddress)")
//print("Person元类对象地址: \(metaAddress)")

let UnownedRefCountMask: UInt64 = 0x7FFFFFFF;
let StrongExtraRefCountMask: UInt64 = 0x3FFFFFFF;

let p1 = Person(name: "swift", age: 6)
let p2 = p1
let p3 = p1
unowned let p4 = p1
unowned let p5 = p1

weak var p6 = p1

print("---------------------------")


objc_getClass(<#T##name: UnsafePointer<Int8>##UnsafePointer<Int8>#>)
objc_getMetaClass()
