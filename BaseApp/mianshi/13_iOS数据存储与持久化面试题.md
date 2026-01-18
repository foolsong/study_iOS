# iOS数据存储与持久化面试题详解

## 1. UserDefaults

### 问题：什么是UserDefaults？如何使用？

**答案详解：**

UserDefaults是iOS中用于存储用户偏好设置和简单数据的系统框架。

```objc
@interface UserDefaultsManager : NSObject

+ (instancetype)sharedManager;
- (void)saveUserPreferences;
- (void)loadUserPreferences;

@end

@implementation UserDefaultsManager

+ (instancetype)sharedManager {
    static UserDefaultsManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[UserDefaultsManager alloc] init];
    });
    return manager;
}

- (void)saveUserPreferences {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    // 保存基本数据类型
    [defaults setBool:YES forKey:@"isFirstLaunch"];
    [defaults setInteger:25 forKey:@"userAge"];
    [defaults setObject:@"John Doe" forKey:@"userName"];
    
    [defaults synchronize];
    // 用户偏好设置已保存
}

- (void)loadUserPreferences {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    BOOL isFirstLaunch = [defaults boolForKey:@"isFirstLaunch"];
    NSInteger userAge = [defaults integerForKey:@"userAge"];
    NSString *userName = [defaults stringForKey:@"userName"];
    
    // 用户偏好设置已加载
    // 首次启动: isFirstLaunch ? @"是" : @"否"
    // 用户年龄: userAge
    // 用户名: userName
}

@end
```

## 2. 文件系统

### 问题：iOS文件系统有哪些目录？如何使用？

**答案详解：**

```objc
@interface FileSystemManager : NSObject

- (void)exploreFileSystem;
- (NSString *)documentsDirectory;
- (NSString *)cachesDirectory;

@end

@implementation FileSystemManager

- (void)exploreFileSystem {
    // iOS文件系统目录结构
    
    // Documents目录 - 用户数据
    NSString *documentsPath = [self documentsDirectory];
    // Documents目录路径: documentsPath
    
    // Caches目录 - 缓存数据
    NSString *cachesPath = [self cachesDirectory];
    // Caches目录路径: cachesPath
    
    // Temporary目录 - 临时文件
    NSString *tempPath = NSTemporaryDirectory();
    // Temporary目录路径: tempPath
}

- (NSString *)documentsDirectory {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [paths firstObject];
}

- (NSString *)cachesDirectory {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    return [paths firstObject];
}

@end
```

## 3. 数据库操作

### 问题：iOS中有哪些数据库解决方案？

**答案详解：**

#### 3.1 SQLite数据库
```objc
#import <sqlite3.h>

@interface SQLiteManager : NSObject

@property (nonatomic, assign) sqlite3 *database;

- (BOOL)openDatabase;
- (void)closeDatabase;
- (BOOL)createTable;
- (BOOL)insertUser:(NSString *)name age:(NSInteger)age;

@end

@implementation SQLiteManager

- (BOOL)openDatabase {
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *dbPath = [documentsPath stringByAppendingPathComponent:@"users.db"];
    
    int result = sqlite3_open([dbPath UTF8String], &_database);
    
    if (result == SQLITE_OK) {
        // 数据库打开成功
        return YES;
    } else {
        // 数据库打开失败: sqlite3_errmsg(_database)
        return NO;
    }
}

- (void)closeDatabase {
    if (_database) {
        sqlite3_close(_database);
        _database = NULL;
        // 数据库已关闭
    }
}

- (BOOL)createTable {
    const char *sql = "CREATE TABLE IF NOT EXISTS users (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, age INTEGER)";
    
    char *errorMsg;
    int result = sqlite3_exec(_database, sql, NULL, NULL, &errorMsg);
    
    if (result == SQLITE_OK) {
        // 表创建成功
        return YES;
    } else {
        // 表创建失败: errorMsg
        sqlite3_free(errorMsg);
        return NO;
    }
}

- (BOOL)insertUser:(NSString *)name age:(NSInteger)age {
    const char *sql = "INSERT INTO users (name, age) VALUES (?, ?)";
    
    sqlite3_stmt *stmt;
    int result = sqlite3_prepare_v2(_database, sql, -1, &stmt, NULL);
    
    if (result == SQLITE_OK) {
        sqlite3_bind_text(stmt, 1, [name UTF8String], -1, NULL);
        sqlite3_bind_int(stmt, 2, (int)age);
        
        result = sqlite3_step(stmt);
        sqlite3_finalize(stmt);
        
        if (result == SQLITE_DONE) {
            // 用户插入成功
            return YES;
        }
    }
    
    // 用户插入失败
    return NO;
}

@end
```

