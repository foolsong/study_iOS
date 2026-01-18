# Swift高级特性面试题详解

## 1. Swift中的访问控制（Access Control）

### 问题：Swift中有哪些访问级别？如何使用？

**答案详解：**

#### 1.1 访问级别分类
Swift提供了5个访问级别，从高到低依次为：

1. **open**：最高访问级别，允许在定义模块外继承和重写
2. **public**：允许在定义模块外访问，但不能继承和重写
3. **internal**：默认访问级别，允许在定义模块内访问
4. **fileprivate**：允许在定义文件内访问
5. **private**：最低访问级别，只允许在定义的作用域内访问

#### 1.2 使用示例
```swift
// 模块级别
public class PublicClass {
    public var publicProperty = "public"
    internal var internalProperty = "internal"
    fileprivate var fileprivateProperty = "fileprivate"
    private var privateProperty = "private"
}

// 继承和重写
open class OpenClass {
    open func openMethod() {}
    public func publicMethod() {}
}

class SubClass: OpenClass {
    override func openMethod() {} // 可以重写
    override func publicMethod() {} // 编译错误，不能重写
}
```

#### 1.3 最佳实践
- 使用最低的访问级别来满足需求
- 优先使用`internal`作为默认访问级别
- 只在需要外部访问时才使用`public`或`open`

## 2. Swift中的扩展（Extension）

### 问题：什么是扩展？如何使用？

**答案详解：**

#### 2.1 扩展的概念
扩展可以为现有的类、结构体、枚举或协议添加新功能，而无需访问原始源代码。

#### 2.2 扩展语法
```swift
extension SomeType {
    // 新功能
}

extension SomeType: SomeProtocol, AnotherProtocol {
    // 协议实现
}
```

#### 2.3 扩展计算属性
```swift
extension Double {
    var km: Double { return self * 1_000.0 }
    var m: Double { return self }
    var cm: Double { return self / 100.0 }
    var mm: Double { return self / 1_000.0 }
    var ft: Double { return self / 3.28084 }
}

let oneInch = 25.4.mm
print("One inch is \(oneInch) meters")
let threeFeet = 3.ft
print("Three feet is \(threeFeet) meters")
```

#### 2.4 扩展构造器
```swift
struct Rect {
    var origin = Point.zero
    var size = Size.zero
}

extension Rect {
    init(center: Point, size: Size) {
        let originX = center.x - (size.width / 2)
        let originY = center.y - (size.height / 2)
        self.init(origin: Point(x: originX, y: originY), size: size)
    }
}
```

#### 2.5 扩展方法
```swift
extension Int {
    func repetitions(task: () -> Void) {
        for _ in 0..<self {
            task()
        }
    }
    
    mutating func square() {
        self = self * self
    }
}

3.repetitions {
    print("Hello!")
}

var someInt = 3
someInt.square()
```

## 3. Swift中的协议扩展（Protocol Extensions）

### 问题：什么是协议扩展？如何使用？

**答案详解：**

#### 3.1 协议扩展的概念
协议扩展可以为协议添加默认实现，使得遵循协议的类型自动获得这些功能。

#### 3.2 基本用法
```swift
protocol RandomNumberGenerator {
    func random() -> Double
}

extension RandomNumberGenerator {
    func randomBool() -> Bool {
        return random() > 0.5
    }
}

class LinearCongruentialGenerator: RandomNumberGenerator {
    var lastRandom = 42.0
    let m = 139968.0
    let a = 3877.0
    let c = 29573.0
    
    func random() -> Double {
        lastRandom = ((lastRandom * a + c).truncatingRemainder(dividingBy: m))
        return lastRandom / m
    }
}

let generator = LinearCongruentialGenerator()
print("Here's a random number: \(generator.random())")
print("And here's a random Boolean: \(generator.randomBool())")
```

#### 3.3 为协议添加约束
```swift
extension Collection where Element: Equatable {
    func allEqual() -> Bool {
        for element in self {
            if element != self.first {
                return false
            }
        }
        return true
    }
}

let equalNumbers = [100, 100, 100, 100, 100]
let differentNumbers = [100, 100, 200, 100, 100]

print(equalNumbers.allEqual()) // true
print(differentNumbers.allEqual()) // false
```

## 4. Swift中的错误处理进阶

### 问题：Swift中如何处理复杂的错误情况？

**答案详解：**

#### 4.1 自定义错误类型
```swift
enum NetworkError: Error, LocalizedError {
    case invalidURL
    case noData
    case decodingError
    case serverError(Int)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .noData:
            return "No data received"
        case .decodingError:
            return "Failed to decode data"
        case .serverError(let code):
            return "Server error with code: \(code)"
        }
    }
}
```

#### 4.2 异步错误处理
```swift
func fetchData() async throws -> Data {
    guard let url = URL(string: "https://api.example.com/data") else {
        throw NetworkError.invalidURL
    }
    
    let (data, response) = try await URLSession.shared.data(from: url)
    
    guard let httpResponse = response as? HTTPURLResponse else {
        throw NetworkError.serverError(0)
    }
    
    guard httpResponse.statusCode == 200 else {
        throw NetworkError.serverError(httpResponse.statusCode)
    }
    
    return data
}

// 使用
Task {
    do {
        let data = try await fetchData()
        print("Data received: \(data)")
    } catch NetworkError.invalidURL {
        print("Invalid URL")
    } catch NetworkError.serverError(let code) {
        print("Server error: \(code)")
    } catch {
        print("Unexpected error: \(error)")
    }
}
```

## 5. Swift中的函数式编程

### 问题：Swift中如何实现函数式编程？

**答案详解：**

