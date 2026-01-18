# iOS安全性与隐私面试题详解

## 1. 数据加密

### 问题：iOS中如何实现数据加密？有哪些加密方式？

**答案详解：**

#### 1.1 对称加密（AES）
```swift
import CryptoKit
import Foundation

class AESEncryption {
    private let key: SymmetricKey
    
    init(key: String) throws {
        // 从字符串生成密钥
        guard let keyData = key.data(using: .utf8) else {
            throw EncryptionError.invalidKey
        }
        
        // 使用SHA256生成固定长度的密钥
        let hash = SHA256.hash(data: keyData)
        self.key = SymmetricKey(data: hash)
    }
    
    // 加密数据
    func encrypt(_ data: Data) throws -> Data {
        do {
            let sealedBox = try AES.GCM.seal(data, using: key)
            return sealedBox.combined ?? Data()
        } catch {
            throw EncryptionError.encryptionFailed(error)
        }
    }
    
    // 解密数据
    func decrypt(_ encryptedData: Data) throws -> Data {
        do {
            let sealedBox = try AES.GCM.SealedBox(combined: encryptedData)
            return try AES.GCM.open(sealedBox, using: key)
        } catch {
            throw EncryptionError.decryptionFailed(error)
        }
    }
    
    // 加密字符串
    func encryptString(_ string: String) throws -> String {
        guard let data = string.data(using: .utf8) else {
            throw EncryptionError.invalidData
        }
        
        let encryptedData = try encrypt(data)
        return encryptedData.base64EncodedString()
    }
    
    // 解密字符串
    func decryptString(_ encryptedString: String) throws -> String {
        guard let encryptedData = Data(base64Encoded: encryptedString) else {
            throw EncryptionError.invalidData
        }
        
        let decryptedData = try decrypt(encryptedData)
        guard let string = String(data: decryptedData, encoding: .utf8) else {
            throw EncryptionError.decryptionFailed(nil)
        }
        
        return string
    }
}

// 加密错误类型
enum EncryptionError: Error, LocalizedError {
    case invalidKey
    case invalidData
    case encryptionFailed(Error?)
    case decryptionFailed(Error?)
    
    var errorDescription: String? {
        switch self {
        case .invalidKey:
            return "Invalid encryption key"
        case .invalidData:
            return "Invalid data for encryption"
        case .encryptionFailed(let error):
            return "Encryption failed: \(error?.localizedDescription ?? "Unknown error")"
        case .decryptionFailed(let error):
            return "Decryption failed: \(error?.localizedDescription ?? "Unknown error")"
        }
    }
}

// 使用示例
class EncryptionExample {
    func demonstrateEncryption() {
        do {
            let encryption = try AESEncryption(key: "MySecretKey123")
            
            // 加密字符串
            let originalText = "Hello, World!"
            let encryptedText = try encryption.encryptString(originalText)
            print("Encrypted: \(encryptedText)")
            
            // 解密字符串
            let decryptedText = try encryption.decryptString(encryptedText)
            print("Decrypted: \(decryptedText)")
            
        } catch {
            print("Encryption error: \(error.localizedDescription)")
        }
    }
}
```

