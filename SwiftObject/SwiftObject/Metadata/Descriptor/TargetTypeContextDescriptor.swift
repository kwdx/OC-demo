//
//  TargetTypeContextDescriptor.swift
//  SwiftObject
//
//  Created by warden on 2020/11/19.
//

import Foundation

protocol TargetTypeContextDescriptor_P: TargetContextDescriptor_P {
    // The name of the type.
    var Name: __int32_t { get }
    // A pointer to the metadata access function for this type.
    var AccessFunctionPtr: __int32_t { get }    /* MetadataResponse(...) */
    // A pointer to the field descriptor for the type, if any.
    var Fields: RelativeDirectPointer { get }   /* reflection::FieldDescriptor */
}

struct TargetTypeContextDescriptor: TargetTypeContextDescriptor_P {
    
    // MARK: - TargetContextDescriptor
    
    let Flags: ContextDescriptorFlags
    let Parent: RelativeIndirectablePointer
    
    // MARK: - Self
    
    let Name: __int32_t
    let AccessFunctionPtr: __int32_t
    let Fields: RelativeDirectPointer
}

extension UnsafePointer where Pointee: TargetTypeContextDescriptor_P {
        
    func getTypeContextDescriptorFlags() -> TypeContextDescriptorFlags {
        return .init(Value: pointee.Flags.getKindSpecificFlags())
    }
}


