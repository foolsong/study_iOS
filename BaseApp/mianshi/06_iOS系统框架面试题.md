# iOS系统框架面试题详解

## 1. Foundation框架

### 问题：Foundation框架中有哪些重要的类？如何使用？

**答案详解：**

#### 1.1 字符串处理（NSString/NSMutableString）
```swift
// 字符串创建和操作
let string = NSString(string: "Hello, World!")
let mutableString = NSMutableString(string: "Hello")

// 字符串方法
let range = string.range(of: "World")
let substring = string.substring(with: range)
let components = string.components(separatedBy: ", ")

// 字符串格式化
let formattedString = String(format: "Value: %.2f", 3.14159)
let attributedString = NSAttributedString(string: "Bold Text", attributes: [
    .font: UIFont.boldSystemFont(ofSize: 16),
    .foregroundColor: UIColor.red
])
```

#### 1.2 集合类（NSArray/NSDictionary/NSSet）
```swift
// NSArray
let array = NSArray(array: [1, 2, 3, 4, 5])
let filteredArray = array.filtered(using: NSPredicate(format: "self > 2"))
let sortedArray = array.sortedArray(using: [NSSortDescriptor(key: "self", ascending: false)])

// NSDictionary
let dictionary = NSDictionary(dictionary: ["name": "John", "age": 30])
let allKeys = dictionary.allKeys
let allValues = dictionary.allValues

// NSSet
let set = NSSet(array: [1, 2, 3, 3, 4]) // 自动去重
let mutableSet = NSMutableSet(set: set)
mutableSet.add(5)
mutableSet.remove(1)
```

#### 1.3 日期和时间处理（NSDate/NSDateFormatter）
```swift
// 日期创建和操作
let now = NSDate()
let tomorrow = now.addingTimeInterval(24 * 60 * 60)
let yesterday = now.addingTimeInterval(-24 * 60 * 60)

// 日期格式化
let formatter = DateFormatter()
formatter.dateStyle = .full
formatter.timeStyle = .medium
formatter.locale = Locale(identifier: "zh_CN")

let dateString = formatter.string(from: now)

// 自定义格式
let customFormatter = DateFormatter()
customFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
let customDateString = customFormatter.string(from: now)

// 日期组件
let calendar = Calendar.current
let components = calendar.dateComponents([.year, .month, .day], from: now)
let year = components.year
let month = components.month
let day = components.day
```

#### 1.4 文件操作（NSFileManager）
```swift
class FileManagerHelper {
    static let shared = FileManagerHelper()
    private let fileManager = FileManager.default
    
    // 获取文档目录
    func getDocumentsDirectory() -> URL {
        return fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
    }
    
    // 创建目录
    func createDirectory(at path: String) throws {
        let url = getDocumentsDirectory().appendingPathComponent(path)
        try fileManager.createDirectory(at: url, withIntermediateDirectories: true)
    }
    
    // 写入文件
    func writeFile(_ data: Data, to path: String) throws {
        let url = getDocumentsDirectory().appendingPathComponent(path)
        try data.write(to: url)
    }
    
    // 读取文件
    func readFile(from path: String) throws -> Data {
        let url = getDocumentsDirectory().appendingPathComponent(path)
        return try Data(contentsOf: url)
    }
    
    // 删除文件
    func deleteFile(at path: String) throws {
        let url = getDocumentsDirectory().appendingPathComponent(path)
        try fileManager.removeItem(at: url)
    }
    
    // 检查文件是否存在
    func fileExists(at path: String) -> Bool {
        let url = getDocumentsDirectory().appendingPathComponent(path)
        return fileManager.fileExists(atPath: url.path)
    }
    
    // 获取文件属性
    func getFileAttributes(at path: String) throws -> [FileAttributeKey: Any] {
        let url = getDocumentsDirectory().appendingPathComponent(path)
        return try fileManager.attributesOfItem(atPath: url.path)
    }
}
```

## 2. UIKit框架

### 问题：UIKit中有哪些重要的类和概念？如何使用？

**答案详解：**

#### 2.1 视图控制器生命周期
```swift
class CustomViewController: UIViewController {
    
    // MARK: - 生命周期方法
    
    override func loadView() {
        super.loadView()
        // 创建视图层次结构
        setupView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 视图加载完成后的设置
        setupData()
        setupConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 视图即将显示
        prepareForDisplay()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // 视图已经显示
        startAnimations()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // 视图即将消失
        stopAnimations()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        // 视图已经消失
        cleanup()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        // 即将布局子视图
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // 已经布局子视图
    }
    
    // MARK: - 内存警告
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // 处理内存警告
        clearCache()
    }
    
    // MARK: - 私有方法
    private func setupView() {
        // 设置视图
    }
    
    private func setupData() {
        // 设置数据
    }
    
    private func setupConstraints() {
        // 设置约束
    }
    
    private func prepareForDisplay() {
        // 准备显示
    }
    
    private func startAnimations() {
        // 开始动画
    }
    
    private func stopAnimations() {
        // 停止动画
    }
    
    private func cleanup() {
        // 清理资源
    }
    
    private func clearCache() {
        // 清理缓存
    }
}
```