#### 1.2 非对称加密（RSA）
```swift
import CryptoKit
import Foundation

class RSAEncryption {
    private let privateKey: P256.KeyAgreement.PrivateKey
    private let publicKey: P256.KeyAgreement.PublicKey
    
    init() throws {
        // 生成新的密钥对
        self.privateKey = P256.KeyAgreement.PrivateKey()
        self.publicKey = privateKey.publicKey
    }
    
    // 获取公钥数据
    func getPublicKeyData() -> Data {
        return publicKey.rawRepresentation
    }
    
    // 从数据创建公钥
    static func createPublicKey(from data: Data) throws -> P256.KeyAgreement.PublicKey {
        return try P256.KeyAgreement.PublicKey(rawRepresentation: data)
    }
    
    // 生成共享密钥
    func generateSharedSecret(with publicKey: P256.KeyAgreement.PublicKey) throws -> SharedSecret {
        return try privateKey.sharedSecretFromKeyAgreement(with: publicKey)
    }
    
    // 使用共享密钥加密
    func encryptWithSharedSecret(_ data: Data, sharedSecret: SharedSecret) throws -> Data {
        let symmetricKey = sharedSecret.hkdfDerivedSymmetricKey(
            using: SHA256.self,
            salt: "EncryptionSalt".data(using: .utf8)!,
            sharedInfo: Data(),
            outputByteCount: 32
        )
        
        let sealedBox = try AES.GCM.seal(data, using: symmetricKey)
        return sealedBox.combined ?? Data()
    }
    
    // 使用共享密钥解密
    func decryptWithSharedSecret(_ encryptedData: Data, sharedSecret: SharedSecret) throws -> Data {
        let symmetricKey = sharedSecret.hkdfDerivedSymmetricKey(
            using: SHA256.self,
            salt: "EncryptionSalt".data(using: .utf8)!,
            sharedInfo: Data(),
            outputByteCount: 32
        )
        
        let sealedBox = try AES.GCM.SealedBox(combined: encryptedData)
        return try AES.GCM.open(sealedBox, using: symmetricKey)
    }
}

// 使用示例
class RSAExample {
    func demonstrateRSA() {
        do {
            // 创建两个加密实例（模拟两个用户）
            let alice = try RSAEncryption()
            let bob = try RSAEncryption()
            
            // 交换公钥
            let alicePublicKey = alice.getPublicKeyData()
            let bobPublicKey = bob.getPublicKeyData()
            
            // 生成共享密钥
            let aliceSharedSecret = try alice.generateSharedSecret(with: bob.publicKey)
            let bobSharedSecret = try bob.generateSharedSecret(with: alice.publicKey)
            
            // 验证共享密钥相同
            assert(aliceSharedSecret == bobSharedSecret)
            
            // 加密和解密
            let message = "Secret message".data(using: .utf8)!
            let encrypted = try alice.encryptWithSharedSecret(message, sharedSecret: aliceSharedSecret)
            let decrypted = try bob.decryptWithSharedSecret(encrypted, sharedSecret: bobSharedSecret)
            
            print("Original: \(String(data: message, encoding: .utf8)!)")
            print("Decrypted: \(String(data: decrypted, encoding: .utf8)!)")
            
        } catch {
            print("RSA error: \(error.localizedDescription)")
        }
    }
}
```

#### 1.3 哈希函数
```swift
import CryptoKit
import Foundation

class HashFunctions {
    
    // MD5哈希（不推荐用于安全目的）
    static func md5(_ data: Data) -> String {
        let hash = Insecure.MD5.hash(data: data)
        return hash.map { String(format: "%02x", $0) }.joined()
    }
    
    // SHA256哈希
    static func sha256(_ data: Data) -> String {
        let hash = SHA256.hash(data: data)
        return hash.map { String(format: "%02x", $0) }.joined()
    }
    
    // SHA512哈希
    static func sha512(_ data: Data) -> String {
        let hash = SHA512.hash(data: data)
        return hash.map { String(format: "%02x", $0) }.joined()
    }
    
    // 字符串哈希
    static func hashString(_ string: String, algorithm: HashAlgorithm) -> String? {
        guard let data = string.data(using: .utf8) else { return nil }
        
        switch algorithm {
        case .md5:
            return md5(data)
        case .sha256:
            return sha256(data)
        case .sha512:
            return sha512(data)
        }
    }
    
    // 文件哈希
    static func hashFile(at url: URL, algorithm: HashAlgorithm) throws -> String {
        let data = try Data(contentsOf: url)
        
        switch algorithm {
        case .md5:
            return md5(data)
        case .sha256:
            return sha256(data)
        case .sha512:
            return sha512(data)
        }
    }
    
    // 验证哈希
    static func verifyHash(_ data: Data, expectedHash: String, algorithm: HashAlgorithm) -> Bool {
        let actualHash: String
        
        switch algorithm {
        case .md5:
            actualHash = md5(data)
        case .sha256:
            actualHash = sha256(data)
        case .sha512:
            actualHash = sha512(data)
        }
        
        return actualHash == expectedHash
    }
}

enum HashAlgorithm {
    case md5
    case sha256
    case sha512
}

// 使用示例
class HashExample {
    func demonstrateHashing() {
        let text = "Hello, World!"
        
        // 计算不同算法的哈希值
        if let md5Hash = HashFunctions.hashString(text, algorithm: .md5) {
            print("MD5: \(md5Hash)")
        }
        
        if let sha256Hash = HashFunctions.hashString(text, algorithm: .sha256) {
            print("SHA256: \(sha256Hash)")
        }
        
        if let sha512Hash = HashFunctions.hashString(text, algorithm: .sha512) {
            print("SHA512: \(sha512Hash)")
        }
    }
}
```

## 2. 网络安全

### 问题：iOS中如何确保网络安全？有哪些安全措施？

**答案详解：**

