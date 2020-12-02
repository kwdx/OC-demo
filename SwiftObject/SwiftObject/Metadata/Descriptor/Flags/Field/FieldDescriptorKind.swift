//
//  FieldDescriptorKind.swift
//  SwiftObject
//
//  Created by warden on 2020/11/26.
//

import Foundation

enum FieldDescriptorKind: __uint16_t {
    case aStruct
    case aClass
    case aEnum
    case aMultiPayloadEnum
    case aProtocol
    case aClassProtocol
    case aObjCProtocol
    case aObjCClass
}
