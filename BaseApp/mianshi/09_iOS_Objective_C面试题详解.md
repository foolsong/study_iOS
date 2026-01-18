# iOS Objective-C面试题详解

## 1. Objective-C基础语法

### 问题：Objective-C的基本语法特点是什么？

**答案详解：**

Objective-C是C语言的超集，在C语言基础上添加了面向对象编程的特性。

#### 1.1 类声明和实现

**类声明语法：**
```objc
// 导入头文件
#import <Foundation/Foundation.h>

// 类声明
@interface Person : NSObject

// 属性声明
@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) NSInteger age;

// 实例方法声明
- (void)sayHello;
+ (void)printClassName;

@end
```

**类实现语法：**
```objc
// 类实现
@implementation Person

- (void)sayHello {
    // 实例方法实现
    NSString *greeting = [NSString stringWithFormat:@"Hello, my name is %@ and I am %ld years old", self.name, (long)self.age];
}

+ (void)printClassName {
    // 类方法实现
    NSString *className = NSStringFromClass([self class]);
}

@end
```

#### 1.2 消息传递机制

**消息发送语法：**
```objc
// 基本消息发送
[object method];

// 带参数的消息发送
[object methodWithParameter:value];

// 嵌套消息发送
[[object method1] method2];

// 链式调用
[[[object method1] method2] method3];
```

**方法调用示例：**
```objc
Person *person = [[Person alloc] init];
[person setName:@"John"];
[person setAge:25];
[person sayHello];
```

## 2. 内存管理

### 问题：Objective-C中如何管理内存？

**答案详解：**

#### 2.1 MRC（Manual Reference Counting）

**MRC内存管理规则：**
- 谁创建，谁释放
- 谁持有，谁释放
- 引用计数为0时自动释放

**MRC实现示例：**
```objc
@interface MRCExample : NSObject

@property (nonatomic, retain) NSString *name;

@end

@implementation MRCExample

- (void)setName:(NSString *)name {
    if (_name != name) {
        [_name release];        // 释放旧值
        _name = [name retain];  // 持有新值
    }
}

- (void)dealloc {
    [_name release];           // 释放属性
    [super dealloc];           // 调用父类dealloc
}

@end
```

**MRC使用场景：**
- 需要精确控制内存
- 与C++代码混合
- 特殊的内存管理需求

#### 2.2 ARC（Automatic Reference Counting）

**ARC内存管理关键字：**
- **strong**：强引用，引用计数+1
- **weak**：弱引用，引用计数不变
- **assign**：赋值，不改变引用计数
- **copy**：复制，引用计数+1

**ARC实现示例：**
```objc
@interface ARCExample : NSObject

@property (nonatomic, strong) NSString *strongProperty;
@property (nonatomic, weak) NSString *weakProperty;
@property (nonatomic, assign) NSInteger assignProperty;
@property (nonatomic, copy) NSString *copyProperty;

@end

@implementation ARCExample

- (void)demonstrateARC {
    // strong引用（默认）
    self.strongProperty = @"Strong Reference";
    
    // weak引用（不会增加引用计数）
    __weak NSString *weakString = self.strongProperty;
    
    // assign引用（用于基本数据类型）
    self.assignProperty = 42;
    
    // copy引用（创建对象的副本）
    self.copyProperty = @"Copy Reference";
}

@end
```

**ARC优势：**
- 自动内存管理
- 减少内存泄漏
- 提高开发效率
- 代码更简洁

## 3. Runtime系统

### 问题：什么是Runtime？如何使用？

**答案详解：**

Runtime是Objective-C的动态运行时系统，提供了在运行时动态创建类、添加方法、修改属性等功能。

#### 3.1 Runtime基础功能

**获取类信息：**
```objc
#import <objc/runtime.h>

@interface RuntimeExample : NSObject

@end

@implementation RuntimeExample

- (void)demonstrateRuntime {
    // 获取类信息
    Class class = [self class];
    const char *className = class_getName(class);
    
    // 获取属性列表
    unsigned int propertyCount;
    objc_property_t *properties = class_copyPropertyList(class, &propertyCount);
    
    for (unsigned int i = 0; i < propertyCount; i++) {
        objc_property_t property = properties[i];
        const char *propertyName = property_getName(property);
        // 处理属性信息
    }
    
    free(properties);
}

@end
```

