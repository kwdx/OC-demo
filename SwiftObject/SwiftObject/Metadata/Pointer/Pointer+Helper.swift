//
//  Pointer+Helper.swift
//  SwiftObject
//
//  Created by warden on 2020/11/19.
//

import Foundation

extension UnsafeRawPointer {
    func applyIndirect(relativeOffset: __int32_t) -> UnsafeRawPointer? {
        if relativeOffset == 0 {
            return nil
        }
        let pointer = advanced(by: (Int(relativeOffset) & ~1))
        if relativeOffset & 1 == 1 {
            return UnsafeRawPointer(bitPattern: pointer.load(as: Int.self))
        } else {
            return pointer
        }
    }
    
    func applyDirect(relativeOffset: __int32_t) -> UnsafeRawPointer {
        UnsafeRawPointer(self).advanced(by: Int(relativeOffset))
    }
}

extension UnsafePointer {
    var raw: UnsafeRawPointer { UnsafeRawPointer(self) }
    
    var next: Self { advanced(by: 1) }
    
}
