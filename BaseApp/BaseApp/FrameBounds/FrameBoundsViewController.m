//
//  TestOneViewController.m
//  Test2
//
//  Created by yjsong on 2025/1/8.
//

/**
 
 区别总结:
 frame:
 frame的位置是以父视图的坐标系为参照，从而确定当前视图在父视图中的位置。
 frame的大小改变时，当前视图的左上角位置不会发生改变，只是大小发生改变。

 bounds:
 bounds改变位置时，改变的是子视图的坐标系位置，自身没有影响；其实就是改变了本身的坐标系原点，默认本身坐标系的原点是左上角。
 bounds的大小改变时，当前视图的中心点不会发生改变，当前视图的大小发生改变，看起来效果就像缩放一样。

 
 */

#import "FrameBoundsViewController.h"

@interface FrameBoundsViewController ()

@property(nonatomic, strong) UIView *viewB;

@end

@implementation FrameBoundsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self setupView];
}

- (void)setupView {
    UIView *viewA = [[UIView alloc] initWithFrame:CGRectMake(50, 50, 300, 300)];
    [viewA setBackgroundColor:[UIColor blueColor]];
    [self.view addSubview:viewA];
    NSLog(@"viewA - %@",NSStringFromCGRect(viewA.frame));

    UIView *viewB = [[UIView alloc] initWithFrame:CGRectMake(50, 50, 200, 200)];
    [viewB setBackgroundColor:[UIColor yellowColor]];
    [viewA addSubview:viewB];
    NSLog(@"viewB - %@",NSStringFromCGRect(viewB.frame));

//    UIView *viewC = [[UIView alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
//    [viewC setBackgroundColor:[UIColor redColor]];
//    [self.view addSubview:viewC];
//    NSLog(@"viewC - %@",NSStringFromCGRect(viewC.frame));
    
    
    self.viewB = viewB;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSLog(@"修改前 viewB frame - %@",NSStringFromCGRect(self.viewB.frame));
    NSLog(@"修改前 viewB bounds - %@",NSStringFromCGRect(self.viewB.bounds));
    
    [self.viewB setBounds:CGRectMake(self.viewB.bounds.origin.x, self.viewB.bounds.origin.y, 100, 100)];
    
    NSLog(@"修改后 viewB frame - %@",NSStringFromCGRect(self.viewB.frame));
    NSLog(@"修改后 viewB bounds - %@",NSStringFromCGRect(self.viewB.bounds));
}

@end