**动态添加方法：**
```objc
// 动态方法的实现
void dynamicMethodIMP(id self, SEL _cmd) {
    // 动态方法的具体实现
}

// 动态添加方法
class_addMethod([self class], @selector(dynamicMethod), (IMP)dynamicMethodIMP, "v@:");
```

#### 3.2 Runtime应用场景

**方法交换（Method Swizzling）：**
```objc
// 交换两个方法的实现
Method originalMethod = class_getInstanceMethod([self class], @selector(originalMethod));
Method swizzledMethod = class_getInstanceMethod([self class], @selector(swizzledMethod));

method_exchangeImplementations(originalMethod, swizzledMethod);
```

**关联对象（Associated Objects）：**
```objc
// 设置关联对象
objc_setAssociatedObject(self, "key", value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);

// 获取关联对象
id value = objc_getAssociatedObject(self, "key");
```

## 4. KVC和KVO

### 问题：什么是KVC和KVO？如何使用？

**答案详解：**

#### 4.1 KVC（Key-Value Coding）

**KVC基本概念：**
- 通过字符串键访问对象属性
- 支持点语法和路径访问
- 自动类型转换

**KVC使用示例：**
```objc
@interface Person : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) NSInteger age;

@end

@implementation Person
@end

// KVC使用
Person *person = [[Person alloc] init];

// 设置值
[person setValue:@"John" forKey:@"name"];
[person setValue:@25 forKey:@"age"];

// 获取值
NSString *name = [person valueForKey:@"name"];
NSNumber *age = [person valueForKey:@"age"];

// 路径访问
[person setValue:@"New York" forKeyPath:@"address.city"];
```

#### 4.2 KVO（Key-Value Observing）

**KVO基本概念：**
- 观察对象属性变化
- 自动通知观察者
- 支持选项配置

**KVO使用示例：**
```objc
@interface Observer : NSObject
@end

@implementation Observer

- (void)observeValueForKeyPath:(NSString *)keyPath 
                      ofObject:(id)object 
                        change:(NSDictionary<NSKeyValueChangeKey,id> *)change 
                       context:(void *)context {
    
    if ([keyPath isEqualToString:@"name"]) {
        NSString *oldValue = change[NSKeyValueChangeOldKey];
        NSString *newValue = change[NSKeyValueChangeNewKey];
        // 处理name属性变化
    }
}

@end

// 添加观察者
Person *person = [[Person alloc] init];
Observer *observer = [[Observer alloc] init];

[person addObserver:observer 
         forKeyPath:@"name" 
            options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld 
            context:nil];

// 移除观察者
[person removeObserver:observer forKeyPath:@"name"];
```

## 5. 类别和扩展

### 问题：什么是类别和扩展？如何使用？

**答案详解：**

#### 5.1 类别（Category）

**类别概念：**
- 为现有类添加新方法
- 不能添加新属性
- 可以覆盖现有方法

**类别实现：**
```objc
// 为NSString添加新方法
@interface NSString (Utilities)

- (NSString *)reversedString;
- (BOOL)isPalindrome;

@end

@implementation NSString (Utilities)

- (NSString *)reversedString {
    NSMutableString *reversed = [NSMutableString string];
    for (NSInteger i = self.length - 1; i >= 0; i--) {
        [reversed appendString:[self substringWithRange:NSMakeRange(i, 1)]];
    }
    return reversed;
}

- (BOOL)isPalindrome {
    NSString *reversed = [self reversedString];
    return [self isEqualToString:reversed];
}

@end
```

#### 5.2 扩展（Extension）

**扩展概念：**
- 声明私有属性和方法
- 在.m文件中实现
- 限制访问权限