#### 2.1 证书固定（Certificate Pinning）
```swift
import Foundation
import Security

class CertificatePinning {
    
    // 存储预期的证书哈希值
    private let expectedCertificateHashes: [String] = [
        "sha256/AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=", // 示例哈希值
        "sha256/BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB="
    ]
    
    // 验证服务器证书
    func validateServerTrust(_ serverTrust: SecTrust, domain: String) -> Bool {
        // 设置验证策略
        let policies = [SecPolicyCreateSSL(true, domain as CFString)]
        SecTrustSetPolicies(serverTrust, policies as CFTypeRef)
        
        // 验证证书链
        var result: SecTrustResultType = .invalid
        let status = SecTrustEvaluate(serverTrust, &result)
        
        guard status == errSecSuccess else {
            print("Certificate evaluation failed: \(status)")
            return false
        }
        
        // 检查证书固定
        return validateCertificatePinning(serverTrust)
    }
    
    private func validateCertificatePinning(_ serverTrust: SecTrust) -> Bool {
        let certificateCount = SecTrustGetCertificateCount(serverTrust)
        
        for i in 0..<certificateCount {
            guard let certificate = SecTrustGetCertificateAtIndex(serverTrust, i) else {
                continue
            }
            
            let certificateData = SecCertificateCopyData(certificate)
            let certificateHash = sha256(data: certificateData as Data)
            
            if expectedCertificateHashes.contains(certificateHash) {
                return true
            }
        }
        
        return false
    }
    
    private func sha256(data: Data) -> String {
        let hash = SHA256.hash(data: data)
        return "sha256/" + hash.base64EncodedString()
    }
}

// 安全的URLSession配置
class SecureURLSession {
    static let shared = SecureURLSession()
    private let session: URLSession
    private let certificatePinning = CertificatePinning()
    
    private init() {
        let configuration = URLSessionConfiguration.default
        configuration.tlsMinimumSupportedProtocolVersion = .TLSv12
        configuration.tlsMaximumSupportedProtocolVersion = .TLSv13
        
        let delegate = SecureURLSessionDelegate(certificatePinning: certificatePinning)
        session = URLSession(configuration: configuration, delegate: delegate, delegateQueue: nil)
    }
    
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        return session.dataTask(with: request, completionHandler: completionHandler)
    }
}

// 安全的URLSession代理
class SecureURLSessionDelegate: NSObject, URLSessionDelegate {
    private let certificatePinning: CertificatePinning
    
    init(certificatePinning: CertificatePinning) {
        self.certificatePinning = certificatePinning
        super.init()
    }
    
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        
        guard let serverTrust = challenge.protectionSpace.serverTrust else {
            completionHandler(.cancelAuthenticationChallenge, nil)
            return
        }
        
        let domain = challenge.protectionSpace.host
        
        if certificatePinning.validateServerTrust(serverTrust, domain: domain) {
            let credential = URLCredential(trust: serverTrust)
            completionHandler(.useCredential, credential)
        } else {
            completionHandler(.cancelAuthenticationChallenge, nil)
        }
    }
}

// 使用示例
class NetworkSecurityExample {
    func makeSecureRequest() {
        let url = URL(string: "https://api.example.com/secure-data")!
        let request = URLRequest(url: url)
        
        let task = SecureURLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Network error: \(error.localizedDescription)")
                return
            }
            
            if let data = data {
                print("Received secure data: \(data.count) bytes")
            }
        }
        
        task.resume()
    }
}
```

