//
//  TargetGenericContextDescriptorHeader.swift
//  SwiftObject
//
//  Created by warden on 2020/11/25.
//

import Foundation

struct TargetGenericContextDescriptorHeader {
    var NumParams: __uint16_t
    var NumRequirements: __uint16_t
    var NumKeyArguments: __uint16_t
    var NumExtraArguments: __uint16_t
    
    func getNumArguments() -> __uint32_t {
        return __uint32_t(NumKeyArguments + NumExtraArguments)
    }
    
    var hasArguments: Bool {
        getNumArguments() > 0
    }
}
typealias GenericContextDescriptorHeader = TargetGenericContextDescriptorHeader
