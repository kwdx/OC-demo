//
//  TargetClassDescriptor.swift
//  SwiftObject
//
//  Created by warden on 2020/11/19.
//

import Foundation

struct TargetClassDescriptor: TargetTypeContextDescriptor_P {
    
    // MARK: - TargetContextDescriptor
    
    let Flags: ContextDescriptorFlags
    let Parent: RelativeIndirectablePointer
    
    // MARK: - TargetTypeContextDescriptor
    
    let Name: __int32_t
    let AccessFunctionPtr: __int32_t
    let Fields: RelativeDirectPointer

    // MARK: - Self
    
    // The type of the superclass, expressed as a mangled type name that can refer to the generic arguments of the subclass type.
    let SuperclassType: RelativeDirectPointer
    
    /**
     union {
       /// If this descriptor does not have a resilient superclass, this is the
       /// negative size of metadata objects of this class (in words).
       uint32_t MetadataNegativeSizeInWords;

       /// If this descriptor has a resilient superclass, this is a reference
       /// to a cache holding the metadata's extents.
       TargetRelativeDirectPointer<Runtime,
                                   TargetStoredClassMetadataBounds<Runtime>>
         ResilientMetadataBounds;
     };
     */
    let MetadataNegativeSizeInWords_Union: __uint32_t
    
    
    /**
     union {
       /// If this descriptor does not have a resilient superclass, this is the
       /// positive size of metadata objects of this class (in words).
       uint32_t MetadataPositiveSizeInWords;

       /// Otherwise, these flags are used to do things like indicating
       /// the presence of an Objective-C resilient class stub.
       ExtraClassDescriptorFlags ExtraClassFlags;
     };
     */
    let MetadataPositiveSizeInWords_Union: __uint32_t

    // The number of additional members added by this class to the class metadata
    let NumImmediateMembers: __uint32_t
    
    // The number of stored properties in the class, not including its superclasses. If there is a field offset vector, this is its length.
    let NumFields: __uint32_t
    
    // The offset of the field offset vector for this class's stored properties in its metadata, in words. 0 means there is no field offset vector.
    let FieldOffsetVectorOffset: __uint32_t
}

extension TargetClassDescriptor {
    
    /// If this descriptor does not have a resilient superclass, this is the
    /// negative size of metadata objects of this class (in words).
    var MetadataNegativeSizeInWords: __uint32_t {
        MetadataNegativeSizeInWords_Union
    }
    
    /// If this descriptor has a resilient superclass, this is a reference
    /// to a cache holding the metadata's extents.
    /// TargetStoredClassMetadataBounds
    var ResilientMetadataBounds: TargetRelativeDirectPointer {
        TargetRelativeDirectPointer(MetadataNegativeSizeInWords_Union)
    }
    
    /// If this descriptor does not have a resilient superclass, this is the
    /// positive size of metadata objects of this class (in words).
    var MetadataPositiveSizeInWords: __uint32_t {
        MetadataPositiveSizeInWords_Union
    }
    
    /// Otherwise, these flags are used to do things like indicating
    /// the presence of an Objective-C resilient class stub.
    var ExtraClassFlags: ExtraClassDescriptorFlags {
        .init(Value: MetadataPositiveSizeInWords_Union)
    }
    
}

extension UnsafePointer where Pointee == TargetClassDescriptor {
    
    typealias VTableDescriptorHeader = TargetVTableDescriptorHeader
    typealias MethodDescriptor = TargetMethodDescriptor
    typealias OverrideTableHeader = TargetOverrideTableHeader
    typealias MethodOverrideDescriptor = TargetMethodOverrideDescriptor
    
    func getTypeContextDescriptorFlags() -> TypeContextDescriptorFlags {
        return .init(Value: pointee.Flags.getKindSpecificFlags())
    }
    
    // MARK: - Field
        
