//
//  LXThreadSafeArray.m
//  BaseApp
//
//  Created by chenlina on 2025/4/5.
//

#import "LXThreadSafeArray.h"

@interface  LXThreadSafeArray(){
}

@property(nonatomic, strong)NSMutableArray *array;
@property(nonatomic, strong)dispatch_queue_t queue;


@end

@implementation LXThreadSafeArray

- (instancetype)init {
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)addObject:(id)object; {
    dispatch_barrier_async(self.queue, ^{
        [self.array addObject:object];
    });
}

- (void)insertObject:(id)object atIndex:(NSUInteger)index {
    dispatch_barrier_async(self.queue, ^{
        [self.array insertObject:object atIndex:index];
    });
}

- (void)removeLastObject {
    dispatch_barrier_async(self.queue, ^{
        [self.array removeLastObject];
    });
}
- (void)removeObjectAtIndex:(NSUInteger)index {
    dispatch_barrier_async(self.queue, ^{
        [self.array removeObjectAtIndex:index];
    });
}

- (id)objectAtIndex:(NSUInteger)index {
    __block id object;
    dispatch_sync(self.queue, ^{
        object = [self.array objectAtIndex:index];
    });
    return object;
}

- (dispatch_queue_t)queue {
    if (!_queue) {
        _queue = dispatch_queue_create("LXThreadSafeArray", DISPATCH_QUEUE_CONCURRENT);
    }
    return _queue;
}

- (NSMutableArray *)array {
    if (!_array) {
        _array = [NSMutableArray array];
    }
    return _array;
}

@end
