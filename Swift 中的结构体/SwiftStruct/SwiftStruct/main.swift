//
//  main.swift
//  SwiftStruct
//
//  Created by warden on 2020/5/13.
//  Copyright © 2020 warden. All rights reserved.
//

import Foundation

struct Size {
    var width: Int
    var height: Int
}

var size = Size(width: 1, height: 2)

print("内存对齐: \(MemoryLayout.alignment(ofValue: size))")
print("实际占用的内存大小: \(MemoryLayout.size(ofValue: size))")
print("分配的内存大小: \(MemoryLayout.stride(ofValue: size))")
print("--------------------------")
print("内存对齐: \(MemoryLayout<Size>.alignment)")
print("实际占用的内存大小: \(MemoryLayout<Size>.size)")
print("分配的内存大小: \(MemoryLayout<Size>.stride)")

let rawPointer = withUnsafePointer(to: &size) {
    UnsafeMutableRawPointer(mutating: $0)
}
print(rawPointer)

rawPointer.storeBytes(of: 3, as: Int.self)
rawPointer.storeBytes(of: 4, toByteOffset: 8, as: Int.self)
print(size)

print("width: \(rawPointer.load(as: Int.self))")
print("height: \(rawPointer.load(fromByteOffset: 8, as: Int.self))")

print(size)

