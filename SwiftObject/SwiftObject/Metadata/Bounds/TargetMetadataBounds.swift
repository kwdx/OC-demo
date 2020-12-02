//
//  TargetMetadataBounds.swift
//  SwiftObject
//
//  Created by warden on 2020/11/25.
//

import Foundation

protocol TargetMetadataBounds_P {
    var NegativeSizeInWords: __uint32_t { get }
    var PositiveSizeInWords: __uint32_t { get }
    
    func getTotalSizeInBytes() -> size_t
    func getAddressPointInBytes() -> size_t
}

struct TargetMetadataBounds: TargetMetadataBounds_P {
    var NegativeSizeInWords: __uint32_t
    var PositiveSizeInWords: __uint32_t
}


extension TargetMetadataBounds_P {
    
    /// Return the total size of the metadata in bytes, including both
    /// negatively- and positively-offset members.
    func getTotalSizeInBytes() -> size_t {
//        return (StoredSize(NegativeSizeInWords) + StoredSize(PositiveSizeInWords))
//                  * sizeof(void*);
        return size_t((NegativeSizeInWords + PositiveSizeInWords) * 8)
    }
    
    /// Return the offset of the address point of the metadata from its
    /// start, in bytes.
    func getAddressPointInBytes() -> size_t {
//        return StoredSize(NegativeSizeInWords) * sizeof(void*);
        return size_t(NegativeSizeInWords * 8)
    }
}
