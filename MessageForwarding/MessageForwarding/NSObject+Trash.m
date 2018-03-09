//
//  NSObject+Trash.m
//  MessageForwarding
//
//  Created by warden on 2018/3/9.
//  Copyright © 2018年 warden. All rights reserved.
//

#import "NSObject+Trash.h"
#import <objc/runtime.h>

@interface Trash : NSObject
@end

@implementation Trash

void dynamicTrash(id self, SEL _cmd, char *ch)
{
    // implementation ....
    printf("这是垃圾桶 -- %s\n", ch);
}
//+ (BOOL)resolveInstanceMethod:(SEL)sel {
//    // 添加c函数
//    class_addMethod([self class], sel, (IMP)dynamicTrash, "v@:*");
//    return YES;
//}
+ (BOOL)resolveClassMethod:(SEL)sel {
    // 添加c函数
    class_addMethod(objc_getMetaClass([NSStringFromClass(self.class) cStringUsingEncoding:NSUTF8StringEncoding]), sel, (IMP)dynamicTrash, "v@:*");
    return YES;
}
@end

@implementation NSObject (Trash)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        {
            SEL origsel = @selector(forwardInvocation:);
            Method origMethod = class_getInstanceMethod([self class], origsel);
            SEL swizsel = @selector(wd_forwardInvocation:);
            Method swizMethod = class_getInstanceMethod([self class], swizsel);
            
            BOOL addMehtod = class_addMethod([self class], origsel, method_getImplementation(swizMethod), method_getTypeEncoding(swizMethod));
            if (addMehtod) {
                class_replaceMethod([self class], swizsel, method_getImplementation(origMethod), method_getTypeEncoding(origMethod));
            } else {
                method_exchangeImplementations(origMethod, swizMethod);
            }
        }
        
        {
            SEL origsel = @selector(methodSignatureForSelector:);
            Method origMethod = class_getInstanceMethod([self class], origsel);
            SEL swizsel = @selector(wd_methodSignatureForSelector:);
            Method swizMethod = class_getInstanceMethod([self class], swizsel);
            
            BOOL addMehtod = class_addMethod([NSObject class], origsel, method_getImplementation(swizMethod), method_getTypeEncoding(swizMethod));
            if (addMehtod) {
                class_replaceMethod([self class], swizsel, method_getImplementation(origMethod), method_getTypeEncoding(origMethod));
            } else {
                method_exchangeImplementations(origMethod, swizMethod);
            }
        }
    });
}

#pragma mark - 第三种方法 - 完整的消息转发机制

- (void)wd_forwardInvocation:(NSInvocation *)anInvocation {
    NSString *debugInfo = [NSString stringWithFormat:@"[debug]unRecognizedMessage:[%@] sent to [%@]",NSStringFromSelector(anInvocation.selector), NSStringFromClass([self class])];
    //传递调用信息
    const char *ch = [debugInfo cStringUsingEncoding:NSUTF8StringEncoding];
    [anInvocation setArgument:&ch atIndex:2];
    [anInvocation invokeWithTarget:[Trash class]];
}

- (NSMethodSignature *)wd_methodSignatureForSelector:(SEL)aSelector {
    NSMethodSignature *sig = [Trash methodSignatureForSelector:NSSelectorFromString(@"trash")];
    return sig;
}

@end
