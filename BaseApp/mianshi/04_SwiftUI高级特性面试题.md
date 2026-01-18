# SwiftUI高级特性面试题详解

## 1. SwiftUI中的自定义视图修饰符

### 问题：如何创建自定义视图修饰符？请举例说明

**答案详解：**

#### 1.1 基本修饰符创建
```swift
struct PrimaryButtonStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.headline)
            .foregroundColor(.white)
            .padding()
            .background(Color.blue)
            .cornerRadius(10)
            .shadow(radius: 2)
    }
}

// 使用扩展简化调用
extension View {
    func primaryButtonStyle() -> some View {
        self.modifier(PrimaryButtonStyle())
    }
}

// 使用示例
struct CustomModifierExample: View {
    var body: some View {
        VStack(spacing: 20) {
            Button("Primary Button") {
                // 按钮操作
            }
            .primaryButtonStyle()
            
            // 或者直接使用modifier
            Button("Another Button") {
                // 按钮操作
            }
            .modifier(PrimaryButtonStyle())
        }
    }
}
```

#### 1.2 带参数的修饰符
```swift
struct CardStyle: ViewModifier {
    let backgroundColor: Color
    let cornerRadius: CGFloat
    let shadowRadius: CGFloat
    
    func body(content: Content) -> some View {
        content
            .padding()
            .background(backgroundColor)
            .cornerRadius(cornerRadius)
            .shadow(radius: shadowRadius)
    }
}

extension View {
    func cardStyle(
        backgroundColor: Color = .white,
        cornerRadius: CGFloat = 10,
        shadowRadius: CGFloat = 2
    ) -> some View {
        self.modifier(CardStyle(
            backgroundColor: backgroundColor,
            cornerRadius: cornerRadius,
            shadowRadius: shadowRadius
        ))
    }
}

// 使用示例
struct CardExample: View {
    var body: some View {
        VStack {
            Text("Card Title")
                .font(.title)
            Text("Card content goes here")
                .font(.body)
        }
        .cardStyle(
            backgroundColor: .blue.opacity(0.1),
            cornerRadius: 15,
            shadowRadius: 5
        )
    }
}
```

## 2. SwiftUI中的自定义形状

### 问题：如何创建自定义形状？请举例说明

**答案详解：**

#### 2.1 基本自定义形状
```swift
struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.closeSubpath()
        
        return path
    }
}

struct CustomShapeExample: View {
    var body: some View {
        VStack(spacing: 30) {
            Triangle()
                .fill(Color.blue)
                .frame(width: 100, height: 100)
            
            Triangle()
                .stroke(Color.red, lineWidth: 3)
                .frame(width: 100, height: 100)
        }
    }
}
```

#### 2.2 复杂自定义形状
```swift
struct Star: Shape {
    let points: Int
    let innerRatio: Double
    
    init(points: Int = 5, innerRatio: Double = 0.5) {
        self.points = points
        self.innerRatio = innerRatio
    }
    
    func path(in rect: CGRect) -> Path {
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width, rect.height) / 2
        
        var path = Path()
        let angle = Double.pi * 2 / Double(points)
        
        for i in 0..<points {
            let outerAngle = Double(i) * angle - Double.pi / 2
            let innerAngle = outerAngle + angle / 2
            
            let outerPoint = CGPoint(
                x: center.x + radius * cos(outerAngle),
                y: center.y + radius * sin(outerAngle)
            )
            
            let innerPoint = CGPoint(
                x: center.x + radius * innerRatio * cos(innerAngle),
                y: center.y + radius * innerRatio * sin(innerAngle)
            )
            
            if i == 0 {
                path.move(to: outerPoint)
            } else {
                path.addLine(to: outerPoint)
            }
            
            path.addLine(to: innerPoint)
        }
        
        path.closeSubpath()
        return path
    }
}

struct StarExample: View {
    var body: some View {
        VStack(spacing: 30) {
            Star(points: 5, innerRatio: 0.5)
                .fill(Color.yellow)
                .frame(width: 100, height: 100)
            
            Star(points: 6, innerRatio: 0.3)
                .fill(Color.orange)
                .frame(width: 100, height: 100)
        }
    }
}
```

