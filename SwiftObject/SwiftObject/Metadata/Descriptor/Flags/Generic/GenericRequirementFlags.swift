//
//  GenericRequirementFlags.swift
//  SwiftObject
//
//  Created by warden on 2020/11/25.
//

import Foundation

struct GenericRequirementKind {
    let Value: __uint8_t
    
    /// A protocol requirement.
    static let aProtocol: Self = .init(Value: 0)
    /// A same-type requirement.
    static let aSameType: Self = .init(Value: 1)
    /// A base class requirement.
    static let aBaseClass: Self = .init(Value: 2)
    /// A "same-conformance" requirement, implied by a same-type or base-class
    /// constraint that binds a parameter with protocol requirements.
    static let aSameConformance: Self = .init(Value: 3)
    /// A layout constraint.
    static let aLayout: Self = .init(Value: 0x1F)
}

struct GenericRequirementFlags {
    let Value: __uint32_t
  
    var hasKeyArgument: Bool { (Value & 0x80) != 0 }
    
    var hasExtraArgument: Bool { (Value & 0x40) != 0 }
    
    func getKind() -> GenericRequirementKind {
        .init(Value: __uint8_t(Value & 0x1F))
    }
    
    func withKeyArgument(hasKeyArgument: Bool) -> GenericRequirementFlags {
        return .init(Value: (Value & 0x7f) | (hasKeyArgument ? 0x80 : 0))
    }
    
    func withExtraArgument(hasExtraArgument: Bool) -> GenericRequirementFlags {
        return .init(Value: (Value & 0xBF) | (hasExtraArgument ? 0x40 : 0))
    }
    
    func withKind(kind: GenericParamKind) -> GenericRequirementFlags {
        assert((__uint8_t(kind.value) & 0x1F) == __uint8_t(kind.value))
        return .init(Value: __uint32_t((kind.value & 0xE0) | __uint8_t(kind.value)))
    }
    
    var getIntValue: __uint32_t { Value }
    
};
