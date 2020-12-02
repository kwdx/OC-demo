//
//  TargetValueWitnessFlags.swift
//  SwiftObject
//
//  Created by warden on 2020/11/23.
//

import Foundation

struct TargetValueWitnessFlags {

    // The polarity of these bits is chosen so that, when doing struct layout, the
    // flags of the field types can be mostly bitwise-or'ed together to derive the
    // flags for the struct. (The "non-inline" and "has-extra-inhabitants" bits
    // still require additional fixup.)
    struct MASK {
        static let AlignmentMask: __uint32_t        = 0x000000FF
        // unused             0x0000FF00,
        static let IsNonPOD: __uint32_t             = 0x00010000
        static let IsNonInline: __uint32_t          = 0x00020000
        // unused             0x00040000,
        static let HasSpareBits: __uint32_t         = 0x00080000
        static let IsNonBitwiseTakable: __uint32_t  = 0x00100000
        static let HasEnumWitnesses: __uint32_t     = 0x00200000
        static let Incomplete: __uint32_t           = 0x00400000
        // unused             0xFF800000,
    }

    static let MaxNumExtraInhabitants: __uint32_t = 0x7FFFFFFF

    let Data: __uint32_t
    
    /// The required alignment of the first byte of an object of this
    /// type, expressed as a mask of the low bits that must not be set
    /// in the pointer.
    ///
    /// This representation can be easily converted to the 'alignof'
    /// result by merely adding 1, but it is more directly useful for
    /// performing dynamic structure layouts, and it grants an
    /// additional bit of precision in a compact field without needing
    /// to switch to an exponent representation.
    ///
    /// For example, if the type needs to be 8-byte aligned, the
    /// appropriate alignment mask should be 0x7.
    func getAlignmentMask() -> size_t {
        Darwin.size_t(Data & MASK.AlignmentMask)
    }
    
    func withAlignmentMask(_ alignMask: size_t) -> TargetValueWitnessFlags {
        .init(Data: (Data & ~MASK.AlignmentMask) | UInt32(alignMask))
    }

    func getAlignment() -> size_t {
        getAlignmentMask() + 1
    }
    
    func withAlignment(_ alignment: size_t) -> TargetValueWitnessFlags {
        withAlignmentMask(alignment - 1)
    }
    
    /// True if the type requires out-of-line allocation of its storage.
    /// This can be the case because the value requires more storage or if it is
    /// not bitwise takable.
    var isInlineStorage: Bool { (Data & MASK.IsNonInline) == 0 }
    
    func withInlineStorage(_ isInline: Bool) -> TargetValueWitnessFlags {
        .init(Data: (Data & ~MASK.IsNonInline) | (isInline ? 0 : MASK.IsNonInline))
    }

    /// True if values of this type can be copied with memcpy and
    /// destroyed with a no-op.
    var isPOD: Bool { (Data * MASK.IsNonPOD) != 1 }
    
    func withPOD(_ isPOD: Bool) -> TargetValueWitnessFlags {
        .init(Data: (Data & ~MASK.IsNonPOD) | (isPOD ? 0 : MASK.IsNonPOD))
    }
    
  /// True if values of this type can be taken with memcpy. Unlike C++ 'move',
  /// 'take' is a destructive operation that invalidates the source object, so
  /// most types can be taken with a simple bitwise copy. Only types with side
  /// table references, like @weak references, or types with opaque value
  /// semantics, like imported C++ types, are not bitwise-takable.
    var isBitwiseTakable: Bool { (Data & MASK.IsNonBitwiseTakable) == 0 }
    
    func withBitwiseTakable(_ isBT: Bool) -> TargetValueWitnessFlags {
        .init(Data: (Data & ~MASK.IsNonBitwiseTakable) | (isBT ? 0 : MASK.IsNonBitwiseTakable))
    }
    
    /// True if this type's binary representation is that of an enum, and the
    /// enum value witness table entries are available in this type's value
    /// witness table.
    var hasEnumWitnesses: Bool { (Data & MASK.HasEnumWitnesses) != 0 }
    
    func withEnumWitnesses(_ hasEnumWitnesses: Bool) -> TargetValueWitnessFlags {
        .init(Data: (Data & ~MASK.HasEnumWitnesses) | (hasEnumWitnesses ? MASK.HasEnumWitnesses : 0))
    }

    /// True if the type with this value-witness table is incomplete,
    /// meaning that its external layout (size, etc.) is meaningless
    /// pending completion of the metadata layout.
    var isIncomplete: Bool { return (Data & MASK.Incomplete) != 0 }
    
    func withIncomplete(_ isIncomplete: Bool) -> TargetValueWitnessFlags {
        .init(Data: (Data & ~MASK.Incomplete) | (isIncomplete ? MASK.Incomplete : 0))
    }
    
    func getOpaqueValue() -> __uint32_t {
        Data
    }
}
typealias ValueWitnessFlags = TargetValueWitnessFlags