#### 2.2 自动布局（Auto Layout）
```swift
class AutoLayoutExampleViewController: UIViewController {
    
    private let redView = UIView()
    private let blueView = UIView()
    private let greenView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
    }
    
    private func setupViews() {
        redView.backgroundColor = .red
        blueView.backgroundColor = .blue
        greenView.backgroundColor = .green
        
        view.addSubview(redView)
        view.addSubview(blueView)
        view.addSubview(greenView)
        
        // 禁用自动转换
        redView.translatesAutoresizingMaskIntoConstraints = false
        blueView.translatesAutoresizingMaskIntoConstraints = false
        greenView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupConstraints() {
        // 红色视图约束
        NSLayoutConstraint.activate([
            redView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            redView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            redView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            redView.heightAnchor.constraint(equalToConstant: 100)
        ])
        
        // 蓝色视图约束
        NSLayoutConstraint.activate([
            blueView.topAnchor.constraint(equalTo: redView.bottomAnchor, constant: 20),
            blueView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            blueView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5, constant: -30),
            blueView.heightAnchor.constraint(equalToConstant: 100)
        ])
        
        // 绿色视图约束
        NSLayoutConstraint.activate([
            greenView.topAnchor.constraint(equalTo: redView.bottomAnchor, constant: 20),
            greenView.leadingAnchor.constraint(equalTo: blueView.trailingAnchor, constant: 20),
            greenView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            greenView.heightAnchor.constraint(equalToConstant: 100)
        ])
    }
    
    // 动态约束更新
    func updateConstraints() {
        UIView.animate(withDuration: 0.3) {
            // 更新约束
            self.view.layoutIfNeeded()
        }
    }
}
```

#### 2.3 表格视图（UITableView）
```swift
class TableViewExampleViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private var dataSource: [String] = []
    private let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupRefreshControl()
        loadData()
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        // 注册自定义单元格
        tableView.register(UINib(nibName: "CustomTableViewCell", bundle: nil), 
                         forCellReuseIdentifier: "CustomCell")
        
        // 设置表格视图样式
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = .lightGray
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        
        // 设置背景
        tableView.backgroundColor = .systemBackground
        
        // 设置行高
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 60
    }
    
    private func setupRefreshControl() {
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        refreshControl.attributedTitle = NSAttributedString(string: "下拉刷新")
        tableView.refreshControl = refreshControl
    }
    
    @objc private func refreshData() {
        // 模拟网络请求
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.loadData()
            self.refreshControl.endRefreshing()
        }
    }
    
    private func loadData() {
        // 加载数据
        dataSource = ["Item 1", "Item 2", "Item 3", "Item 4", "Item 5"]
        tableView.reloadData()
    }
}

// MARK: - UITableViewDataSource
extension TableViewExampleViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as! CustomTableViewCell
        
        let item = dataSource[indexPath.row]
        cell.configure(with: item)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            dataSource.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}

// MARK: - UITableViewDelegate
extension TableViewExampleViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let item = dataSource[indexPath.row]
        print("Selected: \(item)")
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = .systemGray6
        
        let label = UILabel()
        label.text = "Section Header"
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        headerView.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 15),
            label.centerYAnchor.constraint(equalTo: headerView.centerYAnchor)
        ])
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
}
```

#### 2.4 集合视图（UICollectionView）
```swift
class CollectionViewExampleViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var dataSource: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        loadData()
    }
    
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        
        // 注册自定义单元格
        collectionView.register(UINib(nibName: "CustomCollectionViewCell", bundle: nil), 
                              forCellWithReuseIdentifier: "CustomCell")
        
        // 注册头部和尾部视图
        collectionView.register(UINib(nibName: "CustomHeaderView", bundle: nil), 
                              forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, 
                              withReuseIdentifier: "HeaderView")
        
        // 设置布局
        let layout = createLayout()
        collectionView.setCollectionViewLayout(layout, animated: false)
        
        // 设置背景
        collectionView.backgroundColor = .systemBackground
    }
    
    private func createLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(100)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 10
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(50)
        )
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
        section.boundarySupplementaryItems = [header]
        
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    private func loadData() {
        dataSource = ["Item 1", "Item 2", "Item 3", "Item 4", "Item 5"]
        collectionView.reloadData()
    }
}

// MARK: - UICollectionViewDataSource
extension CollectionViewExampleViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomCell", for: indexPath) as! CustomCollectionViewCell
        
        let item = dataSource[indexPath.item]
        cell.configure(with: item)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let headerView = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: "HeaderView",
                for: indexPath
            ) as! CustomHeaderView
            
            headerView.configure(with: "Section Header")
            return headerView
        }
        
        return UICollectionReusableView()
    }
}

// MARK: - UICollectionViewDelegate
extension CollectionViewExampleViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = dataSource[indexPath.item]
        print("Selected: \(item)")
    }
    
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.alpha = 0.5
    }
    
    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.alpha = 1.0
    }
}
```

