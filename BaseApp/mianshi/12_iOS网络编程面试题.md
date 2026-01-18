# iOS网络编程面试题详解

## 1. 网络基础概念

### 问题：HTTP和HTTPS有什么区别？

**答案详解：**

#### 1.1 HTTP vs HTTPS 区别

**安全性：**
- **HTTP**：明文传输，数据容易被截获
- **HTTPS**：加密传输，数据安全

**端口：**
- **HTTP**：80端口
- **HTTPS**：443端口

**证书：**
- **HTTP**：不需要证书
- **HTTPS**：需要SSL证书

**性能：**
- **HTTP**：传输速度快
- **HTTPS**：有加密开销，稍慢

**SEO：**
- **HTTP**：搜索引擎排名较低
- **HTTPS**：搜索引擎优先推荐

#### 1.2 网络请求示例

**HTTP请求：**
```objc
@interface HTTPExample : NSObject

- (void)makeHTTPRequest;

@end

@implementation HTTPExample

- (void)makeHTTPRequest {
    // HTTP请求示例
    NSURL *url = [NSURL URLWithString:@"http://example.com/api"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    // 处理HTTP请求
}

@end
```

**HTTPS请求：**
```objc
@interface HTTPSExample : NSObject

- (void)makeHTTPSRequest;

@end

@implementation HTTPSExample

- (void)makeHTTPSRequest {
    // HTTPS请求示例
    NSURL *url = [NSURL URLWithString:@"https://example.com/api"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    // 处理HTTPS请求
}
```

## 2. URLSession基础使用

### 问题：如何使用URLSession进行网络请求？

**答案详解：**

#### 2.1 基本GET请求
```objc
@interface BasicNetworkManager : NSObject

- (void)fetchDataWithURL:(NSURL *)url completion:(void(^)(NSData *data, NSError *error))completion;

@end

@implementation BasicNetworkManager

- (void)fetchDataWithURL:(NSURL *)url completion:(void(^)(NSData *data, NSError *error))completion {
    // 创建URLSession
    NSURLSession *session = [NSURLSession sharedSession];
    
    // 创建数据任务
    NSURLSessionDataTask *dataTask = [session dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        // 检查错误
        if (error) {
            // 网络请求错误: error.localizedDescription
            if (completion) {
                completion(nil, error);
            }
            return;
        }
        
        // 检查HTTP状态码
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        if (httpResponse.statusCode != 200) {
            NSError *statusError = [NSError errorWithDomain:@"NetworkError" 
                                                      code:httpResponse.statusCode 
                                                  userInfo:@{NSLocalizedDescriptionKey: @"HTTP状态码错误"}];
            if (completion) {
                completion(nil, statusError);
            }
            return;
        }
        
        // 成功返回数据
        if (completion) {
            completion(data, nil);
        }
    }];
    
    // 启动任务
    [dataTask resume];
}

@end
```

#### 2.2 POST请求
```objc
@interface POSTNetworkManager : NSObject

- (void)postData:(NSDictionary *)data toURL:(NSURL *)url completion:(void(^)(NSData *responseData, NSError *error))completion;

@end

@implementation POSTNetworkManager

- (void)postData:(NSDictionary *)data toURL:(NSURL *)url completion:(void(^)(NSData *responseData, NSError *error))completion {
    // 创建请求
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    
    // 设置请求头
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    // 设置请求体
    NSError *jsonError;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:data options:0 error:&jsonError];
    
    if (jsonError) {
        if (completion) {
            completion(nil, jsonError);
        }
        return;
    }
    
    request.HTTPBody = jsonData;
    
    // 创建URLSession
    NSURLSession *session = [NSURLSession sharedSession];
    
    // 创建数据任务
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error) {
            if (completion) {
                completion(nil, error);
            }
            return;
        }
        
        if (completion) {
            completion(data, nil);
        }
    }];
    
    [dataTask resume];
}

@end
```

#### 2.3 文件下载
```objc
@interface DownloadManager : NSObject

- (void)downloadFileFromURL:(NSURL *)url toPath:(NSString *)path progress:(void(^)(float progress))progress completion:(void(^)(BOOL success, NSError *error))completion;

@end

@implementation DownloadManager

- (void)downloadFileFromURL:(NSURL *)url toPath:(NSString *)path progress:(void(^)(float progress))progress completion:(void(^)(BOOL success, NSError *error))completion {
    // 创建请求
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    // 创建URLSession
    NSURLSession *session = [NSURLSession sharedSession];
    
    // 创建下载任务
    NSURLSessionDownloadTask *downloadTask = [session downloadTaskWithRequest:request completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
        if (error) {
            if (completion) {
                completion(NO, error);
            }
            return;
        }
        
        // 移动文件到目标路径
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSError *moveError;
        
        if ([fileManager fileExistsAtPath:path]) {
            [fileManager removeItemAtPath:path error:nil];
        }
        
        BOOL success = [fileManager moveItemAtURL:location toURL:[NSURL fileURLWithPath:path] error:&moveError];
        
        if (completion) {
            completion(success, moveError);
        }
    }];
    
    // 监听下载进度
    [downloadTask resume];
    
    // 使用KVO监听下载进度
    [downloadTask addObserver:self forKeyPath:@"countOfBytesReceived" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"countOfBytesReceived"]) {
        NSURLSessionDownloadTask *task = (NSURLSessionDownloadTask *)object;
        float progress = (float)task.countOfBytesReceived / (float)task.countOfBytesExpectedToReceive;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            // 下载进度: progress * 100%
        });
    }
}

@end
```

