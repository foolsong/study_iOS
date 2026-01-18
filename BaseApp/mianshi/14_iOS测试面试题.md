# iOS测试面试题详解

## 1. 单元测试（Unit Testing）

### 问题：什么是单元测试？如何在iOS中实现？

**答案详解：**

单元测试是对代码中最小可测试单元进行验证的测试方法。

#### 1.1 基本单元测试
```objc
#import <XCTest/XCTest.h>
#import "Calculator.h"

@interface CalculatorTests : XCTestCase

@property (nonatomic, strong) Calculator *calculator;

@end

@implementation CalculatorTests

- (void)setUp {
    [super setUp];
    self.calculator = [[Calculator alloc] init];
}

- (void)tearDown {
    self.calculator = nil;
    [super tearDown];
}

- (void)testAddition {
    // Given
    NSInteger a = 5;
    NSInteger b = 3;
    
    // When
    NSInteger result = [self.calculator add:a to:b];
    
    // Then
    XCTAssertEqual(result, 8, @"5 + 3 应该等于 8");
}

- (void)testSubtraction {
    // Given
    NSInteger a = 10;
    NSInteger b = 4;
    
    // When
    NSInteger result = [self.calculator subtract:b from:a];
    
    // Then
    XCTAssertEqual(result, 6, @"10 - 4 应该等于 6");
}

- (void)testMultiplication {
    // Given
    NSInteger a = 6;
    NSInteger b = 7;
    
    // When
    NSInteger result = [self.calculator multiply:a by:b];
    
    // Then
    XCTAssertEqual(result, 42, @"6 * 7 应该等于 42");
}

- (void)testDivision {
    // Given
    NSInteger a = 20;
    NSInteger b = 5;
    
    // When
    NSInteger result = [self.calculator divide:a by:b];
    
    // Then
    XCTAssertEqual(result, 4, @"20 / 5 应该等于 4");
}

- (void)testDivisionByZero {
    // Given
    NSInteger a = 10;
    NSInteger b = 0;
    
    // When & Then
    XCTAssertThrows([self.calculator divide:a by:b], @"除以零应该抛出异常");
}

@end
```

#### 1.2 异步测试
```objc
@interface AsyncTests : XCTestCase

@end

@implementation AsyncTests

- (void)testAsyncOperation {
    // Given
    XCTestExpectation *expectation = [self expectationWithDescription:@"异步操作完成"];
    
    // When
    [self performAsyncOperationWithCompletion:^(NSString *result, NSError *error) {
        // Then
        XCTAssertNil(error, @"不应该有错误");
        XCTAssertNotNil(result, @"结果不应该为空");
        XCTAssertEqualObjects(result, @"成功", @"结果应该是'成功'");
        
        [expectation fulfill];
    }];
    
    // 等待异步操作完成
    [self waitForExpectationsWithTimeout:5.0 handler:^(NSError *error) {
        if (error) {
            XCTFail(@"异步操作超时: %@", error);
        }
    }];
}

- (void)performAsyncOperationWithCompletion:(void(^)(NSString *result, NSError *error))completion {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 模拟网络请求
        [NSThread sleepForTimeInterval:1.0];
        
        if (completion) {
            completion(@"成功", nil);
        }
    });
}

@end
```

