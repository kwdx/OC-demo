//
//  Defines.swift
//  SwiftObject
//
//  Created by warden on 2020/11/19.
//

import Foundation

typealias StoredPointer = uintptr_t

typealias RelativeDirectPointer = __int32_t
typealias RelativeIndirectablePointer = __int32_t

typealias TargetRelativeDirectPointer = RelativeDirectPointer
typealias TargetRelativeIndirectablePointer = RelativeIndirectablePointer

let SWIFT_CLASS_IS_SWIFT_MASK: uint64 = 2

typealias StoredPointerDifference = ptrdiff_t
