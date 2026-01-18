# iOS设计模式面试题详解

## 1. 单例模式（Singleton Pattern）

### 问题：什么是单例模式？如何在iOS中实现？

**答案详解：**

#### 1.1 单例模式概念

**定义：**
- 确保一个类只有一个实例
- 提供全局访问点
- 控制实例的创建和访问

**使用场景：**
- 全局配置管理
- 网络管理器
- 数据管理器
- 日志记录器

#### 1.2 实现方式

**Objective-C实现：**
```objc
@interface NetworkManager : NSObject

+ (instancetype)sharedManager;
- (void)startRequest;

@end

@implementation NetworkManager

+ (instancetype)sharedManager {
    static NetworkManager *instance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        instance = [[NetworkManager alloc] init];
    });
    
    return instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        // 初始化代码
    }
    return self;
}

- (void)startRequest {
    // 网络请求逻辑
}

@end
```

**Swift实现：**
```swift
class NetworkManager {
    static let shared = NetworkManager()
    
    private init() {
        // 私有初始化方法
    }
    
    func startRequest() {
        // 网络请求逻辑
    }
}
```

#### 1.3 优缺点分析

**优点：**
- 保证全局唯一实例
- 节省内存资源
- 便于全局访问

**缺点：**
- 可能造成内存泄漏
- 测试困难
- 违反单一职责原则

## 2. 工厂模式（Factory Pattern）

### 问题：什么是工厂模式？有哪些类型？

**答案详解：**

#### 2.1 简单工厂模式

**概念：**
- 通过工厂类创建对象
- 隐藏对象创建细节
- 统一管理对象创建

**实现示例：**
```objc
@interface Product : NSObject
- (void)use;
@end

@interface ProductA : Product
@end

@interface ProductB : Product
@end

@interface SimpleFactory : NSObject
+ (Product *)createProduct:(NSString *)type;
@end

@implementation SimpleFactory

+ (Product *)createProduct:(NSString *)type {
    if ([type isEqualToString:@"A"]) {
        return [[ProductA alloc] init];
    } else if ([type isEqualToString:@"B"]) {
        return [[ProductB alloc] init];
    }
    return nil;
}

@end
```

#### 2.2 工厂方法模式

**概念：**
- 定义创建对象的接口
- 让子类决定实例化类
- 延迟实例化到子类

**实现示例：**
```objc
@protocol ProductFactory <NSObject>
- (Product *)createProduct;
@end

@interface ProductAFactory : NSObject <ProductFactory>
@end

@interface ProductBFactory : NSObject <ProductFactory>
@end

@implementation ProductAFactory
- (Product *)createProduct {
    return [[ProductA alloc] init];
}
@end

@implementation ProductBFactory
- (Product *)createProduct {
    return [[ProductB alloc] init];
}
@end
```

## 3. 观察者模式（Observer Pattern）

### 问题：什么是观察者模式？iOS中有哪些实现？

**答案详解：**

#### 3.1 观察者模式概念

**定义：**
- 定义对象间一对多依赖关系
- 当对象状态改变时通知观察者
- 松耦合的设计模式

**使用场景：**
- 数据模型变化通知
- 用户界面更新
- 事件处理
- 状态同步

#### 3.2 iOS中的实现

**NSNotificationCenter：**
```objc
@interface NewsPublisher : NSObject
- (void)publishNews:(NSString *)news;
@end

@implementation NewsPublisher

- (void)publishNews:(NSString *)news {
    // 发布新闻
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NewsPublished" 
                                                        object:self 
                                                      userInfo:@{@"news": news}];
}

@end

@interface NewsSubscriber : NSObject
@end

@implementation NewsSubscriber

- (instancetype)init {
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self 
                                               selector:@selector(handleNews:) 
                                                   name:@"NewsPublished" 
                                                 object:nil];
    }
    return self;
}

- (void)handleNews:(NSNotification *)notification {
    NSString *news = notification.userInfo[@"news"];
    // 处理新闻
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
```

