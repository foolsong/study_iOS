# iOS性能优化与调试面试题详解

## 1. 内存管理

### 问题：iOS中如何优化内存使用？如何避免内存泄漏？

**答案详解：**

#### 1.1 内存泄漏检测
```swift
class MemoryLeakDetector {
    static let shared = MemoryLeakDetector()
    private var objectTracker: [String: WeakReference] = [:]
    
    private init() {}
    
    func trackObject(_ object: AnyObject, name: String) {
        let weakRef = WeakReference(object: object)
        objectTracker[name] = weakRef
    }
    
    func checkForLeaks() {
        for (name, weakRef) in objectTracker {
            if weakRef.object == nil {
                print("✅ Object '\(name)' was properly deallocated")
            } else {
                print("⚠️ Potential memory leak detected for '\(name)'")
            }
        }
    }
}

class WeakReference {
    weak var object: AnyObject?
    
    init(object: AnyObject) {
        self.object = object
    }
}

// 使用示例
class ExampleViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        MemoryLeakDetector.shared.trackObject(self, name: "ExampleViewController")
    }
    
    deinit {
        print("ExampleViewController deallocated")
    }
}
```

#### 1.2 循环引用解决方案
```swift
class NetworkManager {
    private var completionHandlers: [String: (Result<Data, Error>) -> Void] = [:]
    
    // 错误示例：强引用循环
    func fetchDataWithStrongReference(url: String, completion: @escaping (Result<Data, Error>) -> Void) {
        completionHandlers[url] = completion
        
        // 模拟网络请求
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            // 这里会创建强引用循环
            self.completionHandlers[url]?(.success(Data()))
        }
    }
    
    // 正确示例：使用weak self
    func fetchDataWithWeakReference(url: String, completion: @escaping (Result<Data, Error>) -> Void) {
        completionHandlers[url] = completion
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            self.completionHandlers[url]?(.success(Data()))
        }
    }
    
    // 更好的解决方案：使用unowned
    func fetchDataWithUnowned(url: String, completion: @escaping (Result<Data, Error>) -> Void) {
        completionHandlers[url] = completion
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [unowned self] in
            self.completionHandlers[url]?(.success(Data()))
        }
    }
}

// 使用weak和unowned的场景
class ViewController: UIViewController {
    private var networkManager = NetworkManager()
    private var dataTask: URLSessionDataTask?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNetworkCallbacks()
    }
    
    private func setupNetworkCallbacks() {
        // 使用weak self，因为网络请求可能比视图控制器生命周期长
        networkManager.fetchDataWithWeakReference(url: "https://api.example.com/data") { [weak self] result in
            guard let self = self else { return }
            self.handleResult(result)
        }
    }
    
    private func handleResult(_ result: Result<Data, Error>) {
        // 处理结果
    }
    
    deinit {
        dataTask?.cancel()
    }
}
```

#### 1.3 内存警告处理
```swift
class MemoryEfficientViewController: UIViewController {
    private var imageCache: [String: UIImage] = [:]
    private var heavyData: [String: Any] = [:]
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        // 清理图片缓存
        imageCache.removeAll()
        
        // 清理重数据
        heavyData.removeAll()
        
        // 通知子视图控制器
        children.forEach { $0.didReceiveMemoryWarning() }
        
        print("Memory warning received, cleaned up resources")
    }
    
    // 智能缓存管理
    func cacheImage(_ image: UIImage, forKey key: String) {
        // 检查缓存大小
        if imageCache.count > 50 {
            // 清理最旧的缓存
            let oldestKey = imageCache.keys.first
            if let key = oldestKey {
                imageCache.removeValue(forKey: key)
            }
        }
        
        imageCache[key] = image
    }
    
    // 延迟加载
    private lazy var expensiveView: UIView = {
        let view = UIView()
        // 复杂的视图设置
        return view
    }()
}
```

## 2. 性能优化

### 问题：如何提升iOS应用的性能？有哪些优化技巧？

**答案详解：**