#### 3.2 Core Data
```objc
@interface CoreDataManager : NSObject

@property (nonatomic, strong) NSPersistentContainer *persistentContainer;
@property (nonatomic, strong) NSManagedObjectContext *context;

- (void)setupCoreData;
- (void)saveContext;
- (NSManagedObject *)createUserWithName:(NSString *)name age:(NSInteger)age;

@end

@implementation CoreDataManager

- (void)setupCoreData {
    // 创建持久化容器
    self.persistentContainer = [[NSPersistentContainer alloc] initWithName:@"UserModel"];
    
    [self.persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *description, NSError *error) {
        if (error) {
            // Core Data 加载失败: error.localizedDescription
        } else {
            // Core Data 加载成功
            self.context = self.persistentContainer.viewContext;
        }
    }];
}

- (void)saveContext {
    if (self.context.hasChanges) {
        NSError *error;
        if ([self.context save:&error]) {
            // 上下文保存成功
        } else {
            // 上下文保存失败: error.localizedDescription
        }
    }
}

- (NSManagedObject *)createUserWithName:(NSString *)name age:(NSInteger)age {
    NSManagedObject *user = [NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:self.context];
    
    [user setValue:name forKey:@"name"];
    [user setValue:@(age) forKey:@"age"];
    [user setValue:[NSDate date] forKey:@"createdAt"];
    
    [self saveContext];
    
    return user;
}

@end
```

## 4. Keychain

### 问题：什么是Keychain？如何使用？

**答案详解：**

Keychain是iOS中用于安全存储敏感数据的系统框架。

```objc
#import <Security/Security.h>

@interface KeychainManager : NSObject

+ (instancetype)sharedManager;
- (BOOL)savePassword:(NSString *)password forAccount:(NSString *)account service:(NSString *)service;
- (NSString *)passwordForAccount:(NSString *)account service:(NSString *)service;

@end

@implementation KeychainManager

+ (instancetype)sharedManager {
    static KeychainManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[KeychainManager alloc] init];
    });
    return manager;
}

- (BOOL)savePassword:(NSString *)password forAccount:(NSString *)account service:(NSString *)service {
    NSData *passwordData = [password dataUsingEncoding:NSUTF8StringEncoding];
    
    NSDictionary *query = @{
        (__bridge id)kSecClass: (__bridge id)kSecClassGenericPassword,
        (__bridge id)kSecAttrAccount: account,
        (__bridge id)kSecAttrService: service,
        (__bridge id)kSecValueData: passwordData,
        (__bridge id)kSecAttrAccessible: (__bridge id)kSecAttrAccessibleWhenUnlocked
    };
    
    OSStatus status = SecItemAdd((__bridge CFDictionaryRef)query, NULL);
    
    if (status == errSecSuccess) {
        // 密码保存成功
        return YES;
    } else {
        // 密码保存失败: status
        return NO;
    }
}

- (NSString *)passwordForAccount:(NSString *)account service:(NSString *)service {
    NSDictionary *query = @{
        (__bridge id)kSecClass: (__bridge id)kSecClassGenericPassword,
        (__bridge id)kSecAttrAccount: account,
        (__bridge id)kSecAttrService: service,
        (__bridge id)kSecReturnData: @YES,
        (__bridge id)kSecMatchLimit: (__bridge id)kSecMatchLimitOne
    };
    
    CFTypeRef result = NULL;
    OSStatus status = SecItemCopyMatching((__bridge CFDictionaryRef)query, &result);
    
    if (status == errSecSuccess) {
        NSData *passwordData = (__bridge_transfer NSData *)result;
        NSString *password = [[NSString alloc] initWithData:passwordData encoding:NSUTF8StringEncoding];
        // 密码获取成功
        return password;
    } else {
        // 密码获取失败: status
        return nil;
    }
}

@end
```

## 总结

iOS数据存储与持久化是应用开发的重要组成部分，包括：

1. **UserDefaults**：用户偏好设置和简单数据存储
2. **文件系统**：文件操作和目录管理
3. **数据库操作**：SQLite和Core Data
4. **Keychain**：安全数据存储

掌握这些知识点对于创建功能完整、数据安全的iOS应用至关重要。