## 3. JSON解析

### 问题：如何在iOS中解析JSON数据？

**答案详解：**

#### 3.1 基本JSON解析
```objc
@interface JSONParser : NSObject

- (NSDictionary *)parseJSONData:(NSData *)data;
- (NSArray *)parseJSONArray:(NSData *)data;
- (NSData *)createJSONFromDictionary:(NSDictionary *)dictionary;

@end

@implementation JSONParser

- (NSDictionary *)parseJSONData:(NSData *)data {
    NSError *error;
    id jsonObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    
    if (error) {
        // JSON解析错误: error.localizedDescription
        return nil;
    }
    
    if ([jsonObject isKindOfClass:[NSDictionary class]]) {
        return (NSDictionary *)jsonObject;
    }
    
    // JSON数据不是字典格式
    return nil;
}

- (NSArray *)parseJSONArray:(NSData *)data {
    NSError *error;
    id jsonObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    
    if (error) {
        // JSON解析错误: error.localizedDescription
        return nil;
    }
    
    if ([jsonObject isKindOfClass:[NSArray class]]) {
        return (NSArray *)jsonObject;
    }
    
    // JSON数据不是数组格式
    return nil;
}

- (NSData *)createJSONFromDictionary:(NSDictionary *)dictionary {
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictionary options:NSJSONWritingPrettyPrinted error:&error];
    
    if (error) {
        // JSON创建错误: error.localizedDescription
        return nil;
    }
    
    return jsonData;
}

@end
```

#### 3.2 复杂JSON解析
```objc
@interface ComplexJSONParser : NSObject

- (void)parseUserData:(NSData *)data;

@end

@implementation ComplexJSONParser

- (void)parseUserData:(NSData *)data {
    NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    
    if (!jsonDict) {
        // JSON解析失败
        return;
    }
    
    // 解析用户信息
    NSDictionary *user = jsonDict[@"user"];
    if (user) {
        NSString *name = user[@"name"];
        NSInteger age = [user[@"age"] integerValue];
        NSString *email = user[@"email"];
        
        // 用户信息: 姓名=name, 年龄=age, 邮箱=email
    }
    
    // 解析地址信息
    NSDictionary *address = jsonDict[@"address"];
    if (address) {
        NSString *city = address[@"city"];
        NSString *country = address[@"country"];
        
        // 地址信息: 城市=city, 国家=country
    }
    
    // 解析标签数组
    NSArray *tags = jsonDict[@"tags"];
    if (tags) {
        // 标签数量: tags.count
        for (NSString *tag in tags) {
            // 标签: tag
        }
    }
}

@end
```

## 4. 网络错误处理

### 问题：如何处理网络请求中的各种错误？

**答案详解：**

#### 4.1 网络错误类型
```objc
typedef NS_ENUM(NSInteger, NetworkErrorType) {
    NetworkErrorTypeNoConnection,
    NetworkErrorTypeTimeout,
    NetworkErrorTypeServerError,
    NetworkErrorTypeAuthenticationFailed,
    NetworkErrorTypeInvalidResponse
};

@interface NetworkError : NSObject

@property (nonatomic, assign) NetworkErrorType type;
@property (nonatomic, strong) NSString *message;
@property (nonatomic, strong) NSError *underlyingError;

+ (instancetype)errorWithType:(NetworkErrorType)type message:(NSString *)message underlyingError:(NSError *)underlyingError;

@end

@implementation NetworkError

+ (instancetype)errorWithType:(NetworkErrorType)type message:(NSString *)message underlyingError:(NSError *)underlyingError {
    NetworkError *error = [[NetworkError alloc] init];
    error.type = type;
    error.message = message;
    error.underlyingError = underlyingError;
    return error;
}

@end
```

