//
//  TargetOverrideTableHeader.swift
//  SwiftObject
//
//  Created by warden on 2020/11/25.
//

import Foundation

/// Header for a class vtable override descriptor.
struct TargetOverrideTableHeader {
    /// The number of MethodOverrideDescriptor records following the vtable
    /// override header in the class's nominal type descriptor.
    let NumEntries: __uint32_t
};
