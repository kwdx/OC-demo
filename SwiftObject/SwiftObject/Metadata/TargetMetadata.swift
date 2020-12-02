//
//  TargetMetadata.swift
//  SwiftObject
//
//  Created by warden on 2020/11/19.
//

import Foundation

protocol TargetMetadata_P {
    var Kind: StoredPointer { get }
}

struct TargetMetadata: TargetMetadata_P {
    let Kind: StoredPointer
}


extension UnsafePointer where Pointee: TargetMetadata_P {
    
    func getKind() -> MetadataKind {
        if pointee.Kind > uintptr_t(MetadataKind.LastEnumeratedMetadataKind.rawValue) {
            return .Class
        } else {
            return MetadataKind(rawValue: __uint32_t(pointee.Kind))!
        }
    }
    
    /// Is this a class object--the metadata record for a Swift class (which also
    /// serves as the class object), or the class object for an ObjC class (which
    /// is not metadata)?
    var isClassObject: Bool {
        getKind() == .some(.Class)
    }
    
    /// Does the given metadata kind represent metadata for some kind of class?
    var isAnyKindOfClass: Bool {
        switch getKind() {
        case .Class, .ObjCClassWrapper, .ForeignClass:
            return true
        default:
            return false
        }
    }
    
    func getClassObject() -> UnsafePointer<TargetClassMetadata>? {
        if isClassObject {
            return withMemoryRebound(to: TargetClassMetadata.self, capacity: MemoryLayout<TargetClassMetadata>.size) { $0 }
        }
        return nil
    }
 
//    // MARK: - ValueWitnessTable
//
//    const ValueWitnessTable *getValueWitnesses() const {
//      return asFullMetadata(this)->ValueWitnesses;
//    }
//
//    const TypeLayout *getTypeLayout() const {
//      return getValueWitnesses()->getTypeLayout();
//    }

}