**KVO (Key-Value Observing)：**
```objc
@interface StockModel : NSObject
@property (nonatomic, strong) NSString *currentPrice;
@end

@implementation StockModel
@end

@interface StockObserver : NSObject
@end

@implementation StockObserver

- (void)observeStock:(StockModel *)stock {
    [stock addObserver:self 
            forKeyPath:@"currentPrice" 
               options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld 
               context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath 
                      ofObject:(id)object 
                        change:(NSDictionary<NSKeyValueChangeKey,id> *)change 
                       context:(void *)context {
    if ([keyPath isEqualToString:@"currentPrice"]) {
        NSString *newPrice = change[NSKeyValueChangeNewKey];
        // 处理价格变化
    }
}

- (void)dealloc {
    // 移除观察者
}

@end
```

## 4. 代理模式（Delegate Pattern）

### 问题：什么是代理模式？如何实现？

**答案详解：**

#### 4.1 代理模式概念

**定义：**
- 为其他对象提供代理控制访问
- 在访问对象时引入一定程度的间接性
- 控制对对象的访问

**使用场景：**
- 网络请求回调
- 用户交互处理
- 数据传递
- 事件处理

#### 4.2 实现示例

**定义代理协议：**
```objc
@protocol DownloadDelegate <NSObject>

@required
- (void)downloadDidStart;
- (void)downloadDidFinish:(id)result;
- (void)downloadDidFail:(NSError *)error;

@optional
- (void)downloadProgress:(float)progress;

@end

@interface DownloadManager : NSObject

@property (nonatomic, weak) id<DownloadDelegate> delegate;

- (void)startDownload;

@end

@implementation DownloadManager

- (void)startDownload {
    // 通知代理下载开始
    if ([self.delegate respondsToSelector:@selector(downloadDidStart)]) {
        [self.delegate downloadDidStart];
    }
    
    // 模拟下载过程
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 下载逻辑
        
        // 通知代理下载完成
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([self.delegate respondsToSelector:@selector(downloadDidFinish:)]) {
                [self.delegate downloadDidFinish:@"下载完成"];
            }
        });
    });
}

@end
```

## 5. 策略模式（Strategy Pattern）

### 问题：什么是策略模式？如何应用？

**答案详解：**

#### 5.1 策略模式概念

**定义：**
- 定义算法族，分别封装起来
- 让它们之间可以互相替换
- 算法的变化不会影响使用算法的客户

**使用场景：**
- 支付方式选择
- 排序算法选择
- 压缩算法选择
- 验证策略选择

#### 5.2 实现示例

**支付策略：**
```objc
@protocol PaymentStrategy <NSObject>
- (void)pay:(NSDecimalNumber *)amount;
@end

@interface CreditCardPayment : NSObject <PaymentStrategy>
@end

@interface PayPalPayment : NSObject <PaymentStrategy>
@end

@interface CashPayment : NSObject <PaymentStrategy>
@end

@implementation CreditCardPayment
- (void)pay:(NSDecimalNumber *)amount {
    // 信用卡支付逻辑
}
@end

@implementation PayPalPayment
- (void)pay:(NSDecimalNumber *)amount {
    // PayPal支付逻辑
}
@end

@implementation CashPayment
- (void)pay:(NSDecimalNumber *)amount {
    // 现金支付逻辑
}
@end

@interface PaymentContext : NSObject

@property (nonatomic, strong) id<PaymentStrategy> strategy;

- (void)executePayment:(NSDecimalNumber *)amount;

@end

@implementation PaymentContext

- (void)executePayment:(NSDecimalNumber *)amount {
    if (self.strategy) {
        [self.strategy pay:amount];
    } else {
        // 未选择支付策略
    }
}

@end
```

## 6. 适配器模式（Adapter Pattern）

### 问题：什么是适配器模式？有哪些类型？

**答案详解：**

#### 6.1 适配器模式概念

**定义：**
- 将一个类的接口转换成客户希望的另一个接口
- 使不兼容的接口可以一起工作
- 解决接口不兼容问题

**使用场景：**
- 第三方库集成
- 旧系统接口适配
- 不同数据格式转换
- 接口标准化

#### 6.2 类适配器

**概念：**
- 通过继承实现适配
- 同时继承目标类和适配者类
- 重写目标接口方法

**实现示例：**
```objc
@interface Target : NSObject
- (void)request;
@end

@interface Adaptee : NSObject
- (void)specificRequest;
@end

@interface ClassAdapter : Adaptee <Target>
@end

@implementation Target
- (void)request {
    // 目标接口
}
@end

@implementation Adaptee
- (void)specificRequest {
    // 被适配类的特定请求
}
@end

@implementation ClassAdapter
- (void)request {
    [self specificRequest];
}
@end
```

