//
//  LianXiViewController.m
//  BaseApp
//
//  Created by chenlina on 2025/4/5.
//

#import "LianXiViewController.h"
#import "TImerProxy.h"

@interface LianXiViewController ()

@end

@implementation LianXiViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button setTitle:@"点击我" forState:UIControlStateNormal];
    button.frame = CGRectMake(100, 100, 200, 50);

    [button addTarget:self
               action:@selector(buttonTapped:)
     forControlEvents:UIControlEventTouchUpInside];

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    tap.cancelsTouchesInView = NO; 
    [button addGestureRecognizer:tap];
    
    [self.view addSubview:button];
}

// 按钮点击事件处理方法
- (void)buttonTapped:(UIButton *)sender {
    NSLog(@"按钮被点击了");
}




// 手势处理方法
- (void)handleTap:(UITapGestureRecognizer *)recognizer {
    NSLog(@"手势识别按钮点击");
}



- (void)dealloc {
    NSLog(@"%s", __func__);

}

@end