    /// 获取Field描述符
    func getFieldDescriptor() -> UnsafePointer<FieldDescriptor> {
        let advanced = MemoryLayout<ContextDescriptorFlags>.size +
            MemoryLayout<RelativeIndirectablePointer>.size +
            MemoryLayout<__int32_t>.size +
            MemoryLayout<__int32_t>.size
        
        return raw.advanced(by: advanced)
            .applyDirect(relativeOffset: pointee.Fields)
            .bindMemory(to: FieldDescriptor.self, capacity: MemoryLayout<FieldDescriptor>.size)
    }
    
    // MARK: - VTable
    
    /// 是否有虚函数表
    func hasVTable() -> Bool {
        getTypeContextDescriptorFlags().class_hasVTable()
    }
    
    /// 是否重写了函数表
    func hasOverrideTable() -> Bool {
        getTypeContextDescriptorFlags().class_hasOverrideTable()
    }
    
    /// 获取虚函数表描述符
    func getVTableDescriptor() -> UnsafePointer<VTableDescriptorHeader>? {
        if !hasVTable() {
            return nil
        }
        return UnsafeRawPointer(self).advanced(by: getVTableDescriptorAdvanced()).bindMemory(to: VTableDescriptorHeader.self, capacity: MemoryLayout<VTableDescriptorHeader>.size)
    }
    
    /// 获取重载函数表描述符
    func getOverrideTable() -> UnsafePointer<OverrideTableHeader>? {
        if !hasOverrideTable() {
            return nil
        }
        return UnsafeRawPointer(self).advanced(by: getOverrideTableDescriptorAdvanced()).bindMemory(to: OverrideTableHeader.self, capacity: MemoryLayout<OverrideTableHeader>.size)
    }
    
    // MARK: - Methods
    
    /// 获取函数描述符
    func getMethodDescriptors() -> UnsafePointer<MethodDescriptor>? {
        if !hasVTable() {
            return nil
        }
        return UnsafeRawPointer(self).advanced(by: getMethodDescriptorsAdvanced()).bindMemory(to: MethodDescriptor.self, capacity: MemoryLayout<MethodDescriptor>.size)
    }
    
    /// 获取函数描述符
    func getMethodOverrideDescriptors() -> UnsafePointer<MethodOverrideDescriptor>? {
        if !hasOverrideTable() {
            return nil
        }
        return UnsafeRawPointer(self).advanced(by: getMethodOverrideDescriptorsAdvanced()).bindMemory(to: MethodOverrideDescriptor.self, capacity: MemoryLayout<MethodOverrideDescriptor>.size)
    }
    
    // MARK: - 未验证
    
    /// Return the offset of the start of generic arguments in the nominal
    /// type's metadata. The returned value is measured in words.
    func getGenericArgumentOffset() -> __int32_t {
        if !hasResilientSuperclass() {
            return getNonResilientGenericArgumentOffset();
        }
      // This lookup works by ADL and will intentionally fail for
      // non-InProcess instantiations.
      return getResilientImmediateMembersOffset();
    }
    
    /// Given that this class is known to not have a resilient superclass,
    /// return the offset of its generic arguments in words.
    func getNonResilientGenericArgumentOffset() -> __int32_t {
      return getNonResilientImmediateMembersOffset();
    }
    
    func getResilientImmediateMembersOffset() -> __int32_t {
        assert(hasResilientSuperclass())
        
        var storedBoundsPointer = raw
            .advanced(by: MemoryLayout<ContextDescriptorFlags>.size +
                        MemoryLayout<RelativeIndirectablePointer>.size +
                        MemoryLayout<__int32_t>.size * 2 +
                        MemoryLayout<RelativeDirectPointer>.size * 2)
            .applyDirect(relativeOffset: pointee.ResilientMetadataBounds)
            .bindMemory(to: TargetStoredClassMetadataBounds.self, capacity: MemoryLayout<TargetStoredClassMetadataBounds>.size)
            .pointee
        
        var result: ptrdiff_t = 0
        if storedBoundsPointer.tryGetImmediateMembersOffset(&result) {
            return __int32_t(result) / __int32_t(MemoryLayout<UnsafePointer>.size)
        }
        
        let bounds = computeMetadataBoundsFromSuperclass(storedBounds: &storedBoundsPointer)
        return __int32_t(bounds.ImmediateMembersOffset) / __int32_t(MemoryLayout<UnsafePointer>.size)
    }
    
