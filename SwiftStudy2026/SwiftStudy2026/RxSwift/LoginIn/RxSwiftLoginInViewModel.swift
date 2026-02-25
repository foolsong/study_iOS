import Foundation
import RxSwift
import RxCocoa

// MARK: - 模型定义
struct UserInfo {
    let id: String
    let name: String
    let phone: String
}

enum LoginError: Error {
    case invalidPhone
    case invalidCode
    case networkError
    case serverError(String)
}

enum GetCodeError: Error {
    case tooFrequent
    case phoneNotRegistered
    case networkError
}

enum LoginResult {
    case success(UserInfo)
    case failure(LoginError)
}

enum GetCodeResult {
    case success
    case failure(GetCodeError)
}

// MARK: - ViewModel
class LoginViewModel {
    
    // MARK: - Input
    struct Input {
        let phoneNumber: Observable<String>
        let verifyCode: Observable<String>
        let verifyCodeButtonTap: Observable<Void>
        let loginButtonTap: Observable<Void>
    }
    
    // MARK: - Output
    struct Output {
        // 手机号验证状态
        let isPhoneValid: Driver<Bool>
        
        // 验证码验证状态
        let isCodeValid: Driver<Bool>
        
        // 登录按钮状态
        let isLoginEnabled: Driver<Bool>
        
        // 获取验证码按钮状态
        let getCodeButtonEnabled: Driver<Bool>
        
        // 获取验证码按钮标题
        let getCodeButtonTitle: Driver<String>
        
        // 加载状态
        let isLoading: Driver<Bool>
        
        // 登录结果
        let loginResult: Driver<LoginResult>
        
        // 获取验证码结果
        let getCodeResult: Driver<GetCodeResult>
        
        // 错误信息
        let errorMessage: Driver<String?>
        
        // 倒计时（可选，用于调试或显示）
        let countdown: Driver<Int>
    }
    
    // MARK: - 私有属性
    private let disposeBag = DisposeBag()
    private let apiService = LoginAPIService()
    
    // MARK: - 转换方法
    func transform(input: Input) -> Output {
        
        // 1. 手机号验证
        let isPhoneValid = input.phoneNumber
            .map { phone in
                self.validatePhoneNumber(phone)
            }
            .distinctUntilChanged()
            .share(replay: 1)
        
        // 2. 验证码验证
        let isCodeValid = input.verifyCode
            .map { code in
                code.count == 6 && code.rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil
            }
            .distinctUntilChanged()
            .share(replay: 1)
        
        // 3. 倒计时逻辑
        let maxCountdown = 60
        let countdownRelay = BehaviorRelay<Int>(value: maxCountdown)
        
        // 倒计时计时器：仅在实际倒计时中递减，到 1 秒时直接重置为 maxCountdown（不经过 0）
        let timer = Observable<Int>
            .interval(.seconds(1), scheduler: MainScheduler.instance)
            .withLatestFrom(countdownRelay)
            .compactMap { countdown -> Int? in
                if countdown > 0 && countdown < maxCountdown {
                    return countdown == 1 ? maxCountdown : countdown - 1
                }
                return nil
            }
        
        // 点击获取验证码
        let getCodeTrigger = input.verifyCodeButtonTap
            .withLatestFrom(isPhoneValid)
            .filter { $0 }
            .share()
        
        // 更新倒计时：timer（59→58→…→1→60）或 点击后从 59 开始
        Observable.merge(
            timer,
            getCodeTrigger.map { _ in maxCountdown - 1 }
        )
        .bind(to: countdownRelay)
        .disposed(by: disposeBag)
        
        // 4. 获取验证码请求
        let getCodeRequest = getCodeTrigger
            .withLatestFrom(input.phoneNumber)
            .flatMapLatest { [weak self] phone -> Observable<Event<Bool>> in
                guard let self = self else { return .empty() }
                return self.apiService.sendVerifyCode(phone: phone)
                    .materialize()
            }
            .share()
        
        // 5. 获取验证码结果
        let getCodeSuccess = getCodeRequest
            .compactMap { $0.element }
            .filter { $0 }
            .map { _ in GetCodeResult.success }
        
        let getCodeFailure = getCodeRequest
            .compactMap { $0.error }
            .map { error -> GetCodeResult in
                if let apiError = error as? GetCodeError {
                    return .failure(apiError)
                }
                return .failure(.networkError)
            }
        
        let getCodeResult = Observable.merge(getCodeSuccess, getCodeFailure)
            .share(replay: 1)
        
        // 6. 登录请求
        let loginRequest = input.loginButtonTap
            .withLatestFrom(Observable.combineLatest(
                input.phoneNumber,
                input.verifyCode,
                isPhoneValid,
                isCodeValid
            ))
            .filter { _, _, phoneValid, codeValid in
                phoneValid && codeValid
            }
            .flatMapLatest { [weak self] phone, code, _, _ -> Observable<Event<UserInfo>> in
                guard let self = self else { return .empty() }
                return self.apiService.login(phone: phone, code: code)
                    .materialize()
            }
            .share()
        
        // 7. 登录结果
        let loginSuccess = loginRequest
            .compactMap { $0.element }
            .map { LoginResult.success($0) }
        
        let loginFailure = loginRequest
            .compactMap { $0.error }
            .map { error -> LoginResult in
                if let loginError = error as? LoginError {
                    return .failure(loginError)
                }
                return .failure(.networkError)
            }
        
        let loginResult = Observable.merge(loginSuccess, loginFailure)
            .share(replay: 1)
        
        // 8. 按钮状态
        let getCodeButtonEnabled = Observable.combineLatest(
            countdownRelay.asObservable(),
            isPhoneValid
        )
        .map { countdown, phoneValid in
            countdown == maxCountdown && phoneValid
        }
        .distinctUntilChanged()
        .share(replay: 1)
        
        let getCodeButtonTitle = countdownRelay.asObservable()
            .map { countdown in
                countdown == maxCountdown ? "获取验证码" : "\(countdown)s"
            }
            .distinctUntilChanged()
            .share(replay: 1)
        
        // 9. 登录按钮状态
        let isLoginEnabled = Observable.combineLatest(
            isPhoneValid,
            isCodeValid,
            countdownRelay.asObservable().map { $0 < maxCountdown }
        )
        .map { phoneValid, codeValid, hasGotCode in
            phoneValid && codeValid && hasGotCode
        }
        .distinctUntilChanged()
        .share(replay: 1)
        
        // 10. 加载状态
        let isLoading = Observable.merge(
            getCodeTrigger.map { _ in true },
            getCodeResult.map { _ in false },
            input.loginButtonTap.map { _ in true },
            loginResult.map { _ in false }
        )
        .startWith(false)
        .distinctUntilChanged()
        .share(replay: 1)
        
        // 11. 错误信息
        let errorMessage = Observable.merge(
            getCodeFailure.map { result -> String? in
                switch result {
                case .failure(let error):
                    switch error {
                    case .tooFrequent:
                        return "请求过于频繁"
                    case .phoneNotRegistered:
                        return "手机号未注册"
                    case .networkError:
                        return "网络错误"
                    }
                default:
                    return nil
                }
            },
            loginFailure.map { result -> String? in
                switch result {
                case .failure(let error):
                    switch error {
                    case .invalidPhone:
                        return "手机号格式错误"
                    case .invalidCode:
                        return "验证码错误"
                    case .networkError:
                        return "网络错误"
                    case .serverError(let msg):
                        return msg
                    }
                default:
                    return nil
                }
            }
        )
        .share(replay: 1)
        
        // 返回 Output - 确保所有成员都存在
        return Output(
            isPhoneValid: isPhoneValid.asDriver(onErrorJustReturn: false),
            isCodeValid: isCodeValid.asDriver(onErrorJustReturn: false),
            isLoginEnabled: isLoginEnabled.asDriver(onErrorJustReturn: false),
            getCodeButtonEnabled: getCodeButtonEnabled.asDriver(onErrorJustReturn: false),
            getCodeButtonTitle: getCodeButtonTitle.asDriver(onErrorJustReturn: "获取验证码"),
            isLoading: isLoading.asDriver(onErrorJustReturn: false),
            loginResult: loginResult.asDriver(onErrorJustReturn: .failure(.networkError)),
            getCodeResult: getCodeResult.asDriver(onErrorJustReturn: .failure(.networkError)),
            errorMessage: errorMessage.asDriver(onErrorJustReturn: nil),
            countdown: countdownRelay.asDriver()
        )
    }
    