**扩展实现：**
```objc
// 在.m文件顶部
@interface Person ()
@property (nonatomic, strong) NSString *privateProperty;
- (void)privateMethod;
@end

@implementation Person

- (void)privateMethod {
    // 私有方法实现
}

@end
```

## 6. 协议（Protocol）

### 问题：什么是协议？如何使用？

**答案详解：**

#### 6.1 协议基础

**协议概念：**
- 定义方法接口
- 支持可选和必需方法
- 实现多继承效果

**协议定义：**
```objc
@protocol DataSource <NSObject>

@required
- (NSInteger)numberOfItems;
- (id)itemAtIndex:(NSInteger)index;

@optional
- (void)didSelectItem:(id)item;
- (BOOL)canEditItem:(id)item;

@end
```

#### 6.2 协议使用

**协议实现：**
```objc
@interface DataManager : NSObject <DataSource>

@end

@implementation DataManager

- (NSInteger)numberOfItems {
    return 10;
}

- (id)itemAtIndex:(NSInteger)index {
    return [NSString stringWithFormat:@"Item %ld", (long)index];
}

@end
```

**协议作为类型：**
```objc
@interface TableView : NSObject

@property (nonatomic, weak) id<DataSource> dataSource;

@end
```

## 7. 块（Block）

### 问题：什么是Block？如何使用？

**答案详解：**

#### 7.1 Block基础

**Block概念：**
- 匿名函数对象
- 可以捕获外部变量
- 支持异步编程

**Block语法：**
```objc
// Block声明
typedef void(^CompletionBlock)(BOOL success, id result);

// Block定义
void (^simpleBlock)(void) = ^{
    // Block实现
};

// 带参数的Block
void (^parameterBlock)(NSString *message) = ^(NSString *message) {
    // 处理message参数
};

// 带返回值的Block
NSString *(^returnBlock)(NSString *input) = ^NSString *(NSString *input) {
    return [input uppercaseString];
};
```

#### 7.2 Block使用

**Block作为参数：**
```objc
@interface NetworkManager : NSObject

- (void)requestWithCompletion:(void(^)(BOOL success, id result))completion;

@end

@implementation NetworkManager

- (void)requestWithCompletion:(void(^)(BOOL success, id result))completion {
    // 网络请求逻辑
    
    if (completion) {
        completion(YES, @"请求成功");
    }
}

@end

// 使用Block
NetworkManager *manager = [[NetworkManager alloc] init];
[manager requestWithCompletion:^(BOOL success, id result) {
    if (success) {
        // 处理成功结果
    } else {
        // 处理失败结果
    }
}];
```

**Block内存管理：**
```objc
// 避免循环引用
__weak typeof(self) weakSelf = self;
[manager requestWithCompletion:^(BOOL success, id result) {
    __strong typeof(weakSelf) strongSelf = weakSelf;
    if (strongSelf) {
        [strongSelf handleResult:result];
    }
}];
```

## 8. 多线程和并发

### 问题：Objective-C中如何实现多线程？

**答案详解：**

#### 8.1 GCD（Grand Central Dispatch）

**GCD基本概念：**
- 系统级线程管理
- 自动线程池管理
- 支持同步和异步执行

**GCD使用示例：**
```objc
// 主队列（串行）
dispatch_async(dispatch_get_main_queue(), ^{
    // 主线程任务，通常用于UI更新
});

// 全局队列（并发）
dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    // 后台任务
});

// 延迟执行
dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    // 2秒后执行
});

// 一次性执行
static dispatch_once_t onceToken;
dispatch_once(&onceToken, ^{
    // 只执行一次的代码
});

// 组操作
dispatch_group_t group = dispatch_group_create();
dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    // 任务1
});
dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    // 任务2
});
dispatch_group_notify(group, dispatch_get_main_queue(), ^{
    // 所有任务完成后执行
});
```

#### 8.2 NSOperation和NSOperationQueue

**NSOperation概念：**
- 面向对象的多线程编程
- 支持依赖关系
- 可以取消和暂停