## 3. Core Data框架

### 问题：什么是Core Data？如何使用？

**答案详解：**

#### 3.1 Core Data概述
Core Data是iOS的数据持久化框架，提供了对象图管理和持久化存储功能。

#### 3.2 数据模型设计
```swift
// 实体定义
// User实体
class User: NSManagedObject {
    @NSManaged var id: String
    @NSManaged var name: String
    @NSManaged var email: String
    @NSManaged var posts: Set<Post>
}

// Post实体
class Post: NSManagedObject {
    @NSManaged var id: String
    @NSManaged var title: String
    @NSManaged var content: String
    @NSManaged var createdAt: Date
    @NSManaged var author: User
}

// 扩展方法
extension User {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }
}

extension Post {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Post> {
        return NSFetchRequest<Post>(entityName: "Post")
    }
}
```

#### 3.3 Core Data管理器
```swift
class CoreDataManager {
    static let shared = CoreDataManager()
    
    private init() {}
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "DataModel")
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Core Data error: \(error)")
            }
        }
        return container
    }()
    
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    // 保存上下文
    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("Core Data save error: \(error)")
            }
        }
    }
    
    // 创建用户
    func createUser(id: String, name: String, email: String) -> User {
        let user = User(context: context)
        user.id = id
        user.name = name
        user.email = email
        return user
    }
    
    // 创建文章
    func createPost(id: String, title: String, content: String, author: User) -> Post {
        let post = Post(context: context)
        post.id = id
        post.title = title
        post.content = content
        post.createdAt = Date()
        post.author = author
        return post
    }
    
    // 获取所有用户
    func fetchUsers() -> [User] {
        let request: NSFetchRequest<User> = User.fetchRequest()
        
        do {
            return try context.fetch(request)
        } catch {
            print("Fetch users error: \(error)")
            return []
        }
    }
    
    // 根据ID获取用户
    func fetchUser(by id: String) -> User? {
        let request: NSFetchRequest<User> = User.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id)
        request.fetchLimit = 1
        
        do {
            let users = try context.fetch(request)
            return users.first
        } catch {
            print("Fetch user error: \(error)")
            return nil
        }
    }
    
    // 获取用户的所有文章
    func fetchPosts(for user: User) -> [Post] {
        let request: NSFetchRequest<Post> = Post.fetchRequest()
        request.predicate = NSPredicate(format: "author == %@", user)
        request.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: false)]
        
        do {
            return try context.fetch(request)
        } catch {
            print("Fetch posts error: \(error)")
            return []
        }
    }
    
    // 删除用户
    func deleteUser(_ user: User) {
        context.delete(user)
        saveContext()
    }
    
    // 删除文章
    func deletePost(_ post: Post) {
        context.delete(post)
        saveContext()
    }
    
    // 搜索文章
    func searchPosts(query: String) -> [Post] {
        let request: NSFetchRequest<Post> = Post.fetchRequest()
        request.predicate = NSPredicate(format: "title CONTAINS[cd] %@ OR content CONTAINS[cd] %@", query, query)
        request.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: false)]
        
        do {
            return try context.fetch(request)
        } catch {
            print("Search posts error: \(error)")
            return []
        }
    }
}
```

#### 3.4 使用示例
```swift
class CoreDataExampleViewController: UIViewController {
    
    private let coreDataManager = CoreDataManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        demonstrateCoreData()
    }
    
    private func demonstrateCoreData() {
        // 创建用户
        let user = coreDataManager.createUser(id: "1", name: "John Doe", email: "john@example.com")
        
        // 创建文章
        let post1 = coreDataManager.createPost(id: "1", title: "First Post", content: "This is my first post", author: user)
        let post2 = coreDataManager.createPost(id: "2", title: "Second Post", content: "This is my second post", author: user)
        
        // 保存到Core Data
        coreDataManager.saveContext()
        
        // 获取所有用户
        let users = coreDataManager.fetchUsers()
        print("Users: \(users.count)")
        
        // 获取特定用户
        if let fetchedUser = coreDataManager.fetchUser(by: "1") {
            print("User: \(fetchedUser.name)")
            
            // 获取用户的文章
            let posts = coreDataManager.fetchPosts(for: fetchedUser)
            print("Posts: \(posts.count)")
        }
        
        // 搜索文章
        let searchResults = coreDataManager.searchPosts(query: "first")
        print("Search results: \(searchResults.count)")
    }
}
```