#### 6.3 对象适配器

**概念：**
- 通过组合实现适配
- 持有适配者对象引用
- 委托适配者执行操作

**实现示例：**
```objc
@interface ObjectAdapter : NSObject <Target>

@property (nonatomic, strong) Adaptee *adaptee;

- (instancetype)initWithAdaptee:(Adaptee *)adaptee;

@end

@implementation ObjectAdapter

- (instancetype)initWithAdaptee:(Adaptee *)adaptee {
    self = [super init];
    if (self) {
        _adaptee = adaptee;
    }
    return self;
}

- (void)request {
    [self.adaptee specificRequest];
}

@end
```

## 7. 装饰器模式（Decorator Pattern）

### 问题：什么是装饰器模式？如何实现？

**答案详解：**

#### 7.1 装饰器模式概念

**定义：**
- 动态地给对象添加额外的职责
- 不改变原对象结构
- 提供比继承更灵活的扩展方式

**使用场景：**
- UI组件装饰
- 功能扩展
- 权限控制
- 日志记录

#### 7.2 实现示例

**组件装饰：**
```objc
@protocol Component <NSObject>
- (void)operation;
@end

@interface ConcreteComponent : NSObject <Component>
@end

@interface Decorator : NSObject <Component>

@property (nonatomic, strong) id<Component> component;

- (instancetype)initWithComponent:(id<Component>)component;

@end

@interface ConcreteDecoratorA : Decorator
@end

@interface ConcreteDecoratorB : Decorator
@end

@implementation ConcreteComponent
- (void)operation {
    // 具体组件的操作
}
@end

@implementation Decorator
- (void)operation {
    [self.component operation];
}
@end

@implementation ConcreteDecoratorA
- (void)operation {
    [super operation];
    // 装饰器A的额外操作
}
@end

@implementation ConcreteDecoratorB
- (void)operation {
    [super operation];
    // 装饰器B的额外操作
}
@end
```

## 8. 命令模式（Command Pattern）

### 问题：什么是命令模式？如何应用？

**答案详解：**

#### 8.1 命令模式概念

**定义：**
- 将请求封装成对象
- 可以用不同的请求对客户进行参数化
- 对请求排队或记录请求日志

**使用场景：**
- 撤销/重做操作
- 宏命令
- 队列操作
- 日志记录

#### 8.2 实现示例

**命令模式实现：**
```objc
@protocol Command <NSObject>
- (void)execute;
- (void)undo;
@end

@interface ConcreteCommand : NSObject <Command>

@property (nonatomic, strong) id receiver;
@property (nonatomic, strong) NSString *action;

- (instancetype)initWithReceiver:(id)receiver action:(NSString *)action;

@end

@interface Invoker : NSObject

@property (nonatomic, strong) NSMutableArray<id<Command>> *commands;

- (void)addCommand:(id<Command>)command;
- (void)executeCommands;
- (void)undoLastCommand;

@end

@implementation ConcreteCommand

- (instancetype)initWithReceiver:(id)receiver action:(NSString *)action {
    self = [super init];
    if (self) {
        _receiver = receiver;
        _action = action;
    }
    return self;
}

- (void)execute {
    // 执行命令
}

- (void)undo {
    // 撤销命令
}

@end

@implementation Invoker

- (instancetype)init {
    self = [super init];
    if (self) {
        _commands = [NSMutableArray array];
    }
    return self;
}

- (void)addCommand:(id<Command>)command {
    [self.commands addObject:command];
}

- (void)executeCommands {
    for (id<Command> command in self.commands) {
        [command execute];
    }
}

- (void)undoLastCommand {
    id<Command> lastCommand = [self.commands lastObject];
    if (lastCommand) {
        [lastCommand undo];
        [self.commands removeLastObject];
    }
}

@end
```

## 总结

iOS设计模式是构建高质量应用的重要基础，包括：

1. **创建型模式**：单例、工厂等，负责对象创建
2. **结构型模式**：适配器、装饰器等，处理类和对象组合
3. **行为型模式**：观察者、代理、策略、命令等，管理对象间通信

掌握这些设计模式可以帮助开发者：
- 编写更清晰、可维护的代码
- 提高代码复用性
- 降低系统耦合度
- 增强系统扩展性

在实际开发中，需要根据具体场景选择合适的设计模式，避免过度设计。
