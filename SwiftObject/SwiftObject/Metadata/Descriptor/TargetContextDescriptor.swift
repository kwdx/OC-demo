//
//  TargetContextDescriptor.swift
//  SwiftObject
//
//  Created by warden on 2020/11/19.
//

import Foundation

protocol TargetContextDescriptor_P {
    // Flags describing the context, including its kind and format version.
    var Flags: ContextDescriptorFlags { get }
    // The parent context, or null if this is a top-level context.
    var Parent: RelativeIndirectablePointer { get }
}

/// Base class for all context descriptors. Struct
struct TargetContextDescriptor: TargetContextDescriptor_P {
    let Flags: ContextDescriptorFlags
    let Parent: RelativeIndirectablePointer
}

extension UnsafePointer where Pointee: TargetContextDescriptor_P {
    
    func getParent() -> UnsafePointer<TargetContextDescriptor>? {
        raw
            .advanced(by: MemoryLayout<ContextDescriptorFlags>.size)
            .applyIndirect(relativeOffset: pointee.Parent)?
            .bindMemory(to: TargetContextDescriptor.self, capacity: MemoryLayout<TargetContextDescriptor>.size)
    }
}
