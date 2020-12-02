//
//  TargetValueWitnessTable.swift
//  SwiftObject
//
//  Created by warden on 2020/11/19.
//

import Foundation


typealias ValueWitnessTable = TargetValueWitnessTable

/// A value-witness table.  A value witness table is built around
/// the requirements of some specific type.  The information in
/// a value-witness table is intended to be sufficient to lay out
/// and manipulate values of an arbitrary type.
struct TargetValueWitnessTable {
  // For the meaning of all of these witnesses, consult the comments
  // on their associated typedefs, above.


};

extension TargetValueWitnessTable {
//    /// Are values of this type allocated inline?
//    bool isValueInline() const {
//      return flags.isInlineStorage();
//    }
//
//    /// Is this type POD?
//    bool isPOD() const {
//      return flags.isPOD();
//    }
//
//    /// Is this type bitwise-takable?
//    bool isBitwiseTakable() const {
//      return flags.isBitwiseTakable();
//    }
//
//    /// Return the size of this type.  Unlike in C, this has not been
//    /// padded up to the alignment; that value is maintained as
//    /// 'stride'.
//    StoredSize getSize() const {
//      return size;
//    }
//
//    /// Return the stride of this type.  This is the size rounded up to
//    /// be a multiple of the alignment.
//    StoredSize getStride() const {
//      return stride;
//    }
//
//    /// Return the alignment required by this type, in bytes.
//    StoredSize getAlignment() const {
//      return flags.getAlignment();
//    }
//
//    /// The alignment mask of this type.  An offset may be rounded up to
//    /// the required alignment by adding this mask and masking by its
//    /// bit-negation.
//    ///
//    /// For example, if the type needs to be 8-byte aligned, the value
//    /// of this witness is 0x7.
//    StoredSize getAlignmentMask() const {
//      return flags.getAlignmentMask();
//    }
//
//    /// The number of extra inhabitants, that is, bit patterns that do not form
//    /// valid values of the type, in this type's binary representation.
//    unsigned getNumExtraInhabitants() const {
//      return extraInhabitantCount;
//    }
}
