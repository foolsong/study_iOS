//
//  TransformViewController.m
//  Test2
//
//  Created by yjsong on 2025/1/9.
//

#import "TransformViewController.h"

@interface TransformViewController ()

@property(nonatomic, strong) UIView *v1;
@property(nonatomic, strong) UIView *v1_1;
@property(nonatomic, strong) UIView *v2;

@end

@implementation TransformViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self addViews];
    [self printViews];
}

- (void)addViews {
    self.v1.frame = CGRectMake(100, 100, 60, 80);
    self.v1_1.frame = CGRectMake(20, 20, 50, 50);
    self.v2.frame = CGRectMake(28, 463, 240, 128);
    
    [self.view addSubview:self.v1];
    [self.v1 addSubview:self.v1_1];
    [self.view addSubview:self.v2];
}

- (void)printViews{
    NSLog(@"视图一");
    [self printView:self.v1];
    NSLog(@"视图二");
    [self printView:self.v1_1];
//    NSLog(@"视图三");
//    [self printView:self.v2];
    NSLog(@"************************************");
}
 
- (void)printView:(UIView*)view{
    NSLog(@"frame = %@",NSStringFromCGRect(view.frame));
    NSLog(@"Bounds = %@",NSStringFromCGRect(view.bounds));
    NSLog(@"Center = %@",NSStringFromCGPoint(view.center));
    
}
 
- (void)transform:(UIView*)view{
//    [view setTransform:CGAffineTransformRotate(CGAffineTransformIdentity, M_PI_2)];
    [view setTransform:CGAffineTransformMakeRotation(M_PI_2 * 0.5)];
    
    NSLog(@"旋转后 视图一");
    [self printView:self.v1];
    NSLog(@"旋转后 视图二");
    [self printView:self.v1_1];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self transform:_v1];
}


- (UIView *)v1 {
    if (!_v1) {
        _v1 = [[UIView alloc] init];
        [_v1 setBackgroundColor:[UIColor redColor]];
    }
    return _v1;
}

- (UIView *)v1_1 {
    if (!_v1_1) {
        _v1_1 = [[UIView alloc] init];
        [_v1_1 setBackgroundColor:[UIColor orangeColor]];
    }
    return _v1_1;
}

- (UIView *)v2 {
    if (!_v2) {
        _v2 = [[UIView alloc] init];
        [_v2 setBackgroundColor:[UIColor greenColor]];
    }
    return _v2;
}

@end
