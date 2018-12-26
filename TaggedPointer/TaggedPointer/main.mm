//
//  main.m
//  TaggedPointer
//
//  Created by warden on 2018/12/19.
//  Copyright © 2018 warden. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import <objc/runtime.h>

#define ISA_MASK 0x0000000ffffffff8ULL

struct wd_objc_object {
    void *isa;
};

#define _OBJC_TAG_SLOT_COUNT 16
#define _OBJC_TAG_EXT_SLOT_COUNT 256

extern "C" {
    extern Class objc_debug_taggedpointer_classes[_OBJC_TAG_SLOT_COUNT * 2];
    extern Class objc_debug_taggedpointer_ext_classes[_OBJC_TAG_EXT_SLOT_COUNT];
    extern uintptr_t objc_debug_taggedpointer_obfuscator;
}
#define objc_tag_classes objc_debug_taggedpointer_classes
#define _OBJC_TAG_MASK 1UL<<63
#define _OBJC_TAG_INDEX_SHIFT 60
#define _OBJC_TAG_INDEX_MASK 0x7
#define _OBJC_TAG_EXT_PAYLOAD_LSHIFT 12
#define _OBJC_TAG_EXT_PAYLOAD_RSHIFT 12
#define _OBJC_TAG_PAYLOAD_LSHIFT 4
#define _OBJC_TAG_PAYLOAD_RSHIFT 4

static inline uintptr_t
objc_decodeTaggedPointer(const void * _Nullable ptr)
{
    return (uintptr_t)ptr ^ objc_debug_taggedpointer_obfuscator;
}

static inline uintptr_t
objc_getTaggedPointerValue(const void * _Nullable ptr)
{
    // assert(_objc_isTaggedPointer(ptr));
    uintptr_t value = objc_decodeTaggedPointer(ptr);
    uintptr_t basicTag = (value >> _OBJC_TAG_INDEX_SHIFT) & _OBJC_TAG_INDEX_MASK;
    if (basicTag == _OBJC_TAG_INDEX_MASK) {
        return (value << _OBJC_TAG_EXT_PAYLOAD_LSHIFT) >> _OBJC_TAG_EXT_PAYLOAD_RSHIFT;
    } else {
        return (value << _OBJC_TAG_PAYLOAD_LSHIFT) >> _OBJC_TAG_PAYLOAD_RSHIFT;
    }
}

static inline intptr_t
objc_getTaggedPointerSignedValue(const void * _Nullable ptr)
{
    // assert(_objc_isTaggedPointer(ptr));
    uintptr_t value = objc_decodeTaggedPointer(ptr);
    uintptr_t basicTag = (value >> _OBJC_TAG_INDEX_SHIFT) & _OBJC_TAG_INDEX_MASK;
    if (basicTag == _OBJC_TAG_INDEX_MASK) {
        return ((intptr_t)value << _OBJC_TAG_EXT_PAYLOAD_LSHIFT) >> _OBJC_TAG_EXT_PAYLOAD_RSHIFT;
    } else {
        return ((intptr_t)value << _OBJC_TAG_PAYLOAD_LSHIFT) >> _OBJC_TAG_PAYLOAD_RSHIFT;
    }
}