#### 4.2 错误处理实现
```objc
@interface NetworkErrorHandler : NSObject

- (void)handleNetworkError:(NSError *)error;
- (void)handleHTTPStatusCode:(NSInteger)statusCode;
- (BOOL)isNetworkReachable;

@end

@implementation NetworkErrorHandler

- (void)handleNetworkError:(NSError *)error {
    if ([error.domain isEqualToString:NSURLErrorDomain]) {
        switch (error.code) {
            case NSURLErrorNotConnectedToInternet:
                // 网络连接错误: 没有网络连接
                break;
                
            case NSURLErrorTimedOut:
                // 网络连接错误: 请求超时
                break;
                
            case NSURLErrorCannotFindHost:
                // 网络连接错误: 找不到主机
                break;
                
            case NSURLErrorCannotConnectToHost:
                // 网络连接错误: 无法连接到主机
                break;
                
            default:
                // 网络连接错误: error.localizedDescription
                break;
        }
    } else {
        // 其他错误: error.localizedDescription
    }
}

- (void)handleHTTPStatusCode:(NSInteger)statusCode {
    switch (statusCode) {
        case 200:
            // 请求成功
            break;
            
        case 400:
            // 请求错误: 客户端错误
            break;
            
        case 401:
            // 请求错误: 未授权
            break;
            
        case 403:
            // 请求错误: 禁止访问
            break;
            
        case 404:
            // 请求错误: 资源不存在
            break;
            
        case 500:
            // 请求错误: 服务器内部错误
            break;
            
        case 502:
            // 请求错误: 网关错误
            break;
            
        case 503:
            // 请求错误: 服务不可用
            break;
            
        default:
            // 请求错误: 未知状态码 statusCode
            break;
    }
}

- (BOOL)isNetworkReachable {
    // 检查网络可达性
    SCNetworkReachabilityRef reachability = SCNetworkReachabilityCreateWithName(NULL, "www.apple.com");
    SCNetworkReachabilityFlags flags;
    BOOL success = SCNetworkReachabilityGetFlags(reachability, &flags);
    
    if (success) {
        BOOL reachable = (flags & kSCNetworkReachabilityFlagsReachable) != 0;
        CFRelease(reachability);
        return reachable;
    }
    
    CFRelease(reachability);
    return NO;
}

@end
```

## 5. 网络缓存

### 问题：如何实现网络请求的缓存？

**答案详解：**

#### 5.1 URL缓存配置
```objc
@interface NetworkCacheManager : NSObject

+ (instancetype)sharedManager;
- (void)configureCache;
- (void)clearCache;
- (NSUInteger)cacheSize;

@end

@implementation NetworkCacheManager

+ (instancetype)sharedManager {
    static NetworkCacheManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[NetworkCacheManager alloc] init];
    });
    return manager;
}

- (void)configureCache {
    // 配置缓存
    NSURLCache *sharedCache = [[NSURLCache alloc] initWithMemoryCapacity:4 * 1024 * 1024  // 4MB内存缓存
                                                              diskCapacity:20 * 1024 * 1024  // 20MB磁盘缓存
                                                                  diskPath:@"network_cache"];
    
    [NSURLCache setSharedURLCache:sharedCache];
    
    // 配置缓存策略
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    config.requestCachePolicy = NSURLRequestUseProtocolCachePolicy;
    config.URLCache = sharedCache;
}

- (void)clearCache {
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    // 网络缓存已清除
}

- (NSUInteger)cacheSize {
    NSURLCache *cache = [NSURLCache sharedURLCache];
    return cache.memoryCapacity + cache.diskCapacity;
}

@end
```

#### 5.2 自定义缓存策略
```objc
@interface CustomCacheManager : NSObject

- (void)cacheResponse:(NSData *)data forURL:(NSURL *)url;
- (NSData *)cachedResponseForURL:(NSURL *)url;
- (BOOL)isResponseCachedForURL:(NSURL *)url;

@end

@implementation CustomCacheManager

- (void)cacheResponse:(NSData *)data forURL:(NSURL *)url {
    NSString *cacheKey = [self cacheKeyForURL:url];
    NSString *cachePath = [self cachePathForKey:cacheKey];
    
    [data writeToFile:cachePath atomically:YES];
    
    // 保存缓存元数据
    NSDictionary *metadata = @{
        @"url": url.absoluteString,
        @"timestamp": [NSDate date],
        @"size": @(data.length)
    };
    
    NSString *metadataPath = [cachePath stringByAppendingString:@".meta"];
    [metadata writeToFile:metadataPath atomically:YES];
}

- (NSData *)cachedResponseForURL:(NSURL *)url {
    NSString *cacheKey = [self cacheKeyForURL:url];
    NSString *cachePath = [self cachePathForKey:cacheKey];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:cachePath]) {
        return [NSData dataWithContentsOfFile:cachePath];
    }
    
    return nil;
}

- (BOOL)isResponseCachedForURL:(NSURL *)url {
    NSString *cacheKey = [self cacheKeyForURL:url];
    NSString *cachePath = [self cachePathForKey:cacheKey];
    
    return [[NSFileManager defaultManager] fileExistsAtPath:cachePath];
}

#pragma mark - Helper Methods

- (NSString *)cacheKeyForURL:(NSURL *)url {
    return [url.absoluteString MD5String];
}

- (NSString *)cachePathForKey:(NSString *)key {
    NSString *cachesPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    NSString *cacheDirectory = [cachesPath stringByAppendingPathComponent:@"CustomNetworkCache"];
    
    // 创建缓存目录
    if (![[NSFileManager defaultManager] fileExistsAtPath:cacheDirectory]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:cacheDirectory withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    return [cacheDirectory stringByAppendingPathComponent:key];
}

@end
```

