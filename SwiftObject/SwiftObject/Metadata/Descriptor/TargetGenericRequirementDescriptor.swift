//
//  TargetGenericRequirementDescriptor.swift
//  SwiftObject
//
//  Created by warden on 2020/11/25.
//

import Foundation

struct TargetGenericRequirementDescriptor {
    let Flags: GenericRequirementFlags

    /// The type that's constrained, described as a mangled name.
    let Param: RelativeDirectPointer
    
    let unionPointer: RelativeDirectPointer
}
typealias GenericRequirementDescriptor = TargetGenericRequirementDescriptor


extension TargetGenericRequirementDescriptor {
//    union {
//      /// A mangled representation of the same-type or base class the param is
//      /// constrained to.
//      ///
//      /// Only valid if the requirement has SameType or BaseClass kind.
//      RelativeDirectPointer<const char, /*nullable*/ false> Type;
//      
//      /// The protocol the param is constrained to.
//      ///
//      /// Only valid if the requirement has Protocol kind.
//      RelativeTargetProtocolDescriptorPointer<Runtime> Protocol;
//      
//      /// The conformance the param is constrained to use.
//      ///
//      /// Only valid if the requirement has SameConformance kind.
//      RelativeIndirectablePointer<TargetProtocolConformanceDescriptor<Runtime>,
//                                  /*nullable*/ false> Conformance;
//      
//      /// The kind of layout constraint.
//      ///
//      /// Only valid if the requirement has Layout kind.
//      GenericRequirementLayoutKind Layout;
//    };
}
