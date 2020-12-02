//
//  TypeContextDescriptorFlags.swift
//  SwiftObject
//
//  Created by warden on 2020/11/19.
//

import Foundation

struct TypeContextDescriptorFlags {
    let Value: __uint16_t
}

extension TypeContextDescriptorFlags {
    
    func class_hasVTable() -> Bool {
        (Value & (0x1<<15)) != 0
    }
    
    func class_hasOverrideTable() -> Bool {
        (Value & (0x1<<14)) != 0
    }
    
    func class_hasResilientSuperclass() -> Bool {
        (Value & (0x1<<13)) != 0
    }
    
    func class_areImmediateMembersNegative() -> Bool {
        (Value & (0x1<<12)) != 0
    }
    
}
