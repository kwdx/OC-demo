//
//  main.m
//  MessageForwarding
//
//  Created by warden on 2018/3/9.
//  Copyright © 2018年 warden. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Teacher.h"
#import "Doctor.h"
#import <objc/message.h>

int main(int argc, const char * argv[]) {
    
#pragma mark - 第一种
//    Person *p = [[Person alloc] init];
//    [p eat];      // 我在吃饭
//    [p run];      // 我在跑步
//    Teacher *t = (Teacher *)p;
//    [t teach];    // 这是c语言的teach函数 -- Person
//    t = [[Teacher alloc] init];
//    [t teach];    // Teacher在教书
    
//    Doctor *d = [[Doctor alloc] init];
//    Teacher *t = (Teacher *)d;
//    [t teach];      // 这是c语言的teach函数 -- Doctor
    
//    [Person battle];    // 这是c语言的battle函数 -- Person
//    [Teacher battle];   // 这是c语言的battle函数 -- Teacher
//    [Doctor battle];    // 这是c语言的battle函数 -- Doctor

#pragma mark - 第二种
//    Person *p = [[Person alloc] init];
//    Teacher *t = (Teacher *)p;
//    [t teach];          // Teacher在教书
//    Doctor *d = (Doctor *)p;
//    [d cure];           // 医生在救人
//    [p performSelector:NSSelectorFromString(@"unknowMethod")];  // signal SIGABRT
    
//    [Teacher battle];   // signal SIGABRT
    
    
#pragma mark - 第三种
    Person *p = [[Person alloc] init];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
    [p performSelector:@selector(suicide)];
    [p performSelector:@selector(killOtherPerson)];
    [p performSelector:@selector(whatIsThisMethod:) withObject:@"sadas"];
#pragma clang diagnostic pop

    
    return 0;
}