#### 1.3 Mock对象测试
```objc
@interface MockNetworkService : NSObject

@property (nonatomic, strong) NSArray *mockData;
@property (nonatomic, assign) BOOL shouldFail;

- (void)fetchDataWithCompletion:(void(^)(NSArray *data, NSError *error))completion;

@end

@implementation MockNetworkService

- (void)fetchDataWithCompletion:(void(^)(NSArray *data, NSError *error))completion {
    if (self.shouldFail) {
        NSError *error = [NSError errorWithDomain:@"MockError" code:1001 userInfo:nil];
        completion(nil, error);
    } else {
        completion(self.mockData, nil);
    }
}

@end

@interface DataManagerTests : XCTestCase

@property (nonatomic, strong) DataManager *dataManager;
@property (nonatomic, strong) MockNetworkService *mockNetworkService;

@end

@implementation DataManagerTests

- (void)setUp {
    [super setUp];
    
    self.mockNetworkService = [[MockNetworkService alloc] init];
    self.mockNetworkService.mockData = @[@"Item 1", @"Item 2", @"Item 3"];
    
    self.dataManager = [[DataManager alloc] init];
    self.dataManager.networkService = self.mockNetworkService;
}

- (void)testSuccessfulDataFetch {
    // Given
    XCTestExpectation *expectation = [self expectationWithDescription:@"数据获取成功"];
    
    // When
    [self.dataManager fetchDataWithCompletion:^(NSArray *data, NSError *error) {
        // Then
        XCTAssertNil(error, @"不应该有错误");
        XCTAssertNotNil(data, @"数据不应该为空");
        XCTAssertEqual(data.count, 3, @"应该有3个数据项");
        
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:5.0 handler:nil];
}

- (void)testFailedDataFetch {
    // Given
    self.mockNetworkService.shouldFail = YES;
    XCTestExpectation *expectation = [self expectationWithDescription:@"数据获取失败"];
    
    // When
    [self.dataManager fetchDataWithCompletion:^(NSArray *data, NSError *error) {
        // Then
        XCTAssertNotNil(error, @"应该有错误");
        XCTAssertNil(data, @"数据应该为空");
        
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:5.0 handler:nil];
}

@end
```

## 2. UI测试（UI Testing）

### 问题：什么是UI测试？如何在iOS中实现？

**答案详解：**

UI测试是对用户界面进行自动化测试的方法。

#### 2.1 基本UI测试
```objc
#import <XCTest/XCTest.h>

@interface UITests : XCTestCase

@property (nonatomic, strong) XCUIApplication *app;

@end

@implementation UITests

- (void)setUp {
    [super setUp];
    
    self.continueAfterFailure = NO;
    self.app = [[XCUIApplication alloc] init];
    [self.app launch];
}

- (void)testLoginFlow {
    // 查找用户名输入框
    XCUIElement *usernameField = self.app.textFields[@"用户名"];
    XCTAssertTrue(usernameField.exists, @"用户名输入框应该存在");
    
    // 输入用户名
    [usernameField tap];
    [usernameField typeText:@"testuser"];
    
    // 查找密码输入框
    XCUIElement *passwordField = self.app.secureTextFields[@"密码"];
    XCTAssertTrue(passwordField.exists, @"密码输入框应该存在");
    
    // 输入密码
    [passwordField tap];
    [passwordField typeText:@"testpass"];
    
    // 查找登录按钮
    XCUIElement *loginButton = self.app.buttons[@"登录"];
    XCTAssertTrue(loginButton.exists, @"登录按钮应该存在");
    
    // 点击登录按钮
    [loginButton tap];
    
    // 验证登录成功后的界面
    XCUIElement *welcomeLabel = self.app.staticTexts[@"欢迎回来"];
    XCTAssertTrue(welcomeLabel.exists, @"登录成功后应该显示欢迎信息");
}

- (void)testTableInteraction {
    // 查找表格
    XCUIElement *table = self.app.tables.firstMatch;
    XCTAssertTrue(table.exists, @"表格应该存在");
    
    // 获取表格行数
    NSInteger rowCount = table.cells.count;
    XCTAssertGreaterThan(rowCount, 0, @"表格应该有数据行");
    
    // 点击第一行
    XCUIElement *firstCell = table.cells.firstMatch;
    [firstCell tap];
    
    // 验证详情页面
    XCUIElement *detailLabel = self.app.staticTexts[@"详情"];
    XCTAssertTrue(detailLabel.exists, @"应该显示详情页面");
}

@end
```

