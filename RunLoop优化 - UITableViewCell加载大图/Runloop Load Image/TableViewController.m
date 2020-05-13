//
//  TableViewController.m
//  Runloop Load Image
//
//  Created by warden on 2018/3/12.
//  Copyright © 2018年 warden. All rights reserved.
//

#import "TableViewController.h"
#import "ImageCell.h"

// 定义一个block
typedef void(^RunloopBlock)(void);

@interface TableViewController ()
{
    CFRunLoopObserverRef _defaulModeObserver;
}

/// 定时器
@property (nonatomic, strong) NSTimer *timer;
/// 任务队列
@property (nonatomic, strong) NSMutableArray *tasks;
/// 最大任务数
@property (nonatomic, assign) NSUInteger maxQueueLength;

@end

@implementation TableViewController

- (void)timerMethod {
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.type == 1) {
        // 创建观察者
        // 拿到当前的runloop
        CFRunLoopRef runloop = CFRunLoopGetCurrent();
        // 定义一个上下文
        CFRunLoopObserverContext context = {0, (__bridge void *)(self), NULL, NULL, NULL};
        // 创建一个观察者
        _defaulModeObserver  = CFRunLoopObserverCreate(NULL, kCFRunLoopBeforeWaiting, YES, 0, &Callback, &context);
        CFRunLoopAddObserver(runloop, _defaulModeObserver, kCFRunLoopCommonModes);
        CFRelease(runloop);
        
        self.maxQueueLength = 51;
        self.tasks = [NSMutableArray array];
        // 让runloop一直转起来
        self.timer = [NSTimer scheduledTimerWithTimeInterval:0.0001 target:self selector:@selector(timerMethod) userInfo:nil repeats:YES];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    // 添加观察者到runloop中
    if (_defaulModeObserver) {
        CFRunLoopAddObserver(CFRunLoopGetMain(), _defaulModeObserver, kCFRunLoopCommonModes);
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if (self.type == 1 && _defaulModeObserver) {
        // 移除观察者
        CFRunLoopRemoveObserver(CFRunLoopGetMain(), _defaulModeObserver, kCFRunLoopCommonModes);
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    /// 移除所有未执行的操作
    [self.tasks removeAllObjects];
    /// 暂停定时器
    [self.timer invalidate];
    self.timer = nil;
}

- (void)dealloc {
    if (_defaulModeObserver != NULL) {
        // 释放观察者
        CFRelease(_defaulModeObserver);
        _defaulModeObserver = NULL;
    }
    NSLog(@"%s", __func__);
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1000;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ImageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"imagecell" forIndexPath:indexPath];
    NSInteger row = indexPath.row;
    cell.imageView1.image = nil;
    cell.imageView2.image = nil;
    cell.imageView3.image = nil;
    
    switch (self.type) {
        case 0:
        {
            // 普通加载
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                UIImage *image1 = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@((row+1)%3).stringValue ofType:@"jpg"]];
                dispatch_async(dispatch_get_main_queue(), ^{
                    cell.imageView1.image = image1;
                });
            });
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                UIImage *image2 = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@((row+2)%3).stringValue ofType:@"jpg"]];
                dispatch_async(dispatch_get_main_queue(), ^{
                    cell.imageView2.image = image2;
                });
            });
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                UIImage *image3 = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@(row%3).stringValue ofType:@"jpg"]];
                dispatch_async(dispatch_get_main_queue(), ^{
                    cell.imageView3.image = image3;
                });
            });
        }
            break;
        case 1:
        {
            // runloop
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                UIImage *img = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@(row%3).stringValue ofType:@"jpg"]];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self addTask:^{
                        cell.imageView1.image = img;
                    }];
                });
            });
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                UIImage *img = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@((row+1)%3).stringValue ofType:@"jpg"]];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self addTask:^{
                        cell.imageView2.image = img;
                    }];
                });
            });
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                UIImage *img = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@((row+2)%3).stringValue ofType:@"jpg"]];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self addTask:^{
                        cell.imageView3.image = img;
                    }];
                });
            });
        }
            break;
        default:
            break;
    }
    
    return cell;
}

- (void)addTask:(RunloopBlock)task {
    // 将代码块添加到可变数组中
    [self.tasks addObject:task];
    // 判断当前待执行的代码块是否超出最大代码块数
    if (self.tasks.count > self.maxQueueLength) {
        // 干掉最开始的代码块
        [self.tasks removeObjectAtIndex:0];
    }
}

#pragma mark - Runloop 优化

static void Callback(CFRunLoopObserverRef observer, CFRunLoopActivity activity, void *info) {
    TableViewController *vc = (__bridge TableViewController *)info;
    if (vc.tasks.count == 0) {
        return;
    }
    
    RunloopBlock task = vc.tasks.firstObject;
    task();
    [vc.tasks removeObjectAtIndex:0];
}

@end
