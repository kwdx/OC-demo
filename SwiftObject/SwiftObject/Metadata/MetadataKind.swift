//
//  MetadataKind.swift
//  SwiftObject
//
//  Created by warden on 2020/11/19.
//

import Foundation

/// Non-type metadata kinds have this bit set.
let MetadataKindIsNonType: __uint32_t = 0x400
/// Non-heap metadata kinds have this bit set.
let MetadataKindIsNonHeap: __uint32_t = 0x200
// The above two flags are negative because the "class" kind has to be zero,
// and class metadata is both type and heap metadata.

/// Runtime-private metadata has this bit set. The compiler must not statically
/// generate metadata objects with these kinds, and external tools should not
/// rely on the stability of these values or the precise binary layout of
/// their associated data structures.
let MetadataKindIsRuntimePrivate: __uint32_t = 0x100

enum MetadataKind: __uint32_t {
    /// A class type.
    case Class = 0

    /// A struct type.
    case Struct = 0x200

    /// An enum type.
    /// If we add reference enums, that needs to go here.
    case Enum = 0x201
    
    /// An optional type.
    case Optional = 0x202
    
    /// A foreign class, such as a Core Foundation class.
    case ForeignClass = 0x203

    /// A type whose value is not exposed in the metadata system.
    case Opaque = 0x300
    
    /// A tuple.
    case Tuple = 0x301

    /// A monomorphic function.
    case Function = 0x302
    
    /// An existential type.
    case Existential = 0x303

    /// A metatype.
    case Metatype = 0x304
    
    /// An ObjC class wrapper.
    case ObjCClassWrapper = 0x305

    /// An existential metatype.
    case ExistentialMetatype = 0x306

    /// A heap-allocated local variable using statically-generated metadata.
    case HeapLocalVariable = 0x400

    /// A heap-allocated local variable using runtime-instantiated metadata.
    case HeapGenericLocalVariable = 0x500

    /// A native error object.
    case ErrorObject = 0x501
    
    // getEnumeratedMetadataKind assumes that all the enumerated values here
    // will be <= LastEnumeratedMetadataKind.
    case LastEnumerated = 0x7FF
}

extension MetadataKind {
    
    static var LastEnumeratedMetadataKind: MetadataKind {
        .LastEnumerated
    }
    
    var isHeapMetadataKind: Bool {
        return (rawValue & MetadataKindIsNonHeap) == 0
    }
    
    var isTypeMetadataKind: Bool {
        return (rawValue & MetadataKindIsNonType) == 0
    }
    
    var isRuntimePrivateMetadataKind: Bool {
        return (rawValue & MetadataKindIsRuntimePrivate) != 0
    }
    
}
