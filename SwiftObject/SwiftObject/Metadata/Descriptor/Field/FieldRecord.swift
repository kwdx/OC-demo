//
//  FieldRecord.swift
//  SwiftObject
//
//  Created by warden on 2020/11/26.
//

import Foundation

struct FieldRecord {
    let Flags: FieldRecordFlags
    let MangledTypeName: RelativeDirectPointer
    let FieldName: RelativeDirectPointer
}

extension UnsafePointer where Pointee == FieldRecord {
    
    func getMangledTypeName() -> Any.Type? {
        let rawPointer = raw.advanced(by: MemoryLayout<FieldRecordFlags>.size)
                            .applyDirect(relativeOffset: pointee.MangledTypeName)
        let pointer = rawPointer.bindMemory(to: UInt8.self, capacity: MemoryLayout<UInt8>.size)
        return _getTypeByMangledNameInContext(pointer, 4, genericContext: nil, genericArguments: nil)
    }
    
    func getFieldName() -> String {
        let rawPointer = raw.advanced(by: MemoryLayout<FieldRecordFlags>.size + MemoryLayout<RelativeDirectPointer>.size)
                        .applyDirect(relativeOffset: pointee.FieldName)
        let pointer = rawPointer.bindMemory(to: UInt8.self, capacity: MemoryLayout<UInt8>.size)
        return String(cString: pointer)
    }
    
}
