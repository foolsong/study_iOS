//
//  ViewController.m
//  DomeLineView
//
//  Created by 宋永建 on 17/3/27.
//  Copyright © 2017年 宋永建. All rights reserved.
//

#import "ViewController.h"
#import "LineDemoView.h"

#define CIRCLE_SIZE 14.0

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated {
    [self lineDeomo];
}

- (void)lineDeomo {
    LineDemoView *lineView = [[LineDemoView alloc]  init];
    [lineView setBackgroundColor:[UIColor grayColor]];
    lineView.frame = self.view.bounds;
    [self.view addSubview:lineView];
}
@end
