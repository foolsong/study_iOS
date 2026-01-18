//
//  SafeLockArray.m
//  Test2
//
//  Created by yjsong on 2025/1/18.
//

#import "SafeLockArray.h"
@interface SafeLockArray ()

@property(nonatomic, strong)NSMutableArray *array;
@property(nonatomic, strong)NSLock *lock;


@end

@implementation SafeLockArray

- (void)addArrayObject:(NSObject *)object {
    [self.lock lock];
    [self.array addObject:object];
    [self.lock unlock];
}

- (void)removeObjectFromArrayAtIndex:(NSUInteger)index {
    [self.lock lock];
    [self.array removeObjectAtIndex:index];
    [self.lock unlock];
}

- (NSObject *)getObjectAtIndex:(NSUInteger)index {
    [self.lock lock];
    NSObject *object = [self.array objectAtIndex:index];
    [self.lock unlock];
    return object;
}

- (NSMutableArray *)array {
    if(!_array){
        _array = [NSMutableArray array];
    }
    return _array;
}

- (NSLock *)lock {
    if(!_lock){
        _lock = [[NSLock alloc] init];
    }
    return _lock;
}

@end
