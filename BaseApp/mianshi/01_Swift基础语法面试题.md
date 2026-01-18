# Swift基础语法面试题详解

## 1. Swift vs Objective-C 的区别

### 问题：请详细说明Swift和Objective-C的主要区别？

**答案详解：**

#### 1.1 语法差异
- **类型推断**：Swift支持类型推断，Objective-C需要显式声明类型
- **可选类型**：Swift引入了Optional类型，Objective-C使用nil
- **函数式编程**：Swift支持函数式编程特性，如map、filter、reduce等

#### 1.2 内存管理
- **ARC**：两者都支持ARC，但Swift的ARC更安全
- **强引用循环**：Swift使用weak和unowned关键字避免循环引用

#### 1.3 安全性
- **类型安全**：Swift是类型安全的语言，编译时检查类型
- **空值安全**：Swift的可选类型强制处理nil值

**代码示例：**
```swift
// Swift
var name: String? = "John"
if let unwrappedName = name {
    print("Hello, \(unwrappedName)")
}

// Objective-C
NSString *name = @"John";
if (name) {
    // 使用NSString的方法
    NSString *greeting = [NSString stringWithFormat:@"Hello, %@", name];
}
```

## 2. Swift中的可选类型（Optional）

### 问题：什么是可选类型？如何使用？

**答案详解：**

#### 2.1 可选类型的概念
可选类型表示一个值可能存在，也可能不存在（nil）。在Swift中，所有类型都可以是可选类型。

#### 2.2 声明方式
```swift
var optionalString: String? = "Hello"
var optionalInt: Int? = nil
```

#### 2.3 解包方式
```swift
// 强制解包（危险）
let forcedString = optionalString!

// 可选绑定
if let unwrappedString = optionalString {
    print("String is: \(unwrappedString)")
}

// 隐式解包
var implicitlyUnwrappedString: String! = "Hello"
let implicitString = implicitlyUnwrappedString

// 空合并运算符
let displayName = optionalString ?? "Unknown"
```

#### 2.4 最佳实践
- 避免强制解包
- 优先使用可选绑定
- 使用空合并运算符提供默认值

## 3. Swift中的闭包（Closure）

### 问题：什么是闭包？请举例说明

**答案详解：**

#### 3.1 闭包的定义
闭包是自包含的功能代码块，可以在代码中被传递和使用。闭包可以捕获和存储其所在上下文中的任意常量和变量引用。

#### 3.2 闭包语法
```swift
// 完整语法
let names = ["Chris", "Alex", "Ewa", "Barry", "Daniella"]
let sortedNames = names.sorted { (s1: String, s2: String) -> Bool in
    return s1 > s2
}

// 类型推断
let sortedNames2 = names.sorted { s1, s2 in
    return s1 > s2
}

// 单行表达式隐式返回
let sortedNames3 = names.sorted { $0 > $1 }

// 尾随闭包
let sortedNames4 = names.sorted { $0 > $1 }
```

#### 3.3 闭包捕获值
```swift
func makeIncrementer(forIncrement amount: Int) -> () -> Int {
    var runningTotal = 0
    func incrementer() -> Int {
        runningTotal += amount
        return runningTotal
    }
    return incrementer
}

let incrementByTen = makeIncrementer(forIncrement: 10)
print(incrementByTen()) // 10
print(incrementByTen()) // 20
```

## 4. Swift中的属性（Properties）

### 问题：Swift中有哪些类型的属性？请详细说明

**答案详解：**

#### 4.1 存储属性
```swift
struct Person {
    var name: String
    let age: Int
}

var person = Person(name: "John", age: 30)
person.name = "Jane" // 可以修改
// person.age = 31   // 编译错误，age是常量
```

#### 4.2 计算属性
```swift
struct Circle {
    var radius: Double
    
    var area: Double {
        get {
            return Double.pi * radius * radius
        }
        set {
            radius = sqrt(newValue / Double.pi)
        }
    }
    
    var circumference: Double {
        return 2 * Double.pi * radius
    }
}
```

#### 4.3 属性观察器
```swift
class StepCounter {
    var totalSteps: Int = 0 {
        willSet(newTotalSteps) {
            print("About to set totalSteps to \(newTotalSteps)")
        }
        didSet {
            if totalSteps > oldValue {
                print("Added \(totalSteps - oldValue) steps")
            }
        }
    }
}
```

#### 4.4 类型属性
```swift
struct SomeStructure {
    static var storedTypeProperty = "Some value."
    static var computedTypeProperty: Int {
        return 1
    }
}

enum SomeEnumeration {
    static var storedTypeProperty = "Some value."
    static var computedTypeProperty: Int {
        return 6
    }
}
```

## 5. Swift中的错误处理

### 问题：Swift中如何处理错误？请举例说明

**答案详解：**

#### 5.1 错误类型定义
```swift
enum VendingMachineError: Error {
    case invalidSelection
    case insufficientFunds(coinsNeeded: Int)
    case outOfStock
}
```

#### 5.2 抛出错误的函数
```swift
func vend(itemNamed name: String) throws {
    guard let item = inventory[name] else {
        throw VendingMachineError.invalidSelection
    }
    
    guard item.count > 0 else {
        throw VendingMachineError.outOfStock
    }
    
    guard item.price <= coinsDeposited else {
        throw VendingMachineError.insufficientFunds(coinsNeeded: item.price - coinsDeposited)
    }
}
```

