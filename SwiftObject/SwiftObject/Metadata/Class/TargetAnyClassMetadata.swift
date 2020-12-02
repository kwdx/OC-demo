//
//  TargetAnyClassMetadata.swift
//  SwiftObject
//
//  Created by warden on 2020/11/19.
//

import Foundation

protocol TargetAnyClassMetadata_P: TargetHeapMetadata_P {
    var Superclass: UnsafePointer<TargetClassMetadata> { get }
    var cacheData_0: UnsafeRawPointer { get }
    var cacheData_1: UnsafeRawPointer { get }
    var Data: size_t { get }
}

struct TargetAnyClassMetadata: TargetAnyClassMetadata_P {
    let Kind: StoredPointer

    let Superclass: UnsafePointer<TargetClassMetadata>
    let cacheData_0: UnsafeRawPointer
    let cacheData_1: UnsafeRawPointer
    let Data: size_t
}

extension UnsafePointer where Pointee: TargetAnyClassMetadata_P {
    
    var offsetData: StoredPointer {
        return StoredPointer(
            MemoryLayout<StoredPointer>.size +
            MemoryLayout<UnsafePointer>.size +
            MemoryLayout<UnsafeRawPointer>.size +
            MemoryLayout<UnsafeRawPointer>.size
        )
    }
    
    /// Is this object a valid swift type metadata?  That is, can it be
    /// safely downcast to ClassMetadata?
    var isTypeMetadata: Bool {
        pointee.Data & size_t(SWIFT_CLASS_IS_SWIFT_MASK) != 0
    }

    /// A different perspective on the same bit
    var isPureObjC: Bool {
        return !isTypeMetadata
    }

}