#### 2.2 网络安全配置
```swift
import Foundation

// 网络安全配置文件
class NetworkSecurityConfig {
    
    // 配置允许的域名
    static let allowedDomains = [
        "api.example.com",
        "cdn.example.com",
        "static.example.com"
    ]
    
    // 配置允许的协议
    static let allowedProtocols = ["https"]
    
    // 配置允许的端口
    static let allowedPorts = [443, 8080]
    
    // 验证URL是否安全
    static func isSecureURL(_ url: URL) -> Bool {
        guard let host = url.host else { return false }
        guard let scheme = url.scheme else { return false }
        guard let port = url.port else { return 443 } // 默认HTTPS端口
        
        return allowedDomains.contains(host) &&
               allowedProtocols.contains(scheme) &&
               allowedPorts.contains(port)
    }
    
    // 创建安全的URLRequest
    static func createSecureRequest(from url: URL) -> URLRequest? {
        guard isSecureURL(url) else { return nil }
        
        var request = URLRequest(url: url)
        request.timeoutInterval = 30
        request.cachePolicy = .reloadIgnoringLocalCacheData
        
        // 设置安全头部
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("no-cache", forHTTPHeaderField: "Cache-Control")
        
        return request
    }
}

// 安全的网络管理器
class SecureNetworkManager {
    static let shared = SecureNetworkManager()
    private let session: URLSession
    
    private init() {
        let configuration = URLSessionConfiguration.default
        configuration.tlsMinimumSupportedProtocolVersion = .TLSv12
        configuration.tlsMaximumSupportedProtocolVersion = .TLSv13
        configuration.httpShouldSetCookies = false
        configuration.httpCookieAcceptPolicy = .never
        
        session = URLSession(configuration: configuration)
    }
    
    func makeSecureRequest(to urlString: String, completion: @escaping (Result<Data, Error>) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        
        guard let request = NetworkSecurityConfig.createSecureRequest(from: url) else {
            completion(.failure(NetworkError.insecureURL))
            return
        }
        
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
}

enum NetworkError: Error {
    case invalidURL
    case insecureURL
    case noData
}
```

## 3. 隐私保护

### 问题：iOS中如何保护用户隐私？有哪些隐私保护措施？

**答案详解：**

#### 3.1 数据脱敏
```swift
class DataAnonymization {
    
    // 邮箱脱敏
    static func anonymizeEmail(_ email: String) -> String {
        let components = email.components(separatedBy: "@")
        guard components.count == 2 else { return email }
        
        let username = components[0]
        let domain = components[1]
        
        if username.count <= 2 {
            return "***@\(domain)"
        } else {
            let firstChar = String(username.prefix(1))
            let lastChar = String(username.suffix(1))
            let maskedPart = String(repeating: "*", count: username.count - 2)
            return "\(firstChar)\(maskedPart)\(lastChar)@\(domain)"
        }
    }
    
    // 手机号脱敏
    static func anonymizePhoneNumber(_ phoneNumber: String) -> String {
        guard phoneNumber.count >= 7 else { return phoneNumber }
        
        let prefix = String(phoneNumber.prefix(3))
        let suffix = String(phoneNumber.suffix(4))
        let maskedPart = String(repeating: "*", count: phoneNumber.count - 7)
        
        return "\(prefix)\(maskedPart)\(suffix)"
    }
    
    // 身份证号脱敏
    static func anonymizeIDCard(_ idCard: String) -> String {
        guard idCard.count >= 8 else { return idCard }
        
        let prefix = String(idCard.prefix(4))
        let suffix = String(idCard.suffix(4))
        let maskedPart = String(repeating: "*", count: idCard.count - 8)
        
        return "\(prefix)\(maskedPart)\(suffix)"
    }
    
    // 姓名脱敏
    static func anonymizeName(_ name: String) -> String {
        guard name.count > 1 else { return name }
        
        let firstChar = String(name.prefix(1))
        let maskedPart = String(repeating: "*", count: name.count - 1)
        
        return "\(firstChar)\(maskedPart)"
    }
    
    // 地址脱敏
    static func anonymizeAddress(_ address: String) -> String {
        let components = address.components(separatedBy: " ")
        guard components.count > 1 else { return address }
        
        let firstComponent = components[0]
        let maskedComponents = components.dropFirst().map { component in
            String(repeating: "*", count: component.count)
        }
        
        return ([firstComponent] + maskedComponents).joined(separator: " ")
    }
}

// 使用示例
class AnonymizationExample {
    func demonstrateAnonymization() {
        let email = "john.doe@example.com"
        let phone = "13812345678"
        let idCard = "110101199001011234"
        let name = "张三"
        let address = "北京市朝阳区建国路88号"
        
        print("Original email: \(email)")
        print("Anonymized email: \(DataAnonymization.anonymizeEmail(email))")
        
        print("Original phone: \(phone)")
        print("Anonymized phone: \(DataAnonymization.anonymizePhoneNumber(phone))")
        
        print("Original ID card: \(idCard)")
        print("Anonymized ID card: \(DataAnonymization.anonymizeIDCard(idCard))")
        
        print("Original name: \(name)")
        print("Anonymized name: \(DataAnonymization.anonymizeName(name))")
        
        print("Original address: \(address)")
        print("Anonymized address: \(DataAnonymization.anonymizeAddress(address))")
    }
}
```

