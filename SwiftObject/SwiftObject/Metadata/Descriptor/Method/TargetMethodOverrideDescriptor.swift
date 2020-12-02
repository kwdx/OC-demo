//
//  TargetMethodOverrideDescriptor.swift
//  SwiftObject
//
//  Created by warden on 2020/11/25.
//

import Foundation

/// An entry in the method override table, referencing a method from one of our
/// ancestor classes, together with an implementation.
struct TargetMethodOverrideDescriptor {
    let Class: RelativeIndirectablePointer      // The class containing the base method.
    let Method: RelativeIndirectablePointer     // The base method. TargetMethodDescriptor
    let Impl: RelativeDirectPointer             // The implementation of the override.
}

extension UnsafePointer where Pointee == TargetMethodOverrideDescriptor {
    
    func getBaseMethod() -> UnsafePointer<TargetMethodDescriptor>? {
        if pointee.Class == 0 {
            return nil
        }
        return UnsafeRawPointer(self)
            .advanced(by: MemoryLayout<RelativeIndirectablePointer>.size)
            .applyIndirect(relativeOffset: pointee.Method)?
            .bindMemory(to: TargetMethodDescriptor.self,
                        capacity: MemoryLayout<TargetMethodDescriptor>.size)
    }
    
    func getRealImpl() -> UnsafeRawPointer {
        UnsafeRawPointer(self)
            .advanced(by: MemoryLayout<RelativeIndirectablePointer>.size * 2)
            .applyDirect(relativeOffset: pointee.Impl)
    }
    
}
