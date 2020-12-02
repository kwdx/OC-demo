//
//  MethodDescriptorFlags.swift
//  SwiftObject
//
//  Created by warden on 2020/11/25.
//

import Foundation

/// 函数类型
struct MethodDescriptorFlags {
    let Value: __uint32_t
}

extension MethodDescriptorFlags {
    /// 函数类型
    enum Kind: __uint32_t {
        case Method
        case Init
        case Getter
        case Setter
        case ModifyCoroutine
        case ReadCoroutine
        
        case unknown
    }
    
    func getKind() -> Kind {
        return Kind(rawValue: Value & 0x0F) ?? .unknown
    }
}