#### 2.2 手势测试
```objc
@interface GestureTests : XCTestCase

@property (nonatomic, strong) XCUIApplication *app;

@end

@implementation GestureTests

- (void)setUp {
    [super setUp];
    
    self.continueAfterFailure = NO;
    self.app = [[XCUIApplication alloc] init];
    [self.app launch];
}

- (void)testSwipeGesture {
    // 查找可滑动的视图
    XCUIElement *scrollView = self.app.scrollViews.firstMatch;
    XCTAssertTrue(scrollView.exists, @"滚动视图应该存在");
    
    // 向上滑动
    [scrollView swipeUp];
    
    // 向下滑动
    [scrollView swipeDown];
    
    // 向左滑动
    [scrollView swipeLeft];
    
    // 向右滑动
    [scrollView swipeRight];
}

- (void)testPinchGesture {
    // 查找图片视图
    XCUIElement *imageView = self.app.images.firstMatch;
    XCTAssertTrue(imageView.exists, @"图片视图应该存在");
    
    // 双指捏合（缩小）
    [imageView pinchWithScale:0.5 velocity:1.0];
    
    // 双指张开（放大）
    [imageView pinchWithScale:2.0 velocity:1.0];
}

- (void)testLongPressGesture {
    // 查找长按目标
    XCUIElement *targetElement = self.app.buttons[@"长按目标"];
    XCTAssertTrue(targetElement.exists, @"长按目标应该存在");
    
    // 长按
    [targetElement pressForDuration:2.0];
    
    // 验证长按后的操作
    XCUIElement *contextMenu = self.app.menus.firstMatch;
    XCTAssertTrue(contextMenu.exists, @"长按后应该显示上下文菜单");
}

@end
```

## 3. 性能测试（Performance Testing）

### 问题：如何进行iOS应用性能测试？

**答案详解：**

#### 3.1 性能测试基础
```objc
@interface PerformanceTests : XCTestCase

@end

@implementation PerformanceTests

- (void)testArrayPerformance {
    [self measureBlock:^{
        // 测试数组操作性能
        NSMutableArray *array = [NSMutableArray array];
        
        for (int i = 0; i < 10000; i++) {
            [array addObject:@(i)];
        }
        
        // 测试查找性能
        NSInteger index = [array indexOfObject:@(5000)];
        XCTAssertEqual(index, 5000, @"应该找到正确的索引");
    }];
}

- (void)testStringConcatenationPerformance {
    [self measureBlock:^{
        // 测试字符串拼接性能
        NSMutableString *result = [NSMutableString string];
        
        for (int i = 0; i < 1000; i++) {
            [result appendFormat:@"Item %d, ", i];
        }
        
        XCTAssertGreaterThan(result.length, 0, @"结果字符串不应该为空");
    }];
}

- (void)testImageProcessingPerformance {
    [self measureBlock:^{
        // 测试图片处理性能
        UIImage *image = [UIImage imageNamed:@"test_image"];
        XCTAssertNotNil(image, @"测试图片应该存在");
        
        // 模拟图片处理
        CGSize newSize = CGSizeMake(100, 100);
        UIGraphicsBeginImageContext(newSize);
        [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
        UIImage *resizedImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        XCTAssertNotNil(resizedImage, @"处理后的图片不应该为空");
    }];
}

@end
```

#### 3.2 内存泄漏测试
```objc
@interface MemoryLeakTests : XCTestCase

@end

@implementation MemoryLeakTests

- (void)testMemoryLeak {
    // 记录初始内存使用
    NSInteger initialMemory = [self getMemoryUsage];
    
    // 执行可能泄漏内存的操作
    for (int i = 0; i < 1000; i++) {
        @autoreleasepool {
            NSMutableArray *array = [NSMutableArray array];
            for (int j = 0; j < 100; j++) {
                [array addObject:[NSString stringWithFormat:@"Item %d-%d", i, j]];
            }
        }
    }
    
    // 强制垃圾回收
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    
    // 记录最终内存使用
    NSInteger finalMemory = [self getMemoryUsage];
    
    // 验证内存使用是否合理
    NSInteger memoryIncrease = finalMemory - initialMemory;
    XCTAssertLessThan(memoryIncrease, 10 * 1024 * 1024, @"内存增加不应该超过10MB");
}

- (NSInteger)getMemoryUsage {
    struct task_basic_info info;
    mach_msg_type_number_t size = TASK_BASIC_INFO_COUNT;
    kern_return_t kerr = task_info(mach_task_self(), TASK_BASIC_INFO, (task_info_t)&info, &size);
    
    if (kerr == KERN_SUCCESS) {
        return info.resident_size;
    }
    
    return 0;
}

@end
```

## 4. 测试驱动开发（TDD）

### 问题：什么是测试驱动开发？如何在iOS中实践？

