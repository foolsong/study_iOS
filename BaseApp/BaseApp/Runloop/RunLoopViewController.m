//
//  RunLoopViewController.m
//  Test2
//
//  Created by yjsong on 2025/1/16.
//

#import "RunLoopViewController.h"
#import "YJThread.h"
#import "KeepLiveThread.h"

@interface RunLoopViewController ()

@property(nonatomic, strong) YJThread *thread;  

@property(nonatomic, assign) BOOL isStoped;

@property (nonatomic, strong) UIButton *myButton;
@property (nonatomic, strong) KeepLiveThread *keepLiveThread;
@end

@implementation RunLoopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isStoped = NO;
//    [self keepLive];
//    
//    [self addButton];
    self.keepLiveThread = [[KeepLiveThread alloc] init];
    [self.keepLiveThread run];
}

- (void)dealloc {
//    [self stop];
    [self.keepLiveThread stop];
    NSLog(@"%s", __func__);
}

- (void)test {
    NSLog(@"%s   %@", __func__, [NSThread currentThread]);
}

//*******************  线程保活  ***********************************
- (void)keepLive {
    __weak typeof(self) weakSelf = self;
    self.thread = [[YJThread alloc] initWithBlock:^{
        NSLog(@"%s   %@", __func__, [NSThread currentThread]);
        [[NSRunLoop currentRunLoop] addPort:[[NSPort alloc] init] forMode:NSDefaultRunLoopMode];
        while (weakSelf && !weakSelf.isStoped) {
            [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
        }
        NSLog(@"%s   %@", __func__, @"end");
    }];
//    self.thread = [[YJThread alloc] initWithTarget:self selector:@selector(run) object:nil];
    [self.thread start];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    [self performSelector:@selector(test) onThread:self.thread withObject:nil waitUntilDone:YES];
    [self.keepLiveThread task:^{
        NSLog(@"%s   %@", __func__, [NSThread currentThread]);;
    }];
//    NSLog(@"%s   %@", __func__, [NSThread currentThread]);
    
    
}


- (void)run {
    NSLog(@"%s   %@", __func__, [NSThread currentThread]);
    [[NSRunLoop currentRunLoop] addPort:[[NSPort alloc] init] forMode:NSDefaultRunLoopMode];
    [[NSRunLoop currentRunLoop] run];
    NSLog(@"%s   %@", __func__, @"end");
}

- (void)stop {
    [self performSelector:@selector(stopTheard) onThread:self.thread withObject:nil waitUntilDone:YES];
}

- (void)stopTheard {
    if (self.thread == nil) {
        return;
    }
    self.isStoped = YES;;
    CFRunLoopStop(CFRunLoopGetCurrent());
    
    NSLog(@"%s   %@", __func__, [NSThread currentThread]);
    self.thread = nil;
}

- (void)addButton {
    self.myButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.myButton.frame = CGRectMake(100, 200, 200, 50);
    [self.myButton setTitle:@"点击我" forState:UIControlStateNormal];
    
    self.myButton.backgroundColor = [UIColor lightGrayColor];
    
    [self.myButton addTarget:self
                      action:@selector(buttonClicked:)
            forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.myButton];
}

- (void)buttonClicked:(UIButton *)sender {
    NSLog(@"按钮被点击了");
    
    [self performSelector:@selector(stopTheard) onThread:self.thread withObject:nil waitUntilDone:YES];
}

@end