    // MARK: - 验证方法
    private func validatePhoneNumber(_ phone: String) -> Bool {
        // 简单的手机号验证
        let phoneRegex = "^1[3-9]\\d{9}$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        return predicate.evaluate(with: phone)
    }
}

// MARK: - API Service
class LoginAPIService {
    
    // 模拟发送验证码
    func sendVerifyCode(phone: String) -> Observable<Bool> {
        return Observable.create { observer in
            print("API: 向手机号 \(phone) 发送验证码...")
            
            // 模拟网络延迟
            DispatchQueue.global().asyncAfter(deadline: .now() + 1.5) {
                // 模拟成功或失败
                let random = Int.random(in: 1...10)
                
                if random <= 7 {
                    // 70% 成功
                    print("API: 验证码发送成功")
                    observer.onNext(true)
                    observer.onCompleted()
                } else if random <= 9 {
                    // 20% 频繁请求
                    print("API: 请求过于频繁")
                    observer.onError(GetCodeError.tooFrequent)
                } else {
                    // 10% 手机号未注册
                    print("API: 手机号未注册")
                    observer.onError(GetCodeError.phoneNotRegistered)
                }
            }
            
            return Disposables.create()
        }
    }
    
    // 模拟登录
    func login(phone: String, code: String) -> Observable<UserInfo> {
        return Observable.create { observer in
            print("API: 尝试登录 - 手机号: \(phone), 验证码: \(code)")
            
            // 验证手机号格式
            guard phone.count == 11 && phone.hasPrefix("1") else {
                observer.onError(LoginError.invalidPhone)
                return Disposables.create()
            }
            
            // 验证码校验（模拟固定验证码 "123456"）
            guard code == "123456" else {
                observer.onError(LoginError.invalidCode)
                return Disposables.create()
            }
            
            // 模拟网络延迟
            DispatchQueue.global().asyncAfter(deadline: .now() + 2.0) {
                let random = Int.random(in: 1...10)
                
                if random <= 8 {
                    // 80% 成功
                    let userInfo = UserInfo(
                        id: "user_\(Int.random(in: 1000...9999))",
                        name: "用户\(phone.suffix(4))",
                        phone: phone
                    )
                    print("API: 登录成功 - 用户: \(userInfo.name)")
                    observer.onNext(userInfo)
                    observer.onCompleted()
                } else if random == 9 {
                    // 10% 网络错误
                    print("API: 网络错误")
                    observer.onError(LoginError.networkError)
                } else {
                    // 10% 服务器错误
                    print("API: 服务器错误")
                    observer.onError(LoginError.serverError("系统繁忙，请稍后重试"))
                }
            }
            
            return Disposables.create()
        }
    }
}