#### 5.3 错误处理方式
```swift
// do-catch语句
do {
    try vend(itemNamed: "Candy Bar")
    print("Successfully vended a Candy Bar")
} catch VendingMachineError.invalidSelection {
    print("Invalid Selection.")
} catch VendingMachineError.outOfStock {
    print("Out of Stock.")
} catch VendingMachineError.insufficientFunds(let coinsNeeded) {
    print("Insufficient funds. Please insert an additional \(coinsNeeded) coins.")
} catch {
    print("Unexpected error: \(error).")
}

// 转换为可选值
let x = try? someThrowingFunction()

// 禁用错误传播
let y = try! someThrowingFunction()
```

## 6. Swift中的协议（Protocol）

### 问题：什么是协议？如何使用？

**答案详解：**

#### 6.1 协议定义
协议定义了一个蓝图，规定了用来实现某一特定任务或者功能的方法、属性和其他要求。

#### 6.2 协议语法
```swift
protocol SomeProtocol {
    var mustBeSettable: Int { get set }
    var doesNotNeedToBeSettable: Int { get }
    
    func someMethod()
    mutating func someMutatingMethod()
}
```

#### 6.3 协议实现
```swift
struct Person: SomeProtocol {
    var mustBeSettable: Int
    let doesNotNeedToBeSettable: Int
    
    func someMethod() {
        print("Implementing someMethod")
    }
    
    mutating func someMutatingMethod() {
        mustBeSettable += 1
    }
}
```

#### 6.4 协议作为类型
```swift
protocol RandomNumberGenerator {
    func random() -> Double
}

class Dice {
    let sides: Int
    let generator: RandomNumberGenerator
    
    init(sides: Int, generator: RandomNumberGenerator) {
        self.sides = sides
        self.generator = generator
    }
    
    func roll() -> Int {
        return Int(generator.random() * Double(sides)) + 1
    }
}
```

## 7. Swift中的泛型（Generics）

### 问题：什么是泛型？请举例说明

**答案详解：**

#### 7.1 泛型函数
```swift
func swapTwoValues<T>(_ a: inout T, _ b: inout T) {
    let temporaryA = a
    a = b
    b = temporaryA
}

var someInt = 3
var anotherInt = 107
swapTwoValues(&someInt, &anotherInt)

var someString = "hello"
var anotherString = "world"
swapTwoValues(&someString, &anotherString)
```

#### 7.2 泛型类型
```swift
struct Stack<Element> {
    var items = [Element]()
    
    mutating func push(_ item: Element) {
        items.append(item)
    }
    
    mutating func pop() -> Element {
        return items.removeLast()
    }
}

var stackOfStrings = Stack<String>()
stackOfStrings.push("uno")
stackOfStrings.push("dos")
stackOfStrings.push("tres")
```

#### 7.3 类型约束
```swift
func findIndex<T: Equatable>(of valueToFind: T, in array:[T]) -> Int? {
    for (index, value) in array.enumerated() {
        if value == valueToFind {
            return index
        }
    }
    return nil
}
```

## 8. Swift中的内存管理

### 问题：Swift中如何管理内存？什么是ARC？

**答案详解：**

#### 8.1 ARC（Automatic Reference Counting）
ARC是Swift的内存管理机制，自动跟踪和管理应用程序的内存使用。

#### 8.2 强引用循环
```swift
class Person {
    let name: String
    var apartment: Apartment?
    
    init(name: String) {
        self.name = name
        print("\(name) is being initialized")
    }
    
    deinit {
        print("\(name) is being deinitialized")
    }
}

class Apartment {
    let unit: String
    var tenant: Person?
    
    init(unit: String) {
        self.unit = unit
        print("Apartment \(unit) is being initialized")
    }
    
    deinit {
        print("Apartment \(unit) is being deinitialized")
    }
}

var john: Person?
var unit4A: Apartment?

john = Person(name: "John Appleseed")
unit4A = Apartment(unit: "4A")

john!.apartment = unit4A
unit4A!.tenant = john

john = nil
unit4A = nil
// 这里不会调用deinit，因为存在强引用循环
```

#### 8.3 解决强引用循环
```swift
class Person {
    let name: String
    weak var apartment: Apartment? // 使用weak
    
    init(name: String) {
        self.name = name
    }
    
    deinit {
        print("\(name) is being deinitialized")
    }
}

class Apartment {
    let unit: String
    weak var tenant: Person? // 使用weak
    
    init(unit: String) {
        self.unit = unit
    }
    
    deinit {
        print("Apartment \(unit) is being deinitialized")
    }
}
```

#### 8.4 unowned引用
```swift
class Customer {
    let name: String
    var card: CreditCard?
    
    init(name: String) {
        self.name = name
    }
    
    deinit {
        print("\(name) is being deinitialized")
    }
}

class CreditCard {
    let number: UInt64
    unowned let customer: Customer // 使用unowned
    
    init(number: UInt64, customer: Customer) {
        self.number = number
        self.customer = customer
    }
    
    deinit {
        print("Card #\(number) is being deinitialized")
    }
}
```

## 总结

Swift作为一门现代化的编程语言，具有以下特点：
1. **安全性**：类型安全、空值安全
2. **简洁性**：语法简洁、类型推断
3. **功能性**：支持函数式编程、泛型
4. **互操作性**：与Objective-C无缝互操作
5. **性能**：接近C的性能表现

掌握这些基础概念对于iOS开发至关重要，建议在实际项目中多加练习和应用。
