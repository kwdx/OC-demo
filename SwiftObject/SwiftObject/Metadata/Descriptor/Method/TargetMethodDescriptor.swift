//
//  TargetMethodDescriptor.swift
//  SwiftObject
//
//  Created by warden on 2020/11/25.
//

import Foundation

/// An opaque descriptor describing a class or protocol method. References to
/// these descriptors appear in the method override table of a class context
/// descriptor, or a resilient witness table pattern, respectively.
///
/// Clients should not assume anything about the contents of this descriptor
/// other than it having 4 byte alignment.
struct TargetMethodDescriptor {
    let Flags: MethodDescriptorFlags    // Flags describing the method.
    let Impl: RelativeDirectPointer     // The method implementation.
}

extension UnsafePointer where Pointee == TargetMethodDescriptor {
    
    func getRealImpl() -> UnsafeRawPointer {
        UnsafeRawPointer(self).advanced(by: 4).applyDirect(relativeOffset: pointee.Impl)
    }
}
