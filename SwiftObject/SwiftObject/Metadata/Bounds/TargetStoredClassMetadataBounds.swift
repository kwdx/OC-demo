//
//  TargetStoredClassMetadataBounds.swift
//  SwiftObject
//
//  Created by warden on 2020/11/28.
//

import Foundation

/// Storage for class metadata bounds.  This is the variable returned
/// by getAddrOfClassMetadataBounds in the compiler.
///
/// This storage is initialized before the allocation of any metadata
/// for the class to which it belongs.  In classes without resilient
/// superclasses, it is initialized statically with values derived
/// during compilation.  In classes with resilient superclasses, it
/// is initialized dynamically, generally during the allocation of
/// the first metadata of this class's type.  If metadata for this
/// class is available to you to use, you must have somehow synchronized
/// with the thread which allocated the metadata, and therefore the
/// complete initialization of this variable is also ordered before
/// your access.  That is why you can safely access this variable,
/// and moreover access it without further atomic accesses.  However,
/// since this variable may be accessed in a way that is not dependency-
/// ordered on the metadata pointer, it is important that you do a full
/// synchronization and not just a dependency-ordered (consume)
/// synchronization when sharing class metadata pointers between
/// threads.  (There are other reasons why this is true; for example,
/// field offset variables are also accessed without dependency-ordering.)
///
/// If you are accessing this storage without such a guarantee, you
/// should be aware that it may be lazily initialized, and moreover
/// it may be getting lazily initialized from another thread.  To ensure
/// correctness, the fields must be read in the correct order: the
/// immediate-members offset is initialized last with a store-release,
/// so it must be read first with a load-acquire, and if the result
/// is non-zero then the rest of the variable is known to be valid.
/// (No locking is required because racing initializations should always
/// assign the same values to the storage.)
struct TargetStoredClassMetadataBounds {
  /// The offset to the immediate members.  This value is in bytes so that
  /// clients don't have to sign-extend it.


      /// It is not necessary to use atomic-ordered loads when accessing this
      /// variable just to read the immediate-members offset when drilling to
      /// the immediate members of an already-allocated metadata object.
      /// The proper initialization of this variable is always ordered before
      /// any allocation of metadata for this class.
    var ImmediateMembersOffset: StoredPointerDifference

  /// The positive and negative bounds of the class metadata.
    var Bounds: TargetMetadataBounds;

  
}
typealias StoredClassMetadataBounds = TargetStoredClassMetadataBounds

extension TargetStoredClassMetadataBounds {
    /// Attempt to read the cached immediate-members offset.
    ///
    /// \return true if the read was successful, or false if the cache hasn't
    ///   been filled yet
    func tryGetImmediateMembersOffset(_ output: inout StoredPointerDifference) -> Bool {
        output = ImmediateMembersOffset
        return output != 0
    }
//    bool tryGetImmediateMembersOffset(StoredPointerDifference &output) {
//      output = ImmediateMembersOffset.load(std::memory_order_relaxed);
//      return output != 0;
//    }

    /// Attempt to read the full cached bounds.
    ///
    /// \return true if the read was successful, or false if the cache hasn't
    ///   been filled yet
    func tryGet(_ output: inout TargetClassMetadataBounds) -> Bool {
        let offset = ImmediateMembersOffset
        if offset == 0 {
            return false
        }
        
        output.ImmediateMembersOffset = offset
        output.NegativeSizeInWords = Bounds.NegativeSizeInWords
        output.PositiveSizeInWords = Bounds.PositiveSizeInWords
        return true
    }
//    bool tryGet(TargetClassMetadataBounds<Runtime> &output) {
//      auto offset = ImmediateMembersOffset.load(std::memory_order_acquire);
//      if (offset == 0) return false;
//
//      output.ImmediateMembersOffset = offset;
//      output.NegativeSizeInWords = Bounds.NegativeSizeInWords;
//      output.PositiveSizeInWords = Bounds.PositiveSizeInWords;
//      return true;
//    }
    
    mutating func initialize(_ value: TargetClassMetadataBounds) {
        Bounds.NegativeSizeInWords = value.NegativeSizeInWords
        Bounds.PositiveSizeInWords = value.PositiveSizeInWords
        ImmediateMembersOffset = value.ImmediateMembersOffset
    }
//    void initialize(TargetClassMetadataBounds<Runtime> value) {
//      assert(value.ImmediateMembersOffset != 0 &&
//             "attempting to initialize metadata bounds cache to a zero state!");
//
//      Bounds.NegativeSizeInWords = value.NegativeSizeInWords;
//      Bounds.PositiveSizeInWords = value.PositiveSizeInWords;
//      ImmediateMembersOffset.store(value.ImmediateMembersOffset,
//                                   std::memory_order_release);
//    }
}
