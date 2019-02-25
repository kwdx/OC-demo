//
//  Person.m
//  MessageForward
//
//  Created by warden on 2019/2/25.
//  Copyright © 2019 warden. All rights reserved.
//

#import "Person.h"
#import <objc/message.h>
#import "Dog.h"

@implementation Person

void dynamicRun(id self, SEL _cmd)
{
    NSLog(@"这是c语言的run函数 -- %@", self);
}

void dynamicBattle(id self, SEL _cmd)
{
    NSLog(@"这是c语言的battle函数 -- %@", self);
}

- (void)wd_run {
    NSLog(@"running");
}

+ (void)wd_battle {
    NSLog(@"Battle");
}

#pragma mark - 动态添加

//+ (BOOL)resolveInstanceMethod:(SEL)sel {
//    if (sel_isEqual(sel, NSSelectorFromString(@"run"))) {
////        // 添加OC方法
////        Method method = class_getInstanceMethod(self, @selector(wd_run));
////        IMP imp = method_getImplementation(method);
////        class_addMethod([self class], sel, imp, method_getTypeEncoding(method));
//        // 添加c函数
//        class_addMethod([self class], sel, (IMP)dynamicRun, "v@:");
//
//        return YES;
//    }
//    return [super resolveInstanceMethod:sel];
//}
//
//+ (BOOL)resolveClassMethod:(SEL)sel {
//    if (sel_isEqual(sel, NSSelectorFromString(@"battle"))) {
//        // 获取元类
//        Class metaClass = object_getClass(self);
////        // 添加OC方法
////        Method method = class_getClassMethod(self, @selector(wd_battle));
////        IMP imp = method_getImplementation(method);
////        class_addMethod(metaClass, sel, imp, method_getTypeEncoding(method));
//        // 添加c函数
//        class_addMethod(metaClass, sel, (IMP)dynamicBattle, "v@:");
//
//        return YES;
//    }
//    return [super resolveClassMethod:sel];
//}

#pragma mark - 转发

//- (id)forwardingTargetForSelector:(SEL)aSelector {
//    if (sel_isEqual(aSelector, @selector(run))) {
//        return [[Dog alloc] init];
//    }
//    return [super forwardingTargetForSelector:aSelector];
//}
//
//+ (id)forwardingTargetForSelector:(SEL)aSelector {
//    if (sel_isEqual(aSelector, @selector(battle))) {
//        return [Dog class];
//    }
//    return [super forwardingTargetForSelector:aSelector];
//}

#pragma mark - 完整的消息转发

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    if (sel_isEqual(aSelector, @selector(run))) {
        return [NSMethodSignature signatureWithObjCTypes:"v@:"];
    }
    return [super methodSignatureForSelector:aSelector];
}

- (void)forwardInvocation:(NSInvocation *)anInvocation {
    if (sel_isEqual(anInvocation.selector, @selector(run))) {
        Dog *d = [[Dog alloc] init];
        [anInvocation invokeWithTarget:d];
    }
}

+ (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    if (sel_isEqual(aSelector, @selector(battle))) {
        return [NSMethodSignature signatureWithObjCTypes:"v@:"];
    }
    return [super methodSignatureForSelector:aSelector];
}

+ (void)forwardInvocation:(NSInvocation *)anInvocation {
    if (sel_isEqual(anInvocation.selector, @selector(battle))) {
        [anInvocation invokeWithTarget:[Dog class]];
    }
}

@end
