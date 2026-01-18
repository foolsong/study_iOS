//
//  ThreadViewController.m
//  Test2
//
//  Created by yjsong on 2025/1/9.
//

#import "ThreadViewController.h"

@interface ThreadViewController ()
@property(nonatomic, copy)NSString *name;
@end

@implementation ThreadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
//
//    
//    NSLog(@"执行任务1");
//    dispatch_queue_t queue = dispatch_queue_create("myQueue", DISPATCH_QUEUE_SERIAL);
//    dispatch_async(queue, ^{
////        sleep(2);
//        NSLog(@"执行任务2 %@", [NSThread currentThread]);
//        
//        dispatch_sync(queue, ^{
//            NSLog(@"执行任务4");;
//        });
//        NSLog(@"执行任务5");
//        
//    });
//    NSLog(@"执行任务8 %@", [NSThread currentThread]);
//    NSLog(@"执行任务8");
    
//    int i = 10;
//    dispatch_async(dispatch_get_main_queue(), ^{
//        NSLog(@"i %d", i);
//    });
//    i = 20;
//    
//    __block int j = 10;
//    dispatch_async(dispatch_get_main_queue(), ^{
//        NSLog(@"j %d", j);
//    });
//    j = 20;
//    
//    NSString *s = @"10";
//    dispatch_async(dispatch_get_main_queue(), ^{
//        NSLog(@"%@", s);
//    });
//    s = @"20";
    
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
        for (int i = 0; i < 1000; i++) {
        dispatch_async(queue, ^{
            self.name = [NSString stringWithFormat:@"abc"];
        });
    }
    

}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self interview08];
}

- (void)interview08 {
    NSThread *th = [[NSThread alloc] initWithBlock:^{
        NSLog(@"1");
        [[NSRunLoop currentRunLoop] addPort:[[NSPort alloc] init] forMode:NSDefaultRunLoopMode];
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }];
    
    [th start];
    
    [self performSelector:@selector(ttt) onThread:th withObject:nil waitUntilDone:YES];
    
}

- (void)interview01 {
 // 问题：以下代码是在主线程执行的，会不会产生死锁？会！
    NSLog(@"执行任务1");
    dispatch_queue_t queue = dispatch_get_main_queue();
    dispatch_sync(queue, ^{
        NSLog(@"执行任务2");
    });
    NSLog(@"执行任务3");
    // dispatch_sync立马在当前线程同步执行任务
}

- (void)interview02 {
    dispatch_queue_t queue = dispatch_queue_create("myQueue", DISPATCH_QUEUE_CONCURRENT);
    for (int i = 0; i < 100; i++) {
        dispatch_async(queue, ^{
            sleep(0.2);
            NSLog(@"%d", i);
        });
    }
    
    dispatch_async(queue, ^{
        //任务2
        
        NSLog(@"100");
    });

    dispatch_barrier_async(queue, ^{
        //珊栏
            NSLog(@"101");
    });
    
    dispatch_async(queue, ^{
        //任务3
        NSLog(@"102");
    });
}

- (void)interview03 {
    dispatch_queue_t queue = dispatch_queue_create("myQueue", DISPATCH_QUEUE_CONCURRENT);
    NSLog(@"1");
    dispatch_async(queue, ^{
        NSLog(@"2");
        dispatch_sync(queue, ^{
            NSLog(@"3");
            
        });
        NSLog(@"4");
    });
    NSLog(@"5");
}

- (void)interview03_02 {
    dispatch_queue_t queue = dispatch_queue_create("myQueue", DISPATCH_QUEUE_SERIAL);
    NSLog(@"1");
    dispatch_async(queue, ^{
        NSLog(@"2");
        dispatch_sync(queue, ^{
            NSLog(@"3");
            
        });
        NSLog(@"4");
    });
    NSLog(@"5");
}

- (void)interview04 {
    dispatch_queue_t queue = dispatch_get_main_queue();
    for (int i = 0; i < 20; i++) {
        dispatch_async(queue, ^{
            NSLog(@"%d", i);
        });
    }
    
    dispatch_async(queue, ^{
        //任务2
        NSLog(@"20");
    });

    dispatch_barrier_async(queue, ^{
        //珊栏
            NSLog(@"21");
    });
    
    dispatch_async(queue, ^{
        //任务3
        NSLog(@"22");
    });
}

- (void)interview05 {
    dispatch_queue_t queue = dispatch_queue_create("myQueue", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(queue, ^{
        NSLog(@"1");
        [self performSelector:@selector(ttt)
                   withObject:nil
                   afterDelay:.0];
        NSLog(@"2");
    });
    
}

- (void)interview05_1 {
    dispatch_queue_t queue = dispatch_queue_create("myQueue", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(queue, ^{
        NSLog(@"1");
        [self performSelector:@selector(ttt)
                   withObject:nil
                   afterDelay:.0];
        NSLog(@"2");
        [[NSRunLoop currentRunLoop] addPort:[[NSPort alloc] init] forMode:NSDefaultRunLoopMode];
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    });
    
}

- (void)interview06 {
    dispatch_queue_t queue = dispatch_get_main_queue();
    dispatch_async(queue, ^{
        NSLog(@"%@",[NSThread currentThread]);
        NSLog(@"1");
        [self performSelector:@selector(ttt)
                   withObject:nil
                   afterDelay:3];
        NSLog(@"2");
    });
}

- (void)ttt {
    NSLog(@"3");
}

- (void)test1 {
    NSLog(@"1 %@", [NSThread currentThread]);
}

- (void)test2 {
    NSLog(@"2 %@", [NSThread currentThread]);
}

- (void)test3 {
    NSLog(@"3 %@", [NSThread currentThread]);
}

- (void)interview07 {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(NSEC_PER_SEC * 0)), dispatch_get_main_queue(),^{
        NSLog(@"4 %@", [NSThread currentThread]);
    });
    
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"5 %@", [NSThread currentThread]);
    });
    
    [self performSelector:@selector(test2)];
    [self performSelector:@selector(test3) withObject:nil afterDelay:0];
    
    for (int i = 0; i < 1; i++) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
            NSLog(@"6 %d %@", i, [NSThread currentThread]);
        });
    }
    
    [self test1];
}


@end