**NSOperation使用：**
```objc
// 创建操作
NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
    // 操作实现
}];

// 设置完成回调
operation.completionBlock = ^{
    // 操作完成后的回调
};

// 创建队列
NSOperationQueue *queue = [[NSOperationQueue alloc] init];
queue.maxConcurrentOperationCount = 3; // 最大并发数

// 添加操作到队列
[queue addOperation:operation];

// 设置依赖关系
NSBlockOperation *operation1 = [NSBlockOperation blockOperationWithBlock:^{
    // 操作1
}];
NSBlockOperation *operation2 = [NSBlockOperation blockOperationWithBlock:^{
    // 操作2
}];

[operation2 addDependency:operation1]; // operation2依赖operation1
[queue addOperation:operation1];
[queue addOperation:operation2];
```

## 9. 通知（Notification）

### 问题：什么是通知？如何使用？

**答案详解：**

#### 9.1 通知基础

**通知概念：**
- 一对多的消息传递机制
- 松耦合的通信方式
- 支持用户信息传递

**通知使用：**
```objc
@interface NotificationExample : NSObject

@end

@implementation NotificationExample

- (void)setupNotifications {
    // 添加观察者
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                           selector:@selector(handleNotification:) 
                                               name:@"CustomNotification" 
                                             object:nil];
}

- (void)handleNotification:(NSNotification *)notification {
    // 处理通知
    NSString *name = notification.name;
    id object = notification.object;
    NSDictionary *userInfo = notification.userInfo;
}

- (void)postNotification {
    // 发送通知
    [[NSNotificationCenter defaultCenter] postNotificationName:@"CustomNotification" 
                                                        object:self 
                                                      userInfo:@{@"key": @"value"}];
}

- (void)dealloc {
    // 移除观察者
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
```

## 10. 错误处理

### 问题：Objective-C中如何处理错误？

**答案详解：**

#### 10.1 NSError使用

**错误处理模式：**
```objc
@interface ErrorExample : NSObject

- (BOOL)performOperationWithError:(NSError **)error;

@end

@implementation ErrorExample

- (BOOL)performOperationWithError:(NSError **)error {
    // 检查操作是否成功
    BOOL success = [self checkOperation];
    
    if (!success && error != NULL) {
        // 创建错误对象
        *error = [NSError errorWithDomain:@"CustomErrorDomain" 
                                     code:1001 
                                 userInfo:@{NSLocalizedDescriptionKey: @"操作失败"}];
        return NO;
    }
    
    return YES;
}

- (BOOL)checkOperation {
    // 检查操作逻辑
    return NO;
}

@end

// 使用错误处理
ErrorExample *example = [[ErrorExample alloc] init];
NSError *error = nil;

BOOL success = [example performOperationWithError:&error];
if (!success) {
    // 处理错误
    NSString *errorMessage = error.localizedDescription;
}
```

#### 10.2 异常处理

**异常处理语法：**
```objc
@try {
    // 可能抛出异常的代码
    [self riskyOperation];
} @catch (NSException *exception) {
    // 捕获异常
    NSString *name = exception.name;
    NSString *reason = exception.reason;
    NSDictionary *userInfo = exception.userInfo;
} @finally {
    // 总是执行的代码
    [self cleanup];
}
```

## 总结

Objective-C是iOS开发的基础语言，掌握其核心概念对于iOS开发至关重要：

1. **基础语法**：类声明、消息传递、属性管理
2. **内存管理**：MRC和ARC的区别和使用
3. **Runtime系统**：动态特性、方法交换、关联对象
4. **KVC/KVO**：键值编码和观察者模式
5. **类别和扩展**：扩展现有类功能
6. **协议**：接口定义和多继承
7. **Block**：匿名函数和异步编程
8. **多线程**：GCD和NSOperation的使用
9. **通知**：消息传递机制
10. **错误处理**：NSError和异常处理

掌握这些知识点可以帮助开发者：
- 深入理解iOS系统原理
- 编写高质量的Objective-C代码
- 解决复杂的iOS开发问题
- 为Swift开发打下坚实基础
