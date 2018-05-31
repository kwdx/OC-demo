//
//  Person+Test1.h
//  Category_Demo
//
//  Created by warden on 2018/5/27.
//  Copyright © 2018年 warden. All rights reserved.
//

#import "Person.h"

@interface Person (Test1) <NSCopying, NSMutableCopying>
@property (nonatomic, strong) NSString *smallName;
- (void)run;
- (void)eat;
+ (void)battle;
@end