**答案详解：**

#### 4.1 TDD基本流程
```objc
// 第一步：编写失败的测试
@interface TDDFibonacciTests : XCTestCase

@end

@implementation TDDFibonacciTests

- (void)testFibonacciOfZero {
    NSInteger result = [self fibonacci:0];
    XCTAssertEqual(result, 0, @"fibonacci(0) 应该等于 0");
}

- (void)testFibonacciOfOne {
    NSInteger result = [self fibonacci:1];
    XCTAssertEqual(result, 1, @"fibonacci(1) 应该等于 1");
}

- (void)testFibonacciOfTwo {
    NSInteger result = [self fibonacci:2];
    XCTAssertEqual(result, 1, @"fibonacci(2) 应该等于 1");
}

- (void)testFibonacciOfThree {
    NSInteger result = [self fibonacci:3];
    XCTAssertEqual(result, 2, @"fibonacci(3) 应该等于 2");
}

- (void)testFibonacciOfFour {
    NSInteger result = [self fibonacci:4];
    XCTAssertEqual(result, 3, @"fibonacci(4) 应该等于 3");
}

- (void)testFibonacciOfFive {
    NSInteger result = [self fibonacci:5];
    XCTAssertEqual(result, 5, @"fibonacci(5) 应该等于 5");
}

// 第二步：实现最小代码使测试通过
- (NSInteger)fibonacci:(NSInteger)n {
    if (n <= 1) {
        return n;
    }
    return [self fibonacci:n-1] + [self fibonacci:n-2];
}

@end
```

#### 4.2 TDD重构示例
```objc
@interface TDDCalculatorTests : XCTestCase

@property (nonatomic, strong) Calculator *calculator;

@end

@implementation TDDCalculatorTests

- (void)setUp {
    [super setUp];
    self.calculator = [[Calculator alloc] init];
}

- (void)testCalculatorInitialization {
    XCTAssertNotNil(self.calculator, @"计算器应该被正确初始化");
}

- (void)testCalculatorAddition {
    NSInteger result = [self.calculator add:5 to:3];
    XCTAssertEqual(result, 8, @"5 + 3 应该等于 8");
}

- (void)testCalculatorSubtraction {
    NSInteger result = [self.calculator subtract:3 from:10];
    XCTAssertEqual(result, 7, @"10 - 3 应该等于 7");
}

- (void)testCalculatorMultiplication {
    NSInteger result = [self.calculator multiply:6 by:7];
    XCTAssertEqual(result, 42, @"6 * 7 应该等于 42");
}

- (void)testCalculatorDivision {
    NSInteger result = [self.calculator divide:20 by:5];
    XCTAssertEqual(result, 4, @"20 / 5 应该等于 4");
}

- (void)testCalculatorDivisionByZero {
    XCTAssertThrows([self.calculator divide:10 by:0], @"除以零应该抛出异常");
}

@end

// 实现Calculator类
@interface Calculator : NSObject

- (NSInteger)add:(NSInteger)a to:(NSInteger)b;
- (NSInteger)subtract:(NSInteger)b from:(NSInteger)a;
- (NSInteger)multiply:(NSInteger)a by:(NSInteger)b;
- (NSInteger)divide:(NSInteger)a by:(NSInteger)b;

@end

@implementation Calculator

- (NSInteger)add:(NSInteger)a to:(NSInteger)b {
    return a + b;
}

- (NSInteger)subtract:(NSInteger)b from:(NSInteger)a {
    return a - b;
}

- (NSInteger)multiply:(NSInteger)a by:(NSInteger)b {
    return a * b;
}

- (NSInteger)divide:(NSInteger)a by:(NSInteger)b {
    if (b == 0) {
        [NSException raise:@"DivisionByZeroException" format:@"除数不能为零"];
    }
    return a / b;
}

@end
```

## 总结

iOS测试是确保应用质量的重要手段，包括：

1. **单元测试**：测试代码的最小可测试单元
2. **UI测试**：测试用户界面的交互和功能
3. **性能测试**：测试应用的性能和内存使用
4. **测试驱动开发**：先写测试，再写代码的开发方法

掌握这些测试技术可以帮助创建更加稳定、可靠的iOS应用。
