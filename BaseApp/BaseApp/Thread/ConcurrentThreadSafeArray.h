//
//  ConcurrentThreadSafeArray.h
//  BaseApp
//
//  Created by chenlina on 2025/4/5.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ConcurrentThreadSafeArray : NSObject

@property (nonatomic, strong) NSMutableArray *array;
@property (nonatomic, strong) dispatch_queue_t concurrentQueue;

- (instancetype)init;
- (NSUInteger)count;
- (id)objectAtIndex:(NSUInteger)index;
- (void)addObject:(id)anObject;
- (void)insertObject:(id)anObject atIndex:(NSUInteger)index;
- (void)removeObjectAtIndex:(NSUInteger)index;
- (void)removeAllObjects;
- (void)replaceObjectAtIndex:(NSUInteger)index withObject:(id)anObject;

@end

NS_ASSUME_NONNULL_END