## 3. SwiftUI中的动画系统

### 问题：SwiftUI中如何实现复杂的动画？请举例说明

**答案详解：**

#### 3.1 基本动画
```swift
struct BasicAnimationExample: View {
    @State private var isAnimating = false
    @State private var scale: CGFloat = 1.0
    @State private var rotation: Double = 0
    
    var body: some View {
        VStack(spacing: 30) {
            // 缩放动画
            Circle()
                .fill(Color.blue)
                .frame(width: 100, height: 100)
                .scaleEffect(scale)
                .animation(.easeInOut(duration: 1).repeatForever(autoreverses: true), value: scale)
                .onAppear {
                    scale = 1.5
                }
            
            // 旋转动画
            Image(systemName: "star.fill")
                .font(.system(size: 50))
                .foregroundColor(.yellow)
                .rotationEffect(.degrees(rotation))
                .animation(.linear(duration: 2).repeatForever(autoreverses: false), value: rotation)
                .onAppear {
                    rotation = 360
                }
            
            // 透明度动画
            Rectangle()
                .fill(Color.green)
                .frame(width: 100, height: 100)
                .opacity(isAnimating ? 0.3 : 1.0)
                .animation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true), value: isAnimating)
                .onAppear {
                    isAnimating = true
                }
        }
    }
}
```

#### 3.2 复杂动画序列
```swift
struct ComplexAnimationExample: View {
    @State private var animationPhase = 0
    @State private var offset: CGFloat = 0
    @State private var opacity: Double = 0
    @State private var scale: CGFloat = 0.5
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Animated Text")
                .font(.title)
                .offset(x: offset)
                .opacity(opacity)
                .scaleEffect(scale)
                .animation(.easeInOut(duration: 0.8), value: animationPhase)
            
            Button("Start Animation") {
                withAnimation(.easeInOut(duration: 0.8)) {
                    animationPhase += 1
                    
                    switch animationPhase % 4 {
                    case 0:
                        offset = 0
                        opacity = 1
                        scale = 1
                    case 1:
                        offset = 100
                        opacity = 0.5
                        scale = 1.2
                    case 2:
                        offset = -100
                        opacity = 0.8
                        scale = 0.8
                    case 3:
                        offset = 0
                        opacity = 1
                        scale = 1
                    default:
                        break
                    }
                }
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
        .onAppear {
            // 初始动画
            withAnimation(.easeOut(duration: 1.0)) {
                offset = 0
                opacity = 1
                scale = 1
            }
        }
    }
}
```

#### 3.3 路径动画
```swift
struct PathAnimationExample: View {
    @State private var animationProgress: CGFloat = 0
    
    var body: some View {
        VStack {
            // 绘制路径
            Path { path in
                path.move(to: CGPoint(x: 50, y: 50))
                path.addLine(to: CGPoint(x: 150, y: 50))
                path.addLine(to: CGPoint(x: 150, y: 150))
                path.addLine(to: CGPoint(x: 50, y: 150))
                path.closeSubpath()
            }
            .trim(from: 0, to: animationProgress)
            .stroke(Color.blue, lineWidth: 3)
            .frame(width: 200, height: 200)
            .animation(.easeInOut(duration: 2).repeatForever(autoreverses: true), value: animationProgress)
            .onAppear {
                animationProgress = 1.0
            }
            
            // 圆形进度条
            Circle()
                .trim(from: 0, to: animationProgress)
                .stroke(Color.green, lineWidth: 8)
                .frame(width: 100, height: 100)
                .rotationEffect(.degrees(-90))
                .animation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true), value: animationProgress)
        }
    }
}
```

## 4. SwiftUI中的手势识别

### 问题：SwiftUI中如何实现手势识别？请举例说明

**答案详解：**