#### 2.1 图片优化
```swift
class ImageOptimizer {
    
    // 图片压缩
    static func compressImage(_ image: UIImage, maxSize: Int) -> Data? {
        var compression: CGFloat = 1.0
        var data = image.jpegData(compressionQuality: compression)
        
        while data?.count ?? 0 > maxSize && compression > 0.1 {
            compression -= 0.1
            data = image.jpegData(compressionQuality: compression)
        }
        
        return data
    }
    
    // 图片缩放
    static func resizeImage(_ image: UIImage, to size: CGSize) -> UIImage? {
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { context in
            image.draw(in: CGRect(origin: .zero, size: size))
        }
    }
    
    // 异步图片处理
    static func processImageAsync(_ image: UIImage, completion: @escaping (UIImage?) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            let processedImage = self.processImage(image)
            
            DispatchQueue.main.async {
                completion(processedImage)
            }
        }
    }
    
    private static func processImage(_ image: UIImage) -> UIImage? {
        // 复杂的图片处理逻辑
        return image
    }
}

// 图片缓存管理
class ImageCache {
    static let shared = ImageCache()
    private let cache = NSCache<NSString, UIImage>()
    private let fileManager = FileManager.default
    private let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
    
    private init() {
        cache.countLimit = 100
        cache.totalCostLimit = 50 * 1024 * 1024 // 50MB
    }
    
    func setImage(_ image: UIImage, forKey key: String) {
        cache.setObject(image, forKey: key as NSString)
        
        // 保存到磁盘
        saveImageToDisk(image, forKey: key)
    }
    
    func getImage(forKey key: String) -> UIImage? {
        // 先从内存缓存获取
        if let cachedImage = cache.object(forKey: key as NSString) {
            return cachedImage
        }
        
        // 从磁盘加载
        if let diskImage = loadImageFromDisk(forKey: key) {
            cache.setObject(diskImage, forKey: key as NSString)
            return diskImage
        }
        
        return nil
    }
    
    private func saveImageToDisk(_ image: UIImage, forKey key: String) {
        let filePath = (documentsPath as NSString).appendingPathComponent("\(key).jpg")
        
        DispatchQueue.global(qos: .background).async {
            if let data = image.jpegData(compressionQuality: 0.8) {
                try? data.write(to: URL(fileURLWithPath: filePath))
            }
        }
    }
    
    private func loadImageFromDisk(forKey key: String) -> UIImage? {
        let filePath = (documentsPath as NSString).appendingPathComponent("\(key).jpg")
        return UIImage(contentsOfFile: filePath)
    }
}
```

#### 2.2 表格视图性能优化
```swift
class OptimizedTableViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private var dataSource: [String] = []
    private var cellHeights: [IndexPath: CGFloat] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        loadData()
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        // 预计算行高
        tableView.estimatedRowHeight = 60
        
        // 使用自动布局
        tableView.rowHeight = UITableView.automaticDimension
        
        // 预加载
        tableView.prefetchDataSource = self
        
        // 注册单元格
        tableView.register(UINib(nibName: "OptimizedTableViewCell", bundle: nil), 
                         forCellReuseIdentifier: "OptimizedCell")
    }
    
    private func loadData() {
        // 模拟大量数据
        dataSource = Array(1...1000).map { "Item \($0)" }
        tableView.reloadData()
    }
}

// MARK: - UITableViewDataSource
extension OptimizedTableViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OptimizedCell", for: indexPath) as! OptimizedTableViewCell
        
        // 避免在cellForRowAt中进行复杂计算
        let item = dataSource[indexPath.row]
        cell.configure(with: item)
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension OptimizedTableViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // 在willDisplay中进行复杂操作
        if let optimizedCell = cell as? OptimizedTableViewCell {
            optimizedCell.prepareForDisplay()
        }
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // 清理资源
        if let optimizedCell = cell as? OptimizedTableViewCell {
            optimizedCell.cleanup()
        }
    }
}

// MARK: - UITableViewDataSourcePrefetching
extension OptimizedTableViewController: UITableViewDataSourcePrefetching {
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        // 预加载数据
        for indexPath in indexPaths {
            let item = dataSource[indexPath.row]
            // 预加载图片或其他资源
            preloadResources(for: item)
        }
    }
    
    func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
        // 取消预加载
        for indexPath in indexPaths {
            let item = dataSource[indexPath.row]
            cancelPreloading(for: item)
        }
    }
    
    private func preloadResources(for item: String) {
        // 预加载逻辑
    }
    
    private func cancelPreloading(for item: String) {
        // 取消预加载逻辑
    }
}

// 优化的单元格
class OptimizedTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var thumbnailImageView: UIImageView!
    
    private var imageLoadTask: URLSessionDataTask?
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        // 取消之前的图片加载任务
        imageLoadTask?.cancel()
        imageLoadTask = nil
        
        // 重置UI状态
        titleLabel.text = nil
        subtitleLabel.text = nil
        thumbnailImageView.image = nil
    }
    
    func configure(with item: String) {
        titleLabel.text = item
        subtitleLabel.text = "Subtitle for \(item)"
        
        // 异步加载图片
        loadThumbnail(for: item)
    }
    
    func prepareForDisplay() {
        // 准备显示时的优化操作
        thumbnailImageView.layer.cornerRadius = 8
        thumbnailImageView.clipsToBounds = true
    }
    
    func cleanup() {
        // 清理资源
        imageLoadTask?.cancel()
        imageLoadTask = nil
    }
    
    private func loadThumbnail(for item: String) {
        // 模拟图片加载
        let url = URL(string: "https://example.com/thumbnails/\(item).jpg")!
        
        imageLoadTask = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self, let data = data else { return }
            
            DispatchQueue.main.async {
                self.thumbnailImageView.image = UIImage(data: data)
            }
        }
        
        imageLoadTask?.resume()
    }
}
```

