//
//  TargetTypeGenericContextDescriptorHeader.swift
//  SwiftObject
//
//  Created by warden on 2020/11/25.
//

import Foundation

struct TargetTypeGenericContextDescriptorHeader {
    let InstantiationCache: RelativeDirectPointer   // The metadata instantiation cache.
    let DefaultInstantiationPattern: RelativeDirectPointer  // The default instantiation pattern.
    let Base: TargetGenericContextDescriptorHeader  // The base header.  Must always be the final member.
}
typealias TypeGenericContextDescriptorHeader = TargetTypeGenericContextDescriptorHeader
