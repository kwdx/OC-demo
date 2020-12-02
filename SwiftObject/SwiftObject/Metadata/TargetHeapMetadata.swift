//
//  TargetHeapMetadata.swift
//  SwiftObject
//
//  Created by warden on 2020/11/19.
//

import Foundation

protocol TargetHeapMetadata_P: TargetMetadata_P {
}

struct TargetHeapMetadata: TargetHeapMetadata_P {
    let Kind: StoredPointer
}
