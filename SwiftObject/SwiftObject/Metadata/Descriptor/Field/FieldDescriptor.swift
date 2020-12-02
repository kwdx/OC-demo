//
//  FieldDescriptor.swift
//  SwiftObject
//
//  Created by warden on 2020/11/26.
//

import Foundation

struct FieldDescriptor {
    let MangledTypeName: RelativeDirectPointer
    let Superclass: RelativeDirectPointer
    let Kind: FieldDescriptorKind
    let FieldRecordSize: __uint16_t
    let NumFields: __uint32_t
    
    var isEnum: Bool { Kind == .aEnum || Kind == .aMultiPayloadEnum }
    var isClass: Bool { Kind == .aClass || Kind == .aObjCClass }
    var isProtocol: Bool { Kind == .aProtocol || Kind == .aClassProtocol || Kind == .aObjCProtocol }
    var isStruct: Bool { Kind == .aStruct }
}

extension UnsafePointer where Pointee == FieldDescriptor {
    
    func getFields() -> UnsafePointer<FieldRecord> { UnsafeRawPointer(advanced(by: 1)).bindMemory(to: FieldRecord.self, capacity: MemoryLayout<FieldRecord>.size) }
    
    func getMangledTypeName() -> Any.Type? {
        let rawPointer = raw.applyDirect(relativeOffset: pointee.MangledTypeName)
        let pointer = rawPointer.bindMemory(to: UInt8.self, capacity: MemoryLayout<UInt8>.size)
        return _getTypeByMangledNameInContext(pointer, 4, genericContext: nil, genericArguments: nil)
    }
}