#### 3.2 隐私权限管理
```swift
import Foundation
import Photos
import AVFoundation
import CoreLocation
import Contacts

class PrivacyPermissionManager {
    static let shared = PrivacyPermissionManager()
    
    private init() {}
    
    // 相机权限
    func requestCameraPermission(completion: @escaping (Bool) -> Void) {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            completion(true)
        case .denied, .restricted:
            completion(false)
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                DispatchQueue.main.async {
                    completion(granted)
                }
            }
        @unknown default:
            completion(false)
        }
    }
    
    // 相册权限
    func requestPhotoLibraryPermission(completion: @escaping (Bool) -> Void) {
        switch PHPhotoLibrary.authorizationStatus() {
        case .authorized, .limited:
            completion(true)
        case .denied, .restricted:
            completion(false)
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization { status in
                DispatchQueue.main.async {
                    completion(status == .authorized || status == .limited)
                }
            }
        @unknown default:
            completion(false)
        }
    }
    
    // 位置权限
    func requestLocationPermission(completion: @escaping (Bool) -> Void) {
        let locationManager = CLLocationManager()
        
        switch locationManager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            completion(true)
        case .denied, .restricted:
            completion(false)
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            // 注意：这里需要实现CLLocationManagerDelegate来处理回调
            completion(false)
        @unknown default:
            completion(false)
        }
    }
    
    // 通讯录权限
    func requestContactsPermission(completion: @escaping (Bool) -> Void) {
        switch CNContactStore.authorizationStatus(for: .contacts) {
        case .authorized:
            completion(true)
        case .denied, .restricted:
            completion(false)
        case .notDetermined:
            CNContactStore().requestAccess(for: .contacts) { granted, error in
                DispatchQueue.main.async {
                    completion(granted)
                }
            }
        @unknown default:
            completion(false)
        }
    }
    
    // 麦克风权限
    func requestMicrophonePermission(completion: @escaping (Bool) -> Void) {
        switch AVAudioSession.sharedInstance().recordPermission {
        case .granted:
            completion(true)
        case .denied:
            completion(false)
        case .undetermined:
            AVAudioSession.sharedInstance().requestRecordPermission { granted in
                DispatchQueue.main.async {
                    completion(granted)
                }
            }
        @unknown default:
            completion(false)
        }
    }
    
    // 检查权限状态
    func checkPermissionStatus(for permission: PrivacyPermission) -> PermissionStatus {
        switch permission {
        case .camera:
            let status = AVCaptureDevice.authorizationStatus(for: .video)
            return PermissionStatus(from: status)
        case .photoLibrary:
            let status = PHPhotoLibrary.authorizationStatus()
            return PermissionStatus(from: status)
        case .location:
            let status = CLLocationManager().authorizationStatus
            return PermissionStatus(from: status)
        case .contacts:
            let status = CNContactStore.authorizationStatus(for: .contacts)
            return PermissionStatus(from: status)
        case .microphone:
            let status = AVAudioSession.sharedInstance().recordPermission
            return PermissionStatus(from: status)
        }
    }
}

enum PrivacyPermission {
    case camera
    case photoLibrary
    case location
    case contacts
    case microphone
}

enum PermissionStatus {
    case notDetermined
    case denied
    case restricted
    case authorized
    case limited
    
    init(from status: Any) {
        // 根据不同的权限类型转换状态
        if let avStatus = status as? AVAuthorizationStatus {
            switch avStatus {
            case .notDetermined: self = .notDetermined
            case .denied: self = .denied
            case .restricted: self = .restricted
            case .authorized: self = .authorized
            @unknown default: self = .notDetermined
            }
        } else if let phStatus = status as? PHAuthorizationStatus {
            switch phStatus {
            case .notDetermined: self = .notDetermined
            case .denied: self = .denied
            case .restricted: self = .restricted
            case .authorized: self = .authorized
            case .limited: self = .limited
            @unknown default: self = .notDetermined
            }
        } else if let clStatus = status as? CLAuthorizationStatus {
            switch clStatus {
            case .notDetermined: self = .notDetermined
            case .denied: self = .denied
            case .restricted: self = .restricted
            case .authorizedWhenInUse, .authorizedAlways: self = .authorized
            @unknown default: self = .notDetermined
            }
        } else if let cnStatus = status as? CNAuthorizationStatus {
            switch cnStatus {
            case .notDetermined: self = .notDetermined
            case .denied: self = .denied
            case .restricted: self = .restricted
            case .authorized: self = .authorized
            @unknown default: self = .notDetermined
            }
        } else if let avRecordStatus = status as? AVAudioSession.RecordPermission {
            switch avRecordStatus {
            case .undetermined: self = .notDetermined
            case .denied: self = .denied
            case .granted: self = .authorized
            @unknown default: self = .notDetermined
            }
        } else {
            self = .notDetermined
        }
    }
}

// 使用示例
class PrivacyExample {
    func demonstratePrivacyPermissions() {
        let permissionManager = PrivacyPermissionManager.shared
        
        // 请求相机权限
        permissionManager.requestCameraPermission { granted in
            if granted {
                print("Camera permission granted")
            } else {
                print("Camera permission denied")
            }
        }
        
        // 检查权限状态
        let cameraStatus = permissionManager.checkPermissionStatus(for: .camera)
        print("Camera permission status: \(cameraStatus)")
    }
}
```

