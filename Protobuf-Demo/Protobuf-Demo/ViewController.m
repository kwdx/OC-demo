//
//  ViewController.m
//  Protobuf-Demo
//
//  Created by warden on 2019/2/21.
//  Copyright © 2019 warden. All rights reserved.
//

#import "ViewController.h"
#import "SimpleMessage.pbobjc.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    FooSimpleMessage *msg = [[FooSimpleMessage alloc] init];
    msg.msgId = 1;
    msg.msgContent = @"A protobuf message content";
    printf("%s\n", msg.description.UTF8String);
    NSData *data = msg.data;
    printf("%s\n", data.description.UTF8String);
    NSError *error;
    FooSimpleMessage *decodeMsg = [FooSimpleMessage parseFromData:data error:&error];
    if (!error) {
        printf("%s\n", decodeMsg.description.UTF8String);
    }
    
    error = nil;
    NSData *delimitedData = msg.delimitedData;
    printf("%s\n", delimitedData.description.UTF8String);
    GPBCodedInputStream *inputStream = [GPBCodedInputStream streamWithData:delimitedData];
    decodeMsg = [FooSimpleMessage parseDelimitedFromCodedInputStream:inputStream extensionRegistry:nil error:&error];
    if (!error) {
        printf("%s\n", decodeMsg.description.UTF8String);
    }
}


@end
