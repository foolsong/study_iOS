//
//  ViewController.m
//  Test2
//
//  Created by yjsong on 2025/1/8.
//

#import "ViewController.h"
#import "FrameBoundsViewController.h"
#import "ThreadViewController.h"
#import "NotificationViewController.h"
#import "TransformViewController.h"

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>

@property(nonatomic, copy) NSArray *titleList;
@property(nonatomic, copy) NSArray *vcList;

@property(nonatomic, strong) FrameBoundsViewController * vc;
@property(nonatomic, strong) UITableView *tableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addTableView];
    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        UIViewController *vc = [[NSClassFromString(@"NetworkViewController") alloc] init];
//        [vc setTitle:@"练习"];
//        [self.navigationController pushViewController:vc animated:YES];
//    });
    
    
}

- (void)addTableView {
    [self.view addSubview:self.tableView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.titleList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%@", self.titleList[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *vcName = self.vcList[indexPath.row];
    UIViewController *vc = [[NSClassFromString(vcName) alloc] init];
    [vc setTitle:self.titleList[indexPath.row]];
    
    [self.navigationController pushViewController:vc animated:YES];
    
//    if ([title isEqualToString:@"frame && bounds"]) {
//        [self.navigationController pushViewController:[[FrameBoundsViewController alloc] init] animated:YES];
//    } else if ([title isEqualToString:@"Transform"]) {
//        [self.navigationController pushViewController:[[TransformViewController alloc] init] animated:YES];
//    } else if ([title isEqualToString:@"死锁"]) {
//        [self.navigationController pushViewController:[[ThreadViewController alloc] init] animated:YES];
//    } else if ([title isEqualToString:@"Notification"]) {
//        [self.navigationController pushViewController:[[NotificationViewController alloc] init] animated:YES];
//    }
         
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
 
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];

        _tableView.dataSource = self;
        _tableView.delegate = self;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    }
    return _tableView;
}
- (FrameBoundsViewController *)vc {
    if(!_vc) {
        _vc = [[FrameBoundsViewController alloc] init];
    }
    return _vc;
}

- (NSArray *)titleList {
    if (!_titleList) {
        _titleList = @[@"frame && bounds",
                       @"Transform" ,
                       @"线程",
                       @"GCD",
                       @"Runloop",
                       @"Runloop优化应用",
                       @"Notification",
                       @"线程锁",
                       @"公共父类",
                       @"Block",
                       @"网络",
                       @"练习"
                       ];
    }
    return _titleList;
}

- (NSArray *)vcList{
    if(!_vcList) {
        _vcList = @[@"FrameBoundsViewController",
                    @"TransformViewController",
                    @"ThreadViewController",
                    @"GCDViewController",
                    @"RunLoopViewController",
                    @"RunLoopUsingViewController",
                    @"NotificationViewController",
                    @"LockViewController",
                    @"FindSuperViewVC",
                    @"BlockViewController",
                    @"NetworkViewController",
                    @"LianXiViewController"];
    }
    return _vcList;
}

@end