    func hasResilientSuperclass() -> Bool {
        getTypeContextDescriptorFlags().class_hasResilientSuperclass()
    }
    
    /// Are the immediate members of the class metadata allocated at negative
    /// offsets instead of positive?
    func areImmediateMembersNegative() -> Bool {
        return getTypeContextDescriptorFlags().class_areImmediateMembersNegative()
    }
    
    /// Return the bounds of this class's metadata.
    func getMetadataBounds() -> TargetClassMetadataBounds {
        if !hasResilientSuperclass() {
            return getNonResilientMetadataBounds()
        }
        return getResilientMetadataBounds()
    }
    
    func getNonResilientMetadataBounds() -> TargetClassMetadataBounds {
        let negativeSize = getNonResilientImmediateMembersOffset() * __int32_t(MemoryLayout<size_t>.size)
        let positiveSize = pointee.MetadataNegativeSizeInWords
        let immediate = pointee.MetadataPositiveSizeInWords
        return TargetClassMetadataBounds(NegativeSizeInWords: __uint32_t(abs(negativeSize)), PositiveSizeInWords: positiveSize, ImmediateMembersOffset: ptrdiff_t(immediate))
    }
    
    func getNonResilientImmediateMembersOffset() -> __int32_t {
        return areImmediateMembersNegative()
            ? -__int32_t(pointee.MetadataNegativeSizeInWords)
            : __int32_t(pointee.MetadataPositiveSizeInWords) - __int32_t(pointee.NumImmediateMembers);
    }
    
    func getResilientMetadataBounds() -> TargetClassMetadataBounds {
        assert(false)
        #warning("不完善")
        return TargetClassMetadataBounds(NegativeSizeInWords: 0, PositiveSizeInWords: 0, ImmediateMembersOffset: 0)

//        let pointer = UnsafeRawPointer(self).advanced(by: 24).applyDirect(relativeOffset: __int32_t(pointee.MetadataNegativeSizeInWords))
//        return pointer.bindMemory(to: TargetClassMetadataBounds.self, capacity: MemoryLayout<TargetClassMetadataBounds>.size).pointee
//        auto &storedBounds = *description->ResilientMetadataBounds.get();
//
//        ClassMetadataBounds bounds;
//        if (storedBounds.tryGet(bounds)) {
//          return bounds;
//        }
//
//        return computeMetadataBoundsFromSuperclass(description, storedBounds);
    }
    
    func computeMetadataBoundsFromSuperclass(storedBounds: inout StoredClassMetadataBounds) -> TargetClassMetadataBounds {
        #warning("不完善")
        return TargetClassMetadataBounds(NegativeSizeInWords: 0, PositiveSizeInWords: 0, ImmediateMembersOffset: 0)
//      ClassMetadataBounds bounds;
//
//      // Compute the bounds for the superclass, extending it to the minimum
//      // bounds of a Swift class.
//      if (const void *superRef = description->getResilientSuperclass()) {
//        bounds = computeMetadataBoundsForSuperclass(superRef,
//                               description->getResilientSuperclassReferenceKind());
//      } else {
//        bounds = ClassMetadataBounds::forSwiftRootClass();
//      }
//
//      // Add the subclass's immediate members.
//      bounds.adjustForSubclass(description->areImmediateMembersNegative(),
//                               description->NumImmediateMembers);
//
//      // Cache before returning.
//      storedBounds.initialize(bounds);
//      return bounds;
    }

}

// MARK: - Assistance