## 6. 网络安全

### 问题：如何确保iOS应用的网络安全性？

**答案详解：**

#### 6.1 证书固定（Certificate Pinning）
```objc
@interface SecurityManager : NSObject

- (void)configureSecurity;
- (BOOL)validateServerTrust:(SecTrustRef)serverTrust forDomain:(NSString *)domain;

@end

@implementation SecurityManager

- (void)configureSecurity {
    // 配置ATS（App Transport Security）
    NSDictionary *atsSettings = @{
        NSAppTransportSecurityAllowsArbitraryLoads: @NO,
        NSAppTransportSecurityAllowsArbitraryLoadsInWebContent: @NO,
        NSAppTransportSecurityAllowsLocalNetworking: @YES
    };
    
    // 在Info.plist中设置
    // ATS设置: atsSettings
}

- (BOOL)validateServerTrust:(SecTrustRef)serverTrust forDomain:(NSString *)domain {
    // 获取证书链
    SecCertificateRef serverCertificate = SecTrustGetCertificateAtIndex(serverTrust, 0);
    
    // 获取证书数据
    NSData *serverCertificateData = (__bridge_transfer NSData *)SecCertificateCopyData(serverCertificate);
    
    // 计算证书的SHA256哈希
    NSString *serverCertificateHash = [self SHA256HashOfData:serverCertificateData];
    
    // 与预定义的证书哈希比较
    NSString *expectedHash = @"预定义的证书哈希值";
    
    return [serverCertificateHash isEqualToString:expectedHash];
}

- (NSString *)SHA256HashOfData:(NSData *)data {
    uint8_t digest[CC_SHA256_DIGEST_LENGTH];
    CC_SHA256(data.bytes, (CC_LONG)data.length, digest);
    
    NSMutableString *hash = [NSMutableString stringWithCapacity:CC_SHA256_DIGEST_LENGTH * 2];
    for (int i = 0; i < CC_SHA256_DIGEST_LENGTH; i++) {
        [hash appendFormat:@"%02x", digest[i]];
    }
    
    return hash;
}

@end
```

#### 6.2 请求签名
```objc
@interface RequestSigner : NSObject

- (NSString *)signRequest:(NSDictionary *)parameters withSecret:(NSString *)secret;
- (BOOL)verifySignature:(NSString *)signature forRequest:(NSDictionary *)parameters withSecret:(NSString *)secret;

@end

@implementation RequestSigner

- (NSString *)signRequest:(NSDictionary *)parameters withSecret:(NSString *)secret {
    // 对参数进行排序
    NSArray *sortedKeys = [[parameters allKeys] sortedArrayUsingSelector:@selector(compare:)];
    
    // 构建签名字符串
    NSMutableString *signString = [NSMutableString string];
    for (NSString *key in sortedKeys) {
        [signString appendFormat:@"%@=%@&", key, parameters[key]];
    }
    [signString appendString:secret];
    
    // 计算MD5哈希
    return [self MD5HashOfString:signString];
}

- (BOOL)verifySignature:(NSString *)signature forRequest:(NSDictionary *)parameters withSecret:(NSString *)secret {
    NSString *calculatedSignature = [self signRequest:parameters withSecret:secret];
    return [signature isEqualToString:calculatedSignature];
}

- (NSString *)MD5HashOfString:(NSString *)string {
    const char *cStr = [string UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), digest);
    
    NSMutableString *hash = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [hash appendFormat:@"%02x", digest[i]];
    }
    
    return hash;
}

@end
```

## 总结

iOS网络编程是应用开发的重要组成部分，包括：

1. **网络基础**：HTTP/HTTPS协议理解
2. **URLSession使用**：GET/POST请求、文件下载
3. **JSON解析**：数据格式处理
4. **错误处理**：网络异常情况处理
5. **缓存策略**：提升用户体验
6. **网络安全**：证书固定、请求签名

掌握这些知识点对于创建稳定、安全的网络应用至关重要。
