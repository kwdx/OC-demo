//
//  ContextDescriptorFlags.swift
//  SwiftObject
//
//  Created by warden on 2020/11/19.
//

import Foundation

/// Common flags stored in the first 32-bit word of any context descriptor.
struct ContextDescriptorFlags {
    let Value: __uint32_t
}

extension ContextDescriptorFlags {
    func getKindSpecificFlags() -> __uint16_t {
        return __uint16_t((Value >> 16) & 0xFFFF)
    }
}
