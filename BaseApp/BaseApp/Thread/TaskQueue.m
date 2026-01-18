//
//  TaskQueue.m
//  Test2
//
//  Created by yjsong on 2025/1/18.
//

#import "TaskQueue.h"

@interface TaskQueue()
@property (nonatomic, strong) dispatch_queue_t queue;  // 消费队列
@property (nonatomic, strong) NSMutableArray *tasks;   // 存储待处理的任务
@property (nonatomic, strong) NSMutableArray *cacheTasks; // 存储被缓存的任务
@property (nonatomic, strong) NSLock *taskLock;        // 锁保护任务数组
@property (nonatomic, assign) NSInteger maxTaskCount;  // 最大任务数量
@end

@implementation TaskQueue

- (instancetype)init {
    self = [super init];
    if (self) {
        _queue = dispatch_queue_create("com.myapp.taskQueue", DISPATCH_QUEUE_SERIAL);
        _tasks = [NSMutableArray array];
        _cacheTasks = [NSMutableArray array];  // 用于存储缓存的任务
        _taskLock = [[NSLock alloc] init];
        _maxTaskCount = 10;  // 设置最大任务数为10
    }
    return self;
}

- (void)addTask:(void(^)(void))task {
    [self.taskLock lock];
    
    // 如果队列已满，将任务添加到缓存队列
    if (self.tasks.count < self.maxTaskCount) {
        [self.tasks addObject:[task copy]];
    } else {
        [self.cacheTasks addObject:[task copy]];  // 如果队列满了，缓存任务
    }
    
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
                
                // 任务执行完后，检查缓存队列，恢复任务
                if (self.cacheTasks.count > 0) {
                    void (^cachedTask)(void) = [self.cacheTasks firstObject];
                    [self.cacheTasks removeObjectAtIndex:0];
                    [self.tasks addObject:cachedTask];  // 恢复缓存的任务
                }
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
        TaskQueue *taskQueue = [[TaskQueue alloc] init];
        
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