int main(int argc, char * argv[]) {
    @autoreleasepool {
//        NSString *str1 = [NSString stringWithFormat:@"a"];
//        NSString *str2 = [NSString stringWithFormat:@"b"];
//        NSString *str3 = [NSString stringWithFormat:@"c"];
//        NSString *str4 = [NSString stringWithFormat:@"abcdefghijklmnopqrstuvwxyz"];
//
//        NSLog(@"%s  %p", object_getClassName(str1), str1);
//        NSLog(@"%s  %p", object_getClassName(str2), str2);
//        NSLog(@"%s  %p", object_getClassName(str3), str3);
//        NSLog(@"%s  %p", object_getClassName(str4), str4);
        
        
//        NSString *str1 = [NSString stringWithFormat:@"a"];
//        NSNumber *num1 = [NSNumber numberWithInteger:1];
//
//        wd_objc_object *wd_str1 = (__bridge wd_objc_object *)str1;
//        wd_objc_object *wd_num1 = (__bridge wd_objc_object *)num1;
//        uintptr_t ps1 = (uintptr_t)wd_str1;
//        uintptr_t pn1 = (uintptr_t)wd_num1;
//
//        NSLog(@"%@", objc_tag_classes[ps1>>60]);
//        NSLog(@"%@", objc_tag_classes[pn1>>60]);
        
        
//        uint16_t NSString_Tag = 2;
//        uint16_t NSNumber_Tag = 3;
//
//        uintptr_t string_tagObfuscator = ((objc_debug_taggedpointer_obfuscator
//                                           >> _OBJC_TAG_INDEX_SHIFT)
//                                          & _OBJC_TAG_INDEX_MASK);
//        uintptr_t number_tagObfuscator = ((objc_debug_taggedpointer_obfuscator
//                                           >> _OBJC_TAG_INDEX_SHIFT)
//                                          & _OBJC_TAG_INDEX_MASK);
//
//        uintptr_t string_obfuscatedTag = NSString_Tag ^ string_tagObfuscator;
//        uintptr_t number_obfuscatedTag = NSNumber_Tag ^ number_tagObfuscator;
//
//        NSLog(@"%@", objc_tag_classes[0x8 | string_obfuscatedTag]);
//        NSLog(@"%@", objc_tag_classes[0x8 | number_obfuscatedTag]);

        
//        NSNumber *num1 = [NSNumber numberWithInt:1];
//        NSNumber *num2 = [NSNumber numberWithInteger:-1];
//        NSNumber *num3 = [NSNumber numberWithInteger:-2];
//
//        NSString *str1 = [NSString stringWithFormat:@"1"];
//        NSString *str2 = [NSString stringWithFormat:@"2"];
//
//        uintptr_t value1 = objc_getTaggedPointerValue((__bridge void *)num1);
//        uintptr_t value2 = objc_getTaggedPointerValue((__bridge void *)num2);
//        uintptr_t value3 = objc_getTaggedPointerValue((__bridge void *)num3);
//        NSLog(@"%lx", value1);
//        NSLog(@"%lx", value2);
//        NSLog(@"%lx", value3);
//
//        value1 = objc_getTaggedPointerValue((__bridge void *)str1);
//        value2 = objc_getTaggedPointerValue((__bridge void *)str2);
//        NSLog(@"%lx", value1);
//        NSLog(@"%lx", value2);
        
        
//        NSString *str1 = [NSString stringWithFormat:@"a"];
//        NSString *str2 = [NSString stringWithFormat:@"ab"];
//
//        uintptr_t value1 = objc_getTaggedPointerValue((__bridge void *)str1);
//        uintptr_t value2 = objc_getTaggedPointerValue((__bridge void *)str2);
//        NSLog(@"%lx", value1);
//        NSLog(@"%lx", value2);
        
        
//        NSString *str1 = [NSString stringWithFormat:@"a"];
//        NSString *str2 = [NSString stringWithFormat:@"ab"];
//        NSString *str3 = [NSString stringWithFormat:@"abc"];
//        NSString *str4 = [NSString stringWithFormat:@"abcd"];
//
//        uintptr_t value1 = objc_getTaggedPointerValue((__bridge void *)str1);
//        uintptr_t value2 = objc_getTaggedPointerValue((__bridge void *)str2);
//        uintptr_t value3 = objc_getTaggedPointerValue((__bridge void *)str3);
//        uintptr_t value4 = objc_getTaggedPointerValue((__bridge void *)str4);
//        NSLog(@"%lx", value1);
//        NSLog(@"%lx", value2);
//        NSLog(@"%lx", value3);
//        NSLog(@"%lx", value4);
        
        
//        NSMutableString *muStr = [NSMutableString stringWithCapacity:7];
//        for (int i = 0; i < 7; i++) {
//            [muStr appendString:@"o"];
//        }
//        NSString *str = muStr.copy;
//        NSLog(@"%s  %@", object_getClassName(str), str);
//        void *value = (__bridge void *)str;
//        NSLog(@"%lx", (uintptr_t)value);
//        NSLog(@"%lx", objc_getTaggedPointerValue((__bridge void *)str));
//
//        [muStr appendString:@"o"];
//        str = muStr.copy;
//        NSLog(@"%s  %@", object_getClassName(str), str);
//        value = (__bridge void *)str;
//        NSLog(@"%lx", (uintptr_t)value);
//        NSLog(@"%lx", objc_getTaggedPointerValue((__bridge void *)str));

        
//        NSString *str1 = [NSString stringWithFormat:@"aaaaaaaaaa"];
//
//        uintptr_t value1 = objc_getTaggedPointerValue((__bridge void *)str1);
//        NSLog(@"%lx", value1);
        
//        NSMutableString *muStr = [NSMutableString string];
//        for (int i = 0; i < 8; i ++) {
//            [muStr appendString:@"a"];
//        }
//        NSString *str = muStr.copy;
//        void *value = (__bridge void *)str;
//
//        NSLog(@"%ld", (uintptr_t)value & 0xf);
        
NSString *str1 = [NSString stringWithFormat:@"+++++++"];
NSString *str2 = [NSString stringWithFormat:@"++++++++"];
NSLog(@"%s  %p", object_getClassName(str1), str1);
NSLog(@"%s  %p", object_getClassName(str2), str2);

//        uint16_t tag = 2;
//
//        uintptr_t result =
//        (_OBJC_TAG_MASK |
//         ((uintptr_t)tag << _OBJC_TAG_INDEX_SHIFT) |
//         ((value << _OBJC_TAG_PAYLOAD_RSHIFT) >> _OBJC_TAG_PAYLOAD_LSHIFT));

        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
    return 0;
}
