//
//  Person.m
//  MessageForwarding
//
//  Created by warden on 2018/3/9.
//  Copyright © 2018年 warden. All rights reserved.
//

#import "Person.h"
#import <objc/message.h>
#import "Doctor.h"

@implementation Person

void dynamicAddTeach(id self, SEL _cmd)
{
    // implementation ....
    NSLog(@"这是c语言的teach函数 -- %@", self);
}

void dynamicAddBattle(id self, SEL _cmd)
{
    // implementation ....
    NSLog(@"这是c语言的battle函数 -- %@", self);
}

#pragma mark - 第一种方法（动态添加方法）

+ (BOOL)resolveInstanceMethod:(SEL)sel {
    // 添加OC方法
    if (sel_isEqual(sel, NSSelectorFromString(@"teach"))) {
//        IMP imp = class_getMethodImplementation([Person class], NSSelectorFromString(@"teach"));
//        class_addMethod([self class], sel, imp, "v@:");
        // 添加c函数
        class_addMethod([self class], sel, (IMP)dynamicAddTeach, "v@:");
        return YES;
    }

    return [super resolveInstanceMethod:sel];
}

+ (BOOL)resolveClassMethod:(SEL)sel {
    if (sel_isEqual(sel, NSSelectorFromString(@"battle"))) {
        // 添加c函数
        class_addMethod(objc_getMetaClass([NSStringFromClass(self.class) cStringUsingEncoding:NSUTF8StringEncoding]), sel, (IMP)dynamicAddBattle, "v@:");
        return YES;
    }
    return [super resolveClassMethod:sel];
}

#pragma mark - 第二种方法 - 转发

- (id)forwardingTargetForSelector:(SEL)aSelector {
    if (aSelector == NSSelectorFromString(@"cure")) {
        Doctor *d = [[Doctor alloc] init];
        if ([d respondsToSelector:aSelector]) {
            return d;
        }
    }
    return [super forwardingTargetForSelector:aSelector];
}

#pragma mark - 第三种方法 - 完整的消息转发机制

- (void)forwardInvocation:(NSInvocation *)anInvocation {
    NSString *method = NSStringFromSelector(anInvocation.selector);
    if ([method isEqualToString:@"suicide"]) {
        NSMethodSignature *signature = [NSMethodSignature signatureWithObjCTypes:"v@:"];
        anInvocation = [NSInvocation invocationWithMethodSignature:signature];
        [anInvocation setTarget:self];
        [anInvocation setSelector:@selector(donotSuicide)];
        [anInvocation invoke];
        return;
    }    
    // 从继承树中查找
    [super forwardInvocation:anInvocation];
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    if (aSelector == NSSelectorFromString(@"suicide")) {
        NSMethodSignature *sig = [NSMethodSignature signatureWithObjCTypes:"v@:"];
        return sig;
    } else {
        return [super methodSignatureForSelector:aSelector];
    }
}

- (void)run {
    NSLog(@"我在跑步");
}

- (void)eat {
    NSLog(@"我在吃饭");
}

- (void)donotSuicide {
    NSLog(@"don't kill yourself");
}

@end
