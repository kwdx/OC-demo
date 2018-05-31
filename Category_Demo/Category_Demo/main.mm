//
//  main.m
//  Category_Demo
//
//  Created by warden on 2018/5/27.
//  Copyright © 2018年 warden. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Person.h"
#import <objc/runtime.h>

int main(int argc, const char * argv[]) {
    @autoreleasepool {
//        Person *p = [[Person alloc] init];
//        [p run];
        
        unsigned int count;
        Method *methods = class_copyMethodList([Person class], &count);
        for (int i=0; i<count; i++) {
            Method method = methods[i];
            NSLog(@"%@", NSStringFromSelector(method_getName(method)));
        }
        free(methods);
    }
    return 0;
}
