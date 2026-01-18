//
//  BlockViewController.m
//  BaseApp
//
//  Created by chenlina on 2025/2/6.
//

#import "BlockViewController.h"
#import "YJPerson.h"

@interface BlockViewController ()

@end

@implementation BlockViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self test];
//    [self test2:^(int a) {
//        NSLog(@"%s", __func__);
//    }];
}

//

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    /// 3秒释放
    YJPerson *p = [[YJPerson alloc] init];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSLog(@"%@", p);
    });
    
    /// 3秒释放
    YJPerson *p2 = [[YJPerson alloc] init];
    __weak YJPerson *weakP2 = p2;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSLog(@"%@", weakP2);
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSLog(@"%@", p2);
        });
    });
    
    /// 1秒释放
    YJPerson *p3 = [[YJPerson alloc] init];
    __weak YJPerson *weakP3 = p3;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSLog(@"%@", p3);
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSLog(@"%@", weakP3);
        });
    });
}


//*******************************block 基础***************************************

- (void)test {
    __block int age =  10;
    void (^block)(int) = ^(int a){
        age = 20;
        NSLog(@"%d", age);
    };
    
    block(10);
    NSLog(@"%d", age);
    
    NSLog(@" %s %@ \n", __func__, [block class]);

}

- (void)test2:(void (^)(int)) block {
    NSLog(@" %s %@ \n", __func__, [[block copy] class]);
    
    
    __block int (^tb)(int);
    
    tb = ^(int a){
        if (a == 1) {
            return 1;
        }
        return a + tb(a - 1);
    };
}

//*******************************递归block***************************************

- (void)recurisonBlock {
    __block int (^testBlock)(int);
    
    testBlock = ^(int a) {
        if (a == 1) {
            return 1;
        }
        return a + testBlock(a - 1);
    };
    
    int sum = testBlock(100);
    NSLog(@"-----  %d ------", sum);
}

@end
