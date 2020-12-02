//
//  FieldRecordFlags.swift
//  SwiftObject
//
//  Created by warden on 2020/11/26.
//

import Foundation

struct FieldRecordFlags {
    let Data: __uint32_t
    
    var isIndirectCase: Bool { Data & 0x1 == 0x1 }
    
    var isVar: Bool { Data & 0x2 == 0x2 }
}
