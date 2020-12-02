//
//  TargetClassMetadataBounds.swift
//  SwiftObject
//
//  Created by warden on 2020/11/25.
//

import Foundation

protocol TargetClassMetadataBounds_P: TargetMetadataBounds_P {
    var ImmediateMembersOffset: ptrdiff_t { get }
}

struct TargetClassMetadataBounds: TargetClassMetadataBounds_P {
    var NegativeSizeInWords: __uint32_t     // The negative extent of the metadata, in words.
    var PositiveSizeInWords: __uint32_t     // The positive extent of the metadata, in words.
    var ImmediateMembersOffset: ptrdiff_t   // The offset from the address point of the metadata to the immediate members.
}