#### 4.1 基本手势
```swift
struct BasicGesturesExample: View {
    @State private var offset = CGSize.zero
    @State private var scale: CGFloat = 1.0
    @State private var rotation: Double = 0
    
    var body: some View {
        VStack(spacing: 30) {
            // 拖拽手势
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.blue)
                .frame(width: 150, height: 100)
                .offset(offset)
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            offset = value.translation
                        }
                        .onEnded { _ in
                            withAnimation(.spring()) {
                                offset = .zero
                            }
                        }
                )
            
            // 缩放手势
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.green)
                .frame(width: 150, height: 100)
                .scaleEffect(scale)
                .gesture(
                    MagnificationGesture()
                        .onChanged { value in
                            scale = value
                        }
                        .onEnded { _ in
                            withAnimation(.spring()) {
                                scale = 1.0
                            }
                        }
                )
            
            // 旋转手势
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.orange)
                .frame(width: 150, height: 100)
                .rotationEffect(.degrees(rotation))
                .gesture(
                    RotationGesture()
                        .onChanged { value in
                            rotation = value.degrees
                        }
                        .onEnded { _ in
                            withAnimation(.spring()) {
                                rotation = 0
                            }
                        }
                )
        }
    }
}
```

#### 4.2 组合手势
```swift
struct CombinedGesturesExample: View {
    @State private var offset = CGSize.zero
    @State private var scale: CGFloat = 1.0
    @State private var rotation: Double = 0
    
    var body: some View {
        VStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.purple)
                .frame(width: 200, height: 150)
                .offset(offset)
                .scaleEffect(scale)
                .rotationEffect(.degrees(rotation))
                .gesture(
                    SimultaneousGesture(
                        DragGesture()
                            .onChanged { value in
                                offset = value.translation
                            }
                            .onEnded { _ in
                                withAnimation(.spring()) {
                                    offset = .zero
                                }
                            },
                        MagnificationGesture()
                            .onChanged { value in
                                scale = value
                            }
                            .onEnded { _ in
                                withAnimation(.spring()) {
                                    scale = 1.0
                                }
                            }
                    )
                )
            
            Text("Drag and Scale")
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
}
```

#### 4.3 长按手势
```swift
struct LongPressGestureExample: View {
    @State private var isPressed = false
    @State private var showAlert = false
    
    var body: some View {
        VStack(spacing: 30) {
            Circle()
                .fill(isPressed ? Color.red : Color.blue)
                .frame(width: 100, height: 100)
                .scaleEffect(isPressed ? 1.2 : 1.0)
                .animation(.easeInOut(duration: 0.2), value: isPressed)
                .gesture(
                    LongPressGesture(minimumDuration: 1.0)
                        .onChanged { _ in
                            isPressed = true
                        }
                        .onEnded { _ in
                            isPressed = false
                            showAlert = true
                        }
                )
            
            Text("Long Press Me!")
                .font(.headline)
        }
        .alert("Long Press Detected!", isPresented: $showAlert) {
            Button("OK") { }
        }
    }
}
```

## 5. SwiftUI中的环境对象

### 问题：什么是环境对象？如何使用？

**答案详解：**

#### 5.1 基本环境对象
```swift
class UserPreferences: ObservableObject {
    @Published var isDarkMode = false
    @Published var fontSize: CGFloat = 16
    @Published var accentColor = Color.blue
    @Published var language = "English"
}

struct EnvironmentObjectExample: View {
    @StateObject var preferences = UserPreferences()
    
    var body: some View {
        NavigationView {
            VStack {
                MainContentView()
            }
            .navigationTitle("Settings")
        }
        .environmentObject(preferences)
    }
}

struct MainContentView: View {
    @EnvironmentObject var preferences: UserPreferences
    
    var body: some View {
        Form {
            Section("Appearance") {
                Toggle("Dark Mode", isOn: $preferences.isDarkMode)
                
                HStack {
                    Text("Font Size")
                    Slider(value: $preferences.fontSize, in: 12...24, step: 1)
                    Text("\(Int(preferences.fontSize))")
                }
                
                ColorPicker("Accent Color", selection: $preferences.accentColor)
            }
            
            Section("Language") {
                Picker("Language", selection: $preferences.language) {
                    Text("English").tag("English")
                    Text("Spanish").tag("Spanish")
                    Text("French").tag("French")
                }
            }
        }
    }
}
```

