//
//  TargetClassMetadata.swift
//  SwiftObject
//
//  Created by warden on 2020/11/19.
//

import Foundation

protocol TargetClassMetadata_P: TargetAnyClassMetadata_P {
    // Swift-specific class flags
    var Flags: __uint32_t { get }
    // The address point of instances of this type.
    var InstanceAddressPoint: __uint32_t { get }
    // The required size of instances of this type.
    var InstanceSize: __uint32_t { get }
    // The alignment mask of the address point of instances of this type.
    var InstanceAlignMask: __uint16_t { get }
    // Reserved for runtime use.
    var Reserved: __uint16_t { get }
    // The total size of the class object, including prefix and suffix
    var ClassSize: __uint32_t { get }
    // The offset of the address point within the class object.
    var ClassAddressPoint: __uint32_t { get }
    // Description
    var Description: UnsafePointer<TargetClassDescriptor> { get }
    // A function for destroying instance variables
//    let IVarDestroyer: UnsafePointer<ClassIVarDestroyer>
    var IVarDestroyer: UnsafeRawPointer { get }
}

struct TargetClassMetadata: TargetClassMetadata_P {
    let Kind: StoredPointer

    let Superclass: UnsafePointer<TargetClassMetadata>
    let cacheData_0: UnsafeRawPointer
    let cacheData_1: UnsafeRawPointer
    let Data: size_t

    // Swift-specific class flags
    let Flags: __uint32_t
    // The address point of instances of this type.
    let InstanceAddressPoint: __uint32_t
    // The required size of instances of this type.
    let InstanceSize: __uint32_t
    // The alignment mask of the address point of instances of this type.
    let InstanceAlignMask: __uint16_t
    // Reserved for runtime use.
    let Reserved: __uint16_t
    // The total size of the class object, including prefix and suffix
    let ClassSize: __uint32_t
    // The offset of the address point within the class object.
    let ClassAddressPoint: __uint32_t
    // Description
    let Description: UnsafePointer<TargetClassDescriptor>
    // A function for destroying instance variables
//    let IVarDestroyer: UnsafePointer<ClassIVarDestroyer>
    let IVarDestroyer: UnsafeRawPointer
}
