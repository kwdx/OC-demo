//
//  GenericParamDescriptor.swift
//  SwiftObject
//
//  Created by warden on 2020/11/25.
//

import Foundation

struct GenericParamKind {
    var value: __uint8_t
    /// A type parameter.
//    static let Type: GenericParamKind = .init(value: 0)
    static let aType: GenericParamKind = .init(value: 0)
    static let Max: GenericParamKind = .init(value: 0x3F)
}

struct GenericParamDescriptor {
    let Value: __uint8_t
    
    var hasKeyArgument: Bool { (Value & 0x80) != 0}
  
    var hasExtraArgument: Bool { (Value & 0x40) != 0 }
    
    func getKind() -> GenericParamKind {
        return GenericParamKind(value: Value & 0x3F)
    }
    
    func withKeyArgument(hasKeyArgument: Bool) -> GenericParamDescriptor {
        return .init(Value: (Value & 0x7f) | (hasKeyArgument ? 0x80 : 0))
    }
    
    func withExtraArgument(hasExtraArgument: Bool) -> GenericParamDescriptor {
        return .init(Value: (Value & 0xBF) | (hasExtraArgument ? 0x40 : 0))
    }
    
    func withKind(kind: GenericParamKind) -> GenericParamDescriptor {
        assert((kind.value & 0x3F) == kind.value)
        return .init(Value: (kind.value & 0xC0) | kind.value)
    }
    
    var getIntValue: __uint8_t { Value }
  
}