## 4. 安全存储

### 问题：iOS中如何安全地存储敏感数据？

**答案详解：**

#### 4.1 Keychain安全存储
```swift
import Foundation
import Security

class KeychainManager {
    static let shared = KeychainManager()
    
    private init() {}
    
    // 保存数据到Keychain
    func save(_ data: Data, forKey key: String, service: String = "com.example.app") -> Bool {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: key,
            kSecValueData as String: data,
            kSecAttrAccessible as String: kSecAttrAccessibleWhenUnlockedThisDeviceOnly
        ]
        
        // 先删除已存在的数据
        SecItemDelete(query as CFDictionary)
        
        // 保存新数据
        let status = SecItemAdd(query as CFDictionary, nil)
        return status == errSecSuccess
    }
    
    // 从Keychain读取数据
    func load(forKey key: String, service: String = "com.example.app") -> Data? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: key,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        
        guard status == errSecSuccess else { return nil }
        return result as? Data
    }
    
    // 从Keychain删除数据
    func delete(forKey key: String, service: String = "com.example.app") -> Bool {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: key
        ]
        
        let status = SecItemDelete(query as CFDictionary)
        return status == errSecSuccess
    }
    
    // 保存字符串
    func saveString(_ string: String, forKey key: String, service: String = "com.example.app") -> Bool {
        guard let data = string.data(using: .utf8) else { return false }
        return save(data, forKey: key, service: service)
    }
    
    // 读取字符串
    func loadString(forKey key: String, service: String = "com.example.app") -> String? {
        guard let data = load(forKey: key, service: service) else { return nil }
        return String(data: data, encoding: .utf8)
    }
    
    // 保存字典
    func saveDictionary(_ dictionary: [String: Any], forKey key: String, service: String = "com.example.app") -> Bool {
        do {
            let data = try JSONSerialization.data(withJSONObject: dictionary)
            return save(data, forKey: key, service: service)
        } catch {
            print("Failed to serialize dictionary: \(error)")
            return false
        }
    }
    
    // 读取字典
    func loadDictionary(forKey key: String, service: String = "com.example.app") -> [String: Any]? {
        guard let data = load(forKey: key, service: service) else { return nil }
        
        do {
            return try JSONSerialization.jsonObject(with: data) as? [String: Any]
        } catch {
            print("Failed to deserialize dictionary: \(error)")
            return nil
        }
    }
}

// 使用示例
class KeychainExample {
    func demonstrateKeychain() {
        let keychain = KeychainManager.shared
        
        // 保存敏感数据
        let success = keychain.saveString("secret123", forKey: "password")
        if success {
            print("Password saved to keychain")
        }
        
        // 读取敏感数据
        if let password = keychain.loadString(forKey: "password") {
            print("Retrieved password: \(password)")
        }
        
        // 保存用户信息
        let userInfo = ["username": "john_doe", "email": "john@example.com"]
        let userInfoSaved = keychain.saveDictionary(userInfo, forKey: "userInfo")
        if userInfoSaved {
            print("User info saved to keychain")
        }
        
        // 读取用户信息
        if let retrievedUserInfo = keychain.loadDictionary(forKey: "userInfo") {
            print("Retrieved user info: \(retrievedUserInfo)")
        }
        
        // 删除数据
        let deleted = keychain.delete(forKey: "password")
        if deleted {
            print("Password deleted from keychain")
        }
    }
}
```

## 总结

iOS安全性和隐私保护的关键点：
1. **数据加密**：使用对称加密、非对称加密和哈希函数
2. **网络安全**：证书固定、TLS配置、安全请求
3. **隐私保护**：数据脱敏、权限管理、最小权限原则
4. **安全存储**：Keychain、加密存储、安全配置

掌握这些安全措施可以创建更安全、更保护用户隐私的iOS应用。
