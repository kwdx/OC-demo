//
//  main.swift
//  SwiftObject
//
//  Created by warden on 2020/12/2.
//

import Foundation


// MARK: - 浅谈SwiftObject

func test() {
    let p = Person(name: "SwiftObject")
    //let p = Person()
    p.eat()
}

test()

let p = Person(name: "SwiftObject")
//let p = Person()
//p.eat()

let pPointer = Unmanaged.passUnretained(p).toOpaque()
let pStruct = pPointer.bindMemory(to: PersonStruct.self, capacity: MemoryLayout<PersonStruct>.size)

// 类对象指针
let pClsPointer = pStruct.pointee.Kind
print("Person类地址：", pClsPointer)

//func swiftObject() {
//    var pCls: AnyClass? = object_getClass(p)
//    while pCls != nil {
//        print(String(cString: object_getClassName(pCls)))
//        pCls = pCls?.superclass()
//    }
//
//    assert(pStruct.pointee.name == p.name)
//    pStruct.pointee.name = "modify"
//    assert(pStruct.pointee.name == p.name)
//}

// MARK: - 浅谈类对象

func swiftClass() {
    
    print("Person 地址: \(pClsPointer)")
    print("Person 类型: \(pClsPointer.getKind())")

    if let targetClassPointer = pClsPointer.getClassObject() {
        assert(targetClassPointer.pointee.InstanceSize == MemoryLayout<PersonStruct>.size)
        
        print("是否是纯OC类：\(targetClassPointer.isPureObjC)")
        print("是否是元数据类型：\(targetClassPointer.isTypeMetadata)")
    }
}

// MARK: - 虚函数表

func propertys() {
    guard pClsPointer.isClassObject else {
        return
    }
    let descPointer = pClsPointer.withMemoryRebound(to: TargetClassMetadata.self,
                                                    capacity: MemoryLayout<TargetClassMetadata>.size,
                                                    { $0 })
        .pointee.Description
    
    print("Person类描述地址：", descPointer)
    
    if descPointer.pointee.NumFields > 0 {
        // 有Field
        let fieldP = descPointer.getFieldDescriptor()
        
        // 遍历所有的 Field
        if let mangledType = fieldP.getMangledTypeName() {
            print("Field 所属类型: ", mangledType)
        }
        var recordP = fieldP.getFields()
        for _ in 0..<fieldP.pointee.NumFields {
            print("变量名：", recordP.getFieldName())
            print("是否可变：", recordP.pointee.Flags.isVar)
            if let mangledType = recordP.getMangledTypeName() {
                print("字段类型: ", mangledType)
            }
            recordP = recordP.next
        }
    }

}

func methods() {
    guard pClsPointer.isClassObject else {
        return
    }
    let descPointer = pClsPointer.withMemoryRebound(to: TargetClassMetadata.self,
                                                    capacity: MemoryLayout<TargetClassMetadata>.size,
                                                    { $0 })
        .pointee.Description
    
    print("Person类地址：", pClsPointer)
    
    if descPointer.hasVTable() {
        print("Person类有虚函数表")
        if let vTablePointer = descPointer.getVTableDescriptor(), var methodPointer = descPointer.getMethodDescriptors() {
            print("虚函数表偏移：", vTablePointer.pointee.VTableOffset)
            print("虚函数表大小：", vTablePointer.pointee.VTableSize)
            
            for _ in 0..<vTablePointer.pointee.VTableSize {
                print("函数类型：", methodPointer.pointee.Flags.getKind())
                print("函数实现地址：", methodPointer.getRealImpl())
                methodPointer = methodPointer.next
            }
        }
    }
}

//print("------------ 浅谈SwiftObject")
//swiftObject()
//print("------------ End")

//print("------------ 浅谈类对象")
//swiftClass()
//print("------------ End")

//print("------------ 属性列表")
//propertys()
//print("------------ End")

print("------------ 函数列表")
methods()
print("------------ End")


//print("------------ 函数列表")
//methods()
//print("------------ End")
