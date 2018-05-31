//
//  Person+Test1.m
//  Category_Demo
//
//  Created by warden on 2018/5/27.
//  Copyright © 2018年 warden. All rights reserved.
//

#import "Person+Test1.h"

@implementation Person (Test1)
- (void)run {
    NSLog(@"categroy1 - run");
}
- (void)eat {
    NSLog(@"categroy1 - eat");
}
+ (void)battle {
    NSLog(@"categroy1 - battle");
}
- (nonnull id)copyWithZone:(nullable NSZone *)zone {
    return nil;
}

- (nonnull id)mutableCopyWithZone:(nullable NSZone *)zone {
    return nil;
}

@end
