//
//  KeepLiveThread.h
//  BaseApp
//
//  Created by chenlina on 2025/2/11.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^TaskBlock)(void) ;

@interface KeepLiveThread : NSObject

// 开始线程
- (void)run;

// 执行任务
- (void)task:(id)target action:(SEL) action object:(id)object;

- (void)task:(TaskBlock)task;

// 结束线程
- (void)stop;

@end

NS_ASSUME_NONNULL_END
