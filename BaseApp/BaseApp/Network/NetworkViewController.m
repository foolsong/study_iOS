//
//  NetworkViewController.m
//  BaseApp
//
//  Created by chenlina on 2025/4/7.
//

#import "NetworkViewController.h"

@interface NetworkViewController ()

@end

@implementation NetworkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self get];
    
    [self post];
}

- (void)get {
    // 1. 创建会话
    NSURLSession *session = [NSURLSession sharedSession];
    // 2. 创建任务
    NSURL *url = [NSURL URLWithString:@"https://www.baidu.com/"];

    NSURLSessionDataTask *task = [session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSLog(@"%@", [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]);
        // 打印解析后的json数据
        // NSLog(@"%@", [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil]);

    }];

    // 3. 执行任务
    [task resume];
}

- (void)post {
    // 1. 创建会话
    NSURLSession *session = [NSURLSession sharedSession];

    // 2. 创建任务
    NSURL *url = [NSURL URLWithString:@"https://www.baidu.com/"];

    // 创建请求对象里面包含请求体
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    request.HTTPBody = [@"username=myName&pwd=myPsd" dataUsingEncoding:NSUTF8StringEncoding];

    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
          
        NSLog(@"%@", [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]);
        // 打印解析后的json数据
        // NSLog(@"%@", [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil]);

    }];

    // 3. 执行任务
     [task resume];
}

@end
