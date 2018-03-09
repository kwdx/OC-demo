//
//  Doctor.m
//  MessageForwarding
//
//  Created by warden on 2018/3/9.
//  Copyright © 2018年 warden. All rights reserved.
//

#import "Doctor.h"

@implementation Doctor

+ (BOOL)resolveClassMethod:(SEL)sel {
    return true;
}

+ (BOOL)resolveInstanceMethod:(SEL)sel {
    return [super resolveInstanceMethod:sel];
}

- (void)cure {
    NSLog(@"医生在救人");
}

@end