fileprivate extension UnsafePointer where Pointee == TargetClassDescriptor {

    /// 获取虚函数表描述符偏移
    func getVTableDescriptorAdvanced() -> Int {
        if !hasVTable() {
            return 0
        }
//        print("alignment: max =", max(MemoryLayout<TargetTypeGenericContextDescriptorHeader>.alignment,
//                                      MemoryLayout<GenericParamDescriptor>.alignment,
//                                      MemoryLayout<TargetGenericRequirementDescriptor>.alignment,
//                                      MemoryLayout<TargetResilientSuperclass>.alignment,
//                                      MemoryLayout<TargetForeignMetadataInitialization>.alignment,
//                                      MemoryLayout<TargetSingletonMetadataInitialization>.alignment,
//                                      MemoryLayout<TargetVTableDescriptorHeader>.alignment,
//                                      MemoryLayout<TargetMethodDescriptor>.alignment,
//                                      MemoryLayout<TargetOverrideTableHeader>.alignment,
//                                      MemoryLayout<TargetMethodOverrideDescriptor>.alignment,
//                                      MemoryLayout<TargetObjCResilientClassStubInfo>.alignment))
//        print("TargetTypeGenericContextDescriptorHeader size=\(MemoryLayout<TargetTypeGenericContextDescriptorHeader>.size)")
//        print("GenericParamDescriptor size=\(MemoryLayout<GenericParamDescriptor>.size)")
//        print("TargetGenericRequirementDescriptor size=\(MemoryLayout<TargetGenericRequirementDescriptor>.size)")
//        print("TargetResilientSuperclass size=\(MemoryLayout<TargetResilientSuperclass>.size)")
//        print("TargetForeignMetadataInitialization size=\(MemoryLayout<TargetForeignMetadataInitialization>.size)")
//        print("TargetSingletonMetadataInitialization size=\(MemoryLayout<TargetSingletonMetadataInitialization>.size)")
//        print("TargetVTableDescriptorHeader size=\(MemoryLayout<TargetVTableDescriptorHeader>.size)")
        // 因为align=4，内存对齐
//        return max(4, MemoryLayout<GenericParamDescriptor>.size) +
//            MemoryLayout<TargetGenericRequirementDescriptor>.size +
//            MemoryLayout<TargetResilientSuperclass>.size +
//            MemoryLayout<TargetForeignMetadataInitialization>.size +
//            MemoryLayout<TargetSingletonMetadataInitialization>.size +
//            MemoryLayout<TargetVTableDescriptorHeader>.size
        return 8 + // MemoryLayout<TargetTypeGenericContextDescriptorHeader>.size
            4 + // max(4, MemoryLayout<GenericParamDescriptor>.size) +
            12 + // MemoryLayout<TargetGenericRequirementDescriptor>.size +
            4 + // MemoryLayout<TargetResilientSuperclass>.size +
            4 + // MemoryLayout<TargetForeignMetadataInitialization>.size +
            12 // MemoryLayout<TargetSingletonMetadataInitialization>.size +
    }
    
    /// 获取虚函数表描述符偏移
    func getMethodDescriptorsAdvanced() -> Int {
        return getVTableDescriptorAdvanced() + MemoryLayout<TargetVTableDescriptorHeader>.size
    }
    
    /// 获取重载函数描述符
    func getOverrideTableDescriptorAdvanced() -> Int {
//        return getMethodDescriptorsAdvanced() + MemoryLayout<TargetOverrideTableHeader>.size
        let methodNums = getVTableDescriptor()?.pointee.VTableSize ?? 0
        return getVTableDescriptorAdvanced() + Int(methodNums) * MemoryLayout<TargetMethodDescriptor>.size + MemoryLayout<TargetMethodDescriptor>.size
    }
    
    /// 获取重载函数描述符
    func getMethodOverrideDescriptorsAdvanced() -> Int {
        return getOverrideTableDescriptorAdvanced() + MemoryLayout<TargetOverrideTableHeader>.size
    }
}
