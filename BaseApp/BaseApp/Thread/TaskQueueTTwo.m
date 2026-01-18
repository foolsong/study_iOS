//
//  TaskQueue2.m
//  Test2
//
//  Created by yjsong on 2025/1/18.
//

#import "TaskQueueTTwo.h"

@interface TaskQueueTTwo()
@property (nonatomic, strong) dispatch_queue_t queue;  // 消费队列
@property (nonatomic, strong) NSMutableArray *tasks;   // 存储待处理的任务
@property (nonatomic, strong) NSLock *taskLock;        // 锁保护任务数组
@property (nonatomic, assign) NSInteger maxTaskCount;  // 最大任务数量
@property (nonatomic, strong) dispatch_semaphore_t semaphore; // 信号量，用于限制任务队列大小
@end

@implementation TaskQueueTTwo

- (instancetype)init {
    self = [super init];
    if (self) {
        _queue = dispatch_queue_create("com.myapp.taskQueue", DISPATCH_QUEUE_SERIAL);
        _tasks = [NSMutableArray array];
        _taskLock = [[NSLock alloc] init];
        _maxTaskCount = 10;  // 设置最大任务数为10
        _semaphore = dispatch_semaphore_create(_maxTaskCount);  // 初始化信号量
    }
    return self;
}

- (void)addTask:(void(^)(void))task {
    // 等待信号量，确保不会超过最大任务数
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    
    [self.taskLock lock];
    [self.tasks addObject:[task copy]];
    [self.taskLock unlock];
}

- (void)startProcessing {
    dispatch_async(self.queue, ^{
        while (true) {
            [self.taskLock lock];
            if (self.tasks.count > 0) {
                // 获取队列中的第一个任务
                void (^task)(void) = [self.tasks firstObject];
                [self.tasks removeObjectAtIndex:0];
                [self.taskLock unlock];
                
                // 执行任务
                task();
                
                // 完成任务后，释放一个信号量，表示队列有一个空位
                dispatch_semaphore_signal(self.semaphore);
            } else {
                [self.taskLock unlock];
                // 队列为空，休眠等待任务
                [NSThread sleepForTimeInterval:1.0];
            }
            
        }
    });
}

@end

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        TaskQueueTTwo *taskQueue = [[TaskQueueTTwo alloc] init];

        // 尝试添加超过10个任务的情况
        for (int i = 0; i < 15; i++) {
            [taskQueue addTask:^{
                NSLog(@"Task %d: Doing some work...", i + 1);
                [NSThread sleepForTimeInterval:2.0];  // 模拟任务处理时间
                NSLog(@"Task %d: Done.", i + 1);
            }];
            NSLog(@"Task %d added to queue.", i + 1);
        }
        
        // 开始消费队列中的任务
        [taskQueue startProcessing];
        
        // 等待任务执行完毕
        [[NSRunLoop currentRunLoop] run];
    }
    return 0;
}
