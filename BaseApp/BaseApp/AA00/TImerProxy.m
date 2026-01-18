//
//  TImerProxy.m
//  BaseApp
//
//  Created by chenlina on 2025/4/5.
//

#import "TImerProxy.h"

@interface TImerProxy()

@property(nonatomic, weak)id target;

@end

@implementation TImerProxy

+ (instancetype)proxyWihtTarget:(id)target {
    TImerProxy *p = [TImerProxy alloc];
    p.target = target;
    return p;
}

- (void)forwardInvocation:(NSInvocation *)invocation {
    [invocation invokeWithTarget:self.target];
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)sel {
    return [self.target methodSignatureForSelector:sel];
}

- (void)dealloc {
    NSLog(@"%s", __func__);
}

@end
