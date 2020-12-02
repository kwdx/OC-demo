//
//  TargetVTableDescriptorHeader.swift
//  SwiftObject
//
//  Created by warden on 2020/11/25.
//

import Foundation

/// Header for a class vtable descriptor. This is a variable-sized
/// structure that describes how to find and parse a vtable
/// within the type metadata for a class.
struct TargetVTableDescriptorHeader {
    let VTableOffset: __uint32_t    // The offset of the vtable for this class in its metadata, if any in words.
    let VTableSize: __uint32_t      // The number of vtable entries.
}

extension UnsafePointer where Pointee == TargetVTableDescriptorHeader {
    
    func getVTableOffset(description: UnsafePointer<TargetClassDescriptor>) -> __uint32_t {
        if description.hasResilientSuperclass() {
            return __uint32_t(description.getMetadataBounds().ImmediateMembersOffset) / __uint32_t(MemoryLayout<UnsafeRawPointer>.size) + pointee.VTableOffset
        }
        return pointee.VTableOffset
    }

}