#### 2.3 网络请求优化
```swift
class OptimizedNetworkManager {
    static let shared = OptimizedNetworkManager()
    private let session: URLSession
    private let cache = URLCache.shared
    private let operationQueue = OperationQueue()
    
    private init() {
        let config = URLSessionConfiguration.default
        config.requestCachePolicy = .returnCacheDataElseLoad
        config.urlCache = cache
        config.timeoutIntervalForRequest = 30
        config.timeoutIntervalForResource = 300
        
        session = URLSession(configuration: config)
        operationQueue.maxConcurrentOperationCount = 4
    }
    
    // 批量请求优化
    func batchRequest<T>(_ requests: [URLRequest], 
                        transform: @escaping (Data) -> T,
                        completion: @escaping ([Result<T, Error>]) -> Void) {
        
        let group = DispatchGroup()
        var results: [Result<T, Error>] = Array(repeating: .failure(NetworkError.unknown), count: requests.count)
        
        for (index, request) in requests.enumerated() {
            group.enter()
            
            let task = session.dataTask(with: request) { data, response, error in
                defer { group.leave() }
                
                if let error = error {
                    results[index] = .failure(error)
                    return
                }
                
                guard let data = data else {
                    results[index] = .failure(NetworkError.noData)
                    return
                }
                
                let transformed = transform(data)
                results[index] = .success(transformed)
            }
            
            task.resume()
        }
        
        group.notify(queue: .main) {
            completion(results)
        }
    }
    
    // 请求去重
    private var pendingRequests: [String: [NetworkCompletion]] = [:]
    
    func deduplicatedRequest<T>(_ request: URLRequest, 
                               transform: @escaping (Data) -> T,
                               completion: @escaping (Result<T, Error>) -> Void) {
        
        let key = request.url?.absoluteString ?? ""
        
        if pendingRequests[key] != nil {
            // 请求已在进行中，添加回调
            pendingRequests[key]?.append(NetworkCompletion(transform: transform, completion: completion))
        } else {
            // 开始新请求
            pendingRequests[key] = [NetworkCompletion(transform: transform, completion: completion)]
            
            let task = session.dataTask(with: request) { [weak self] data, response, error in
                self?.handleRequestCompletion(key: key, data: data, response: response, error: error)
            }
            
            task.resume()
        }
    }
    
    private func handleRequestCompletion<T>(key: String, data: Data?, response: URLResponse?, error: Error?) {
        guard let completions = pendingRequests[key] else { return }
        
        let result: Result<T, Error>
        if let error = error {
            result = .failure(error)
        } else if let data = data {
            // 这里需要根据实际类型处理
            result = .failure(NetworkError.unknown)
        } else {
            result = .failure(NetworkError.noData)
        }
        
        DispatchQueue.main.async {
            completions.forEach { completion in
                // 调用所有等待的回调
                completion.completion(result)
            }
        }
        
        pendingRequests.removeValue(forKey: key)
    }
}

struct NetworkCompletion {
    let transform: (Data) -> Any
    let completion: (Result<Any, Error>) -> Void
}

enum NetworkError: Error {
    case unknown
    case noData
}
```

## 3. 调试技巧

### 问题：iOS开发中有哪些调试技巧？如何使用？

**答案详解：**

