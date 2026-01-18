//
//  ConcurrentThreadSafeArray.m
//  BaseApp
//
//  Created by chenlina on 2025/4/5.
//

#import "ConcurrentThreadSafeArray.h"

@implementation ConcurrentThreadSafeArray

- (instancetype)init {
    self = [super init];
    if (self) {
        _array = [NSMutableArray array];
        _concurrentQueue = dispatch_queue_create("com.example.ConcurrentThreadSafeArray", DISPATCH_QUEUE_CONCURRENT);
    }
    return self;
}

- (NSUInteger)count {
    __block NSUInteger count;
    dispatch_sync(_concurrentQueue, ^{
        count = self.array.count;
    });
    return count;
}

- (id)objectAtIndex:(NSUInteger)index {
    __block id object;
    dispatch_sync(_concurrentQueue, ^{
        if (index < [self.array count]) {
            object = [self.array objectAtIndex:index];
        }
    });
    return object;
}

- (void)addObject:(id)anObject {
    dispatch_barrier_async(_concurrentQueue, ^{
        [self.array addObject:anObject];
    });
}

- (void)insertObject:(id)anObject atIndex:(NSUInteger)index {
    dispatch_barrier_async(_concurrentQueue, ^{
        if (index <= [self.array count]) {
            [self.array insertObject:anObject atIndex:index];
        }
    });
}

- (void)removeObjectAtIndex:(NSUInteger)index {
    dispatch_barrier_async(_concurrentQueue, ^{
        if (index < [self.array count]) {
            [self.array removeObjectAtIndex:index];
        }
    });
}

- (void)removeAllObjects {
    dispatch_barrier_async(_concurrentQueue, ^{
        [self.array removeAllObjects];
    });
}

- (void)replaceObjectAtIndex:(NSUInteger)index withObject:(id)anObject {
    dispatch_barrier_async(_concurrentQueue, ^{
        if (index < [self.array count]) {
            [self.array replaceObjectAtIndex:index withObject:anObject];
        }
    });
}

@end