#### 5.2 环境值
```swift
struct CustomEnvironmentKey: EnvironmentKey {
    static let defaultValue: String = "Default Value"
}

extension EnvironmentValues {
    var customValue: String {
        get { self[CustomEnvironmentKey.self] }
        set { self[CustomEnvironmentKey.self] = newValue }
    }
}

struct EnvironmentValueExample: View {
    var body: some View {
        VStack {
            ChildView()
        }
        .environment(\.customValue, "Custom Value")
    }
}

struct ChildView: View {
    @Environment(\.customValue) var customValue
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack {
            Text("Custom Value: \(customValue)")
            Text("Color Scheme: \(colorScheme == .dark ? "Dark" : "Light")")
        }
    }
}
```

## 6. SwiftUI中的性能优化

### 问题：如何优化SwiftUI应用的性能？

**答案详解：**

#### 6.1 使用LazyVStack和LazyHStack
```swift
struct PerformanceOptimizationExample: View {
    let items = Array(1...10000)
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 10) {
                ForEach(items, id: \.self) { item in
                    ItemRow(item: item)
                }
            }
        }
    }
}

struct ItemRow: View {
    let item: Int
    
    var body: some View {
        HStack {
            Text("Item \(item)")
                .font(.headline)
            Spacer()
            Text("Details")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color.gray.opacity(0.1))
    }
}
```

#### 6.2 使用@StateObject和@ObservedObject
```swift
class DataManager: ObservableObject {
    @Published var data: [String] = []
    
    init() {
        loadData()
    }
    
    private func loadData() {
        // 模拟数据加载
        data = Array(1...100).map { "Item \($0)" }
    }
}

struct OptimizedDataView: View {
    @StateObject private var dataManager = DataManager()
    
    var body: some View {
        List(dataManager.data, id: \.self) { item in
            Text(item)
        }
    }
}
```

#### 6.3 避免不必要的视图更新
```swift
struct OptimizedView: View {
    @State private var counter = 0
    
    var body: some View {
        VStack {
            // 使用@ViewBuilder避免不必要的计算
            counterView
            
            Button("Increment") {
                counter += 1
            }
        }
    }
    
    @ViewBuilder
    private var counterView: some View {
        if counter > 10 {
            Text("High Count: \(counter)")
                .foregroundColor(.red)
        } else {
            Text("Count: \(counter)")
                .foregroundColor(.blue)
        }
    }
}
```

## 7. SwiftUI中的测试

### 问题：如何测试SwiftUI视图？

**答案详解：**

#### 7.1 基本视图测试
```swift
import XCTest
@testable import YourApp

class SwiftUITests: XCTestCase {
    func testContentViewInitialState() {
        let contentView = ContentView()
        let view = contentView.body
        
        // 测试视图是否存在
        XCTAssertNotNil(view)
    }
    
    func testButtonTap() {
        let contentView = ContentView()
        let button = contentView.body.findButton(withTitle: "Tap Me")
        
        // 模拟按钮点击
        button?.tap()
        
        // 验证状态变化
        // 这里需要根据具体实现来验证
    }
}

// 扩展来查找按钮
extension View {
    func findButton(withTitle title: String) -> Button<Text>? {
        // 实现查找逻辑
        return nil
    }
}
```

#### 7.2 预览测试
```swift
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
                .previewDisplayName("Default")
            
            ContentView()
                .preferredColorScheme(.dark)
                .previewDisplayName("Dark Mode")
            
            ContentView()
                .previewDevice("iPhone SE (3rd generation)")
                .previewDisplayName("iPhone SE")
        }
    }
}
```

## 总结

SwiftUI的高级特性为开发者提供了强大的工具：
1. **自定义修饰符**：创建可重用的样式
2. **自定义形状**：实现独特的视觉效果
3. **动画系统**：创建流畅的用户体验
4. **手势识别**：增强用户交互
5. **环境对象**：全局状态管理
6. **性能优化**：提升应用性能
7. **测试**：确保代码质量

掌握这些高级特性可以创建更专业、更高效的SwiftUI应用。
