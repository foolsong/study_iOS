//
//  KeepLiveThread.m
//  BaseApp
//
//  Created by chenlina on 2025/2/11.
//

#import "KeepLiveThread.h"

#import "YJThread.h"

@interface KeepLiveThread ()

@property(nonatomic, strong) YJThread *thread;
@property(nonatomic, assign) BOOL isStoped;

@end

@implementation KeepLiveThread

- (instancetype)init {
    self = [super init];
    if (self) {
        self.isStoped = NO;
        typeof(self) weakSelf = self;
        self.thread = [[YJThread alloc] initWithBlock:^{
            [[NSRunLoop currentRunLoop] addPort:[[NSPort alloc] init] forMode:NSDefaultRunLoopMode];
            while (weakSelf && !weakSelf.isStoped) {
                [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
            }
        }];
    }
    return self;
}

// 开始线程
- (void)run {
    [self.thread start];
}

// 执行任务
- (void)task:(id)target action:(SEL) action object:(id)object{}

- (void)task:(TaskBlock)task {
    
    if (!self.thread || !task) {
        return;
    }
    [self performSelector:@selector(__extask:) onThread:self.thread withObject:task waitUntilDone:NO];
}

- (void)__extask:(TaskBlock)task{
    task();
}

// 结束线程
- (void)stop {
    if (!self.thread) {
        return;
    }
    [self performSelector:@selector(stopThread) onThread:self.thread withObject:nil waitUntilDone:YES];
}

- (void)stopThread {
    self.isStoped = YES;
    CFRunLoopStop(CFRunLoopGetCurrent());
    self.thread = nil;
}

- (void)dealloc {
    NSLog(@"%s", __func__);
}

@end