## 4. 网络框架

### 问题：iOS中如何实现网络请求？有哪些方式？

**答案详解：**

#### 4.1 URLSession基础使用
```swift
class NetworkManager {
    static let shared = NetworkManager()
    private let session = URLSession.shared
    
    private init() {}
    
    // 基本GET请求
    func fetchData(from urlString: String, completion: @escaping (Result<Data, Error>) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        
        let task = session.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                guard let data = data else {
                    completion(.failure(NetworkError.noData))
                    return
                }
                
                completion(.success(data))
            }
        }
        
        task.resume()
    }
    
    // POST请求
    func postData(to urlString: String, data: Data, completion: @escaping (Result<Data, Error>) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = data
        
        let task = session.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                guard let data = data else {
                    completion(.failure(NetworkError.noData))
                    return
                }
                
                completion(.success(data))
            }
        }
        
        task.resume()
    }
    
    // 带认证的请求
    func authenticatedRequest(urlString: String, token: String, completion: @escaping (Result<Data, Error>) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let task = session.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                if let httpResponse = response as? HTTPURLResponse {
                    if httpResponse.statusCode == 401 {
                        completion(.failure(NetworkError.unauthorized))
                        return
                    }
                }
                
                guard let data = data else {
                    completion(.failure(NetworkError.noData))
                    return
                }
                
                completion(.success(data))
            }
        }
        
        task.resume()
    }
    
    // 上传文件
    func uploadFile(to urlString: String, fileURL: URL, completion: @escaping (Result<Data, Error>) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let task = session.uploadTask(with: request, fromFile: fileURL) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                guard let data = data else {
                    completion(.failure(NetworkError.noData))
                    return
                }
                
                completion(.success(data))
            }
        }
        
        task.resume()
    }
    
    // 下载文件
    func downloadFile(from urlString: String, completion: @escaping (Result<URL, Error>) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        
        let task = session.downloadTask(with: url) { localURL, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                guard let localURL = localURL else {
                    completion(.failure(NetworkError.noData))
                    return
                }
                
                completion(.success(localURL))
            }
        }
        
        task.resume()
    }
}

// 网络错误类型
enum NetworkError: Error, LocalizedError {
    case invalidURL
    case noData
    case unauthorized
    case serverError(Int)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .noData:
            return "No data received"
        case .unauthorized:
            return "Unauthorized access"
        case .serverError(let code):
            return "Server error with code: \(code)"
        }
    }
}
```

#### 4.2 使用示例
```swift
class NetworkExampleViewController: UIViewController {
    
    private let networkManager = NetworkManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        demonstrateNetworking()
    }
    
    private func demonstrateNetworking() {
        // GET请求示例
        networkManager.fetchData(from: "https://api.example.com/users") { result in
            switch result {
            case .success(let data):
                print("Received data: \(data.count) bytes")
                // 解析JSON数据
                if let json = try? JSONSerialization.jsonObject(with: data) {
                    print("JSON: \(json)")
                }
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
            }
        }
        
        // POST请求示例
        let postData = ["name": "John", "email": "john@example.com"]
        if let jsonData = try? JSONSerialization.data(withJSONObject: postData) {
            networkManager.postData(to: "https://api.example.com/users", data: jsonData) { result in
                switch result {
                case .success(let data):
                    print("POST successful: \(data.count) bytes")
                case .failure(let error):
                    print("POST error: \(error.localizedDescription)")
                }
            }
        }
        
        // 带认证的请求
        networkManager.authenticatedRequest(urlString: "https://api.example.com/profile", token: "your-token") { result in
            switch result {
            case .success(let data):
                print("Authenticated request successful")
            case .failure(let error):
                print("Authenticated request failed: \(error.localizedDescription)")
            }
        }
    }
}
```

## 总结

iOS系统框架提供了丰富的功能：
1. **Foundation框架**：基础数据类型和工具类
2. **UIKit框架**：用户界面组件和交互
3. **Core Data框架**：数据持久化和对象图管理
4. **网络框架**：HTTP请求和文件传输

掌握这些框架的使用方法对于iOS开发至关重要，建议在实际项目中多加练习和应用。
