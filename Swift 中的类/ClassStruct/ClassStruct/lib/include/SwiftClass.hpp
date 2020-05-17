//
//  SwiftClass.hpp
//  ClassStruct
//
//  Created by warden on 2020/5/14.
//  Copyright © 2020 warden. All rights reserved.
//

#ifndef SwiftClass_hpp
#define SwiftClass_hpp

#include <stdio.h>

//const WDLastEnumeratedMetadataKind = 0x7FF;

struct TargetAnyClassMetadata {
    struct TargetAnyClassMetadata* Kind;
    void* superClass;
    void* CacheData[2];
    void* Data;
};

struct TargetClassMetadata {
    
    uintptr_t Kind;
    //    ConstTargetMetadataPointer<Runtime, swift::TargetClassMetadata> Superclass;
    struct AnyClassHeapMetadata* superClass;
    void* CacheData[2];
    void* Data;
    
    /// Swift-specific class flags.
    uint32_t Flags;
    
    /// The address point of instances of this type.
    uint32_t InstanceAddressPoint;
    
    /// The required size of instances of this type.
    /// 'InstanceAddressPoint' bytes go before the address point;
    /// 'InstanceSize - InstanceAddressPoint' bytes go after it.
    uint32_t InstanceSize;
    
    /// The alignment mask of the address point of instances of this type.
    uint16_t InstanceAlignMask;
    
    /// Reserved for runtime use.
    uint16_t Reserved;
    
    /// The total size of the class object, including prefix and suffix
    /// extents.
    uint32_t ClassSize;
    
    /// The offset of the address point within the class object.
    uint32_t ClassAddressPoint;
    
    /// An out-of-line Swift-specific description of the type, or null
    /// if this is an artificial subclass.  We currently provide no
    /// supported mechanism for making a non-artificial subclass
    /// dynamically.
    uintptr_t Description;
    
    /// A function for destroying instance variables, used to clean up after an
    /// early return from a constructor. If null, no clean up will be performed
    /// and all ivars must be trivial.
    uintptr_t IVarDestroyer;
};

#endif /* SwiftClass_hpp */
