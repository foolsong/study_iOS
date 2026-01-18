//
//  GCDViewController.m
//  Test2
//
//  Created by yjsong on 2025/1/18.
//

#import "GCDViewController.h"

@interface GCDViewController ()

@end

@implementation GCDViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self inter02];
}

- (void)inter {
    // 创建队列组
    dispatch_group_t group = dispatch_group_create();
    // 创建并发队列
    dispatch_queue_t queue = dispatch_queue_create("my_queue", DISPATCH_QUEUE_CONCURRENT);
    
    // 添加异步任务
    dispatch_group_async(group, queue, ^{
        for (int i = 0; i < 5; i++) {
            NSLog(@"任务1-%@", [NSThread currentThread]);
        }
    });
    
    dispatch_group_async(group, queue, ^{
        for (int i = 0; i < 5; i++) {
            NSLog(@"任务2-%@", [NSThread currentThread]);
        }
    });
    
    // 等前面的任务执行完毕后，会自动执行这个任务
    //    dispatch_group_notify(group, queue, ^{
    //        dispatch_async(dispatch_get_main_queue(), ^{
    //            for (int i = 0; i < 5; i++) {
    //                NSLog(@"任务3-%@", [NSThread currentThread]);
    //            }
    //        });
    //    });
    
    //    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
    //        for (int i = 0; i < 5; i++) {
    //            NSLog(@"任务3-%@", [NSThread currentThread]);
    //        }
    //    });
    
    dispatch_group_notify(group, queue, ^{
        for (int i = 0; i < 5; i++) {
            NSLog(@"任务3-%@", [NSThread currentThread]);
        }
    });
    
    dispatch_group_notify(group, queue, ^{
        for (int i = 0; i < 5; i++) {
            NSLog(@"任务4-%@", [NSThread currentThread]);
        }
    });
}


- (void)inter02 {
    dispatch_queue_t queue = dispatch_queue_create("myQueue", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(queue, ^{
        sleep(2);
        NSLog(@"1");
    });
    
    dispatch_async(queue, ^{
        sleep(2);
        NSLog(@"2");
    });
    
    dispatch_async(queue, ^{
        sleep(2);
        NSLog(@"3");
    });
    
    dispatch_barrier_async(queue, ^{
        NSLog(@"4");
    });
    
}


- (void)inter03{
//    dispatch_semaphore_create(<#intptr_t value#>)
}

@end