#### 5.1 高阶函数
```swift
let numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]

// map
let doubled = numbers.map { $0 * 2 }
print(doubled) // [2, 4, 6, 8, 10, 12, 14, 16, 18, 20]

// filter
let evenNumbers = numbers.filter { $0 % 2 == 0 }
print(evenNumbers) // [2, 4, 6, 8, 10]

// reduce
let sum = numbers.reduce(0, +)
print(sum) // 55

// flatMap (现在叫compactMap)
let optionalNumbers: [Int?] = [1, nil, 3, nil, 5]
let unwrappedNumbers = optionalNumbers.compactMap { $0 }
print(unwrappedNumbers) // [1, 3, 5]
```

#### 5.2 函数组合
```swift
func compose<T, U, V>(_ f: @escaping (U) -> V, _ g: @escaping (T) -> U) -> (T) -> V {
    return { x in f(g(x)) }
}

func addOne(_ x: Int) -> Int { return x + 1 }
func multiplyByTwo(_ x: Int) -> Int { return x * 2 }

let addOneThenMultiply = compose(multiplyByTwo, addOne)
print(addOneThenMultiply(5)) // 12
```

#### 5.3 柯里化（Currying）
```swift
func add(_ a: Int) -> (Int) -> Int {
    return { b in a + b }
}

let addFive = add(5)
print(addFive(3)) // 8

// 更复杂的柯里化
func curry<A, B, C>(_ function: @escaping (A, B) -> C) -> (A) -> (B) -> C {
    return { a in { b in function(a, b) } }
}

let curriedAdd = curry(+)
let addTen = curriedAdd(10)
print(addTen(5)) // 15
```

## 6. Swift中的反射（Reflection）

### 问题：什么是反射？如何使用？

**答案详解：**

#### 6.1 反射的概念
反射允许程序在运行时检查和操作其自身的结构和行为。

#### 6.2 使用Mirror
```swift
struct Person {
    let name: String
    let age: Int
    let city: String
}

let person = Person(name: "John", age: 30, city: "New York")
let mirror = Mirror(reflecting: person)

print("Type: \(mirror.subjectType)")
print("Children count: \(mirror.children.count)")

for child in mirror.children {
    if let label = child.label {
        print("\(label): \(child.value)")
    }
}
```

#### 6.3 动态属性访问
```swift
class DynamicObject {
    private var storage: [String: Any] = [:]
    
    subscript(key: String) -> Any? {
        get {
            return storage[key]
        }
        set {
            storage[key] = newValue
        }
    }
}

let obj = DynamicObject()
obj["name"] = "John"
obj["age"] = 30

print(obj["name"] as? String ?? "Unknown")
print(obj["age"] as? Int ?? 0)
```

## 7. Swift中的并发编程

### 问题：Swift中如何实现并发编程？

**答案详解：**

#### 7.1 async/await
```swift
func fetchUser(id: Int) async throws -> User {
    let url = URL(string: "https://api.example.com/users/\(id)")!
    let (data, _) = try await URLSession.shared.data(from: url)
    return try JSONDecoder().decode(User.self, from: data)
}

func fetchUsers(ids: [Int]) async throws -> [User] {
    async let users = ids.map { id in
        try await fetchUser(id: id)
    }
    return try await users
}
```

#### 7.2 任务组（Task Groups）
```swift
func fetchUsersWithTaskGroup(ids: [Int]) async throws -> [User] {
    try await withThrowingTaskGroup(of: User.self) { group in
        for id in ids {
            group.addTask {
                try await fetchUser(id: id)
            }
        }
        
        var users: [User] = []
        for try await user in group {
            users.append(user)
        }
        return users
    }
}
```

#### 7.3 异步序列
```swift
struct AsyncNumberSequence: AsyncSequence {
    let start: Int
    let end: Int
    
    struct AsyncIterator: AsyncIteratorProtocol {
        var current: Int
        let end: Int
        
        mutating func next() async -> Int? {
            guard current <= end else { return nil }
            let value = current
            current += 1
            return value
        }
    }
    
    func makeAsyncIterator() -> AsyncIterator {
        AsyncIterator(current: start, end: end)
    }
}

// 使用
for await number in AsyncNumberSequence(start: 1, end: 5) {
    print(number)
}
```

## 8. Swift中的性能优化

### 问题：如何优化Swift代码的性能？

**答案详解：**

#### 8.1 值类型vs引用类型
```swift
// 使用结构体（值类型）而不是类（引用类型）
struct Point {
    var x: Double
    var y: Double
}

// 避免不必要的复制
func processPoints(_ points: [Point]) {
    // 使用inout参数避免复制
    var mutablePoints = points
    // 处理逻辑
}
```

#### 8.2 内存管理优化
```swift
class ImageProcessor {
    // 使用weak避免循环引用
    weak var delegate: ImageProcessorDelegate?
    
    // 使用unowned当确定引用不会为nil
    unowned let cache: ImageCache
    
    init(cache: ImageCache) {
        self.cache = cache
    }
}
```

#### 8.3 集合性能优化
```swift
// 预分配容量
var array = [Int]()
array.reserveCapacity(1000)

// 使用Set进行快速查找
let set = Set(array)
if set.contains(42) {
    print("Found 42")
}

// 使用Dictionary进行键值查找
let dict = Dictionary(uniqueKeysWithValues: zip(1...100, 1...100))
```

## 总结

Swift的高级特性为开发者提供了强大的工具：
1. **访问控制**：提供灵活的封装机制
2. **扩展**：增强现有类型的功能
3. **协议扩展**：提供默认实现
4. **函数式编程**：支持函数式编程范式
5. **反射**：运行时类型检查
6. **并发编程**：现代化的异步编程支持
7. **性能优化**：多种优化策略

掌握这些高级特性可以写出更优雅、更高效的Swift代码。