#### 3.1 断点和调试器
```swift
class DebugExampleViewController: UIViewController {
    
    private var dataArray: [String] = []
    private var isProcessing = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 设置断点条件
        setupData()
        processData()
    }
    
    private func setupData() {
        // 在这里设置断点，条件：dataArray.count > 5
        dataArray = ["Item 1", "Item 2", "Item 3", "Item 4", "Item 5", "Item 6"]
        
        // 使用LLDB命令
        // po dataArray - 打印数组内容
        // p dataArray.count - 打印数组长度
        // bt - 打印调用栈
    }
    
    private func processData() {
        isProcessing = true
        
        // 使用符号断点
        for (index, item) in dataArray.enumerated() {
            // 在这里设置符号断点：-[NSString isEqualToString:]
            if item == "Item 3" {
                print("Found Item 3 at index \(index)")
                break
            }
        }
        
        isProcessing = false
    }
    
    // 使用断言
    func processUser(_ user: User?) {
        assert(user != nil, "User cannot be nil")
        assert(user?.name.isEmpty == false, "User name cannot be empty")
        
        // 处理用户数据
    }
    
    // 使用precondition
    func divide(_ a: Int, by b: Int) -> Int {
        precondition(b != 0, "Division by zero is not allowed")
        return a / b
    }
}
```

#### 3.2 日志系统
```swift
// 自定义日志系统
enum LogLevel: Int, CaseIterable {
    case debug = 0
    case info = 1
    case warning = 2
    case error = 3
    case fatal = 4
    
    var emoji: String {
        switch self {
        case .debug: return "🔍"
        case .info: return "ℹ️"
        case .warning: return "⚠️"
        case .error: return "❌"
        case .fatal: return "💥"
        }
    }
    
    var name: String {
        switch self {
        case .debug: return "DEBUG"
        case .info: return "INFO"
        case .warning: return "WARNING"
        case .error: return "ERROR"
        case .fatal: return "FATAL"
        }
    }
}

class Logger {
    static let shared = Logger()
    private let queue = DispatchQueue(label: "com.app.logger", qos: .utility)
    
    private init() {}
    
    func log(_ level: LogLevel, _ message: String, file: String = #file, function: String = #function, line: Int = #line) {
        #if DEBUG
        let fileName = URL(fileURLWithPath: file).lastPathComponent
        let timestamp = DateFormatter.logFormatter.string(from: Date())
        let logMessage = "\(timestamp) \(level.emoji) [\(level.name)] [\(fileName):\(line)] \(function): \(message)"
        
        print(logMessage)
        
        // 保存到文件
        saveToFile(logMessage)
        #endif
    }
    
    func debug(_ message: String, file: String = #file, function: String = #function, line: Int = #line) {
        log(.debug, message, file: file, function: function, line: line)
    }
    
    func info(_ message: String, file: String = #file, function: String = #function, line: Int = #line) {
        log(.info, message, file: file, function: function, line: line)
    }
    
    func warning(_ message: String, file: String = #file, function: String = #function, line: Int = #line) {
        log(.warning, message, file: file, function: function, line: line)
    }
    
    func error(_ message: String, file: String = #file, function: String = #function, line: Int = #line) {
        log(.error, message, file: file, function: function, line: line)
    }
    
    func fatal(_ message: String, file: String = #file, function: String = #function, line: Int = #line) {
        log(.fatal, message, file: file, function: function, line: line)
    }
    
    private func saveToFile(_ message: String) {
        queue.async {
            // 保存日志到文件
        }
    }
}

extension DateFormatter {
    static let logFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
        return formatter
    }()
}

// 使用示例
class LoggingExample {
    func performOperation() {
        Logger.shared.debug("Starting operation")
        
        do {
            // 执行操作
            Logger.shared.info("Operation completed successfully")
        } catch {
            Logger.shared.error("Operation failed: \(error.localizedDescription)")
        }
    }
}
```

#### 3.3 性能分析
```swift
class PerformanceProfiler {
    static let shared = PerformanceProfiler()
    private var measurements: [String: CFTimeInterval] = [:]
    
    private init() {}
    
    func startMeasuring(_ name: String) {
        measurements[name] = CACurrentMediaTime()
    }
    
    func stopMeasuring(_ name: String) {
        guard let startTime = measurements[name] else {
            print("No measurement started for: \(name)")
            return
        }
        
        let endTime = CACurrentMediaTime()
        let duration = endTime - startTime
        
        print("⏱️ \(name): \(String(format: "%.4f", duration)) seconds")
        measurements.removeValue(forKey: name)
    }
    
    // 测量代码块性能
    func measure<T>(_ name: String, block: () -> T) -> T {
        startMeasuring(name)
        let result = block()
        stopMeasuring(name)
        return result
    }
    
    // 异步性能测量
    func measureAsync<T>(_ name: String, block: @escaping () async -> T) async -> T {
        startMeasuring(name)
        let result = await block()
        stopMeasuring(name)
        return result
    }
}

// 使用示例
class PerformanceExample {
    func performExpensiveOperation() {
        PerformanceProfiler.shared.measure("Expensive Operation") {
            // 执行昂贵的操作
            var result = 0
            for i in 0..<1000000 {
                result += i
            }
            return result
        }
    }
    
    func performAsyncOperation() async {
        await PerformanceProfiler.shared.measureAsync("Async Operation") {
            // 执行异步操作
            try await Task.sleep(nanoseconds: 1_000_000_000) // 1秒
            return "Async result"
        }
    }
}
```

