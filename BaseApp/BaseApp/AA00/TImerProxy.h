//
//  TImerProxy.h
//  BaseApp
//
//  Created by chenlina on 2025/4/5.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TImerProxy : NSProxy

+ (instancetype)proxyWihtTarget:(id)target;

@end

NS_ASSUME_NONNULL_END