## 4. 工具使用

### 问题：iOS开发中有哪些调试工具？如何使用？

**答案详解：**

#### 4.1 Instruments使用
```swift
class InstrumentsExample {
    
    // 内存泄漏检测
    func detectMemoryLeaks() {
        // 在Instruments中使用Leaks工具
        // 1. 启动应用
        // 2. 在Instruments中选择Leaks模板
        // 3. 执行可能导致内存泄漏的操作
        // 4. 查看泄漏报告
        
        var strongReference: AnyObject?
        
        // 模拟内存泄漏
        strongReference = self as AnyObject
        
        // 在Instruments中应该能看到这个泄漏
    }
    
    // CPU使用率分析
    func analyzeCPUUsage() {
        // 在Instruments中使用Time Profiler工具
        // 1. 选择Time Profiler模板
        // 2. 执行CPU密集型操作
        // 3. 查看调用栈和耗时
        
        // 模拟CPU密集型操作
        for _ in 0..<1000000 {
            let _ = sqrt(Double.random(in: 0...1000))
        }
    }
    
    // 网络请求分析
    func analyzeNetworkRequests() {
        // 在Instruments中使用Network工具
        // 1. 选择Network模板
        // 2. 执行网络请求
        // 3. 查看请求详情和性能
        
        let url = URL(string: "https://api.example.com/data")!
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            // 处理响应
        }
        task.resume()
    }
}
```

#### 4.2 调试菜单
```swift
class DebugMenuViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDebugMenu()
    }
    
    private func setupDebugMenu() {
        #if DEBUG
        let debugButton = UIBarButtonItem(title: "Debug", style: .plain, target: self, action: #selector(showDebugMenu))
        navigationItem.rightBarButtonItem = debugButton
        #endif
    }
    
    @objc private func showDebugMenu() {
        let alert = UIAlertController(title: "Debug Menu", message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Clear Cache", style: .default) { _ in
            self.clearCache()
        })
        
        alert.addAction(UIAlertAction(title: "Reset User Defaults", style: .default) { _ in
            self.resetUserDefaults()
        })
        
        alert.addAction(UIAlertAction(title: "Show Memory Info", style: .default) { _ in
            self.showMemoryInfo()
        })
        
        alert.addAction(UIAlertAction(title: "Crash App", style: .destructive) { _ in
            self.crashApp()
        })
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        present(alert, animated: true)
    }
    
    private func clearCache() {
        // 清理缓存
        URLCache.shared.removeAllCachedResponses()
        Logger.shared.info("Cache cleared")
    }
    
    private func resetUserDefaults() {
        // 重置用户默认值
        if let bundleIdentifier = Bundle.main.bundleIdentifier {
            UserDefaults.standard.removePersistentDomain(forName: bundleIdentifier)
        }
        Logger.shared.info("User defaults reset")
    }
    
    private func showMemoryInfo() {
        var info = mach_task_basic_info()
        var count = mach_msg_type_number_t(MemoryLayout<mach_task_basic_info>.size)/4
        
        let kerr: kern_return_t = withUnsafeMutablePointer(to: &info) {
            $0.withMemoryRebound(to: integer_t.self, capacity: 1) {
                task_info(mach_task_self_,
                         task_flavor_t(MACH_TASK_BASIC_INFO),
                         $0,
                         &count)
            }
        }
        
        if kerr == KERN_SUCCESS {
            let memoryUsage = info.resident_size / 1024 / 1024 // MB
            Logger.shared.info("Memory usage: \(memoryUsage) MB")
        }
    }
    
    private func crashApp() {
        // 故意崩溃应用用于测试
        fatalError("Debug crash triggered")
    }
}
```

## 总结

iOS性能优化和调试的关键点：
1. **内存管理**：避免循环引用，及时释放资源
2. **性能优化**：图片优化、表格视图优化、网络请求优化
3. **调试技巧**：断点、日志、性能分析
4. **工具使用**：Instruments、调试菜单

掌握这些技巧可以创建更高效、更稳定的iOS应用。
