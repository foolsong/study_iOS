//
//  RxSwiftLoginInViewController.swift
//  SwiftStudy2026
//
//  Created by 宋永建 on 2026/1/21.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

class RxSwiftLoginInViewController: BaseStudyViewController {
    
    @IBOutlet weak var phoneNumTextField: UITextField!
    
    @IBOutlet weak var codeNumTextField: UITextField!
    
    @IBOutlet weak var getCodeButton: UIButton!
    
    @IBOutlet weak var loginInButton: UIButton!
    
    lazy var viewModel: LoginViewModel = {
        let vm = LoginViewModel()
        return vm
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
    }
        
    // MARK: - UI Setup
    private func setupUI() {
        phoneNumTextField.placeholder = "请输入手机号"
        phoneNumTextField.keyboardType = .phonePad
        phoneNumTextField.clearButtonMode = .whileEditing
        
        codeNumTextField.placeholder = "请输入验证码"
        codeNumTextField.keyboardType = .numberPad
        codeNumTextField.clearButtonMode = .whileEditing
        
        getCodeButton.setTitle("获取验证码", for: .normal)
        getCodeButton.setTitle("获取验证码", for: .disabled)
        getCodeButton.setTitleColor(.white, for: .normal)
        getCodeButton.setTitleColor(.white, for: .disabled)
        getCodeButton.backgroundColor = .lightGray
        getCodeButton.isEnabled = false
        
        loginInButton.setTitle("登录", for: .normal)
        loginInButton.backgroundColor = .lightGray
        loginInButton.isEnabled = false
        
        // 添加关闭键盘的手势
        let tapGesture = UITapGestureRecognizer()
        tapGesture.rx.event
            .subscribe(onNext: { [weak self] _ in
                self?.view.endEditing(true)
            })
            .disposed(by: disposeBag)
        view.addGestureRecognizer(tapGesture)
    }
        
        // MARK: - ViewModel Binding
    private func bindViewModel() {
           // 创建 Input
           let input = LoginViewModel.Input(
               phoneNumber: phoneNumTextField.rx.text.orEmpty.asObservable(),
               verifyCode: codeNumTextField.rx.text.orEmpty.asObservable(),
               verifyCodeButtonTap: getCodeButton.rx.tap.asObservable(),
               loginButtonTap: loginInButton.rx.tap.asObservable()
           )
           
           // 获取 Output
           let output = viewModel.transform(input: input)
           
           // 绑定到 UI - 确保这些成员在 Output 中都有定义
           
           // 1. 验证码按钮是否可用 + 背景色（可用=蓝，不可用=灰）
           output.getCodeButtonEnabled
               .drive(onNext: { [weak self] enabled in
                   self?.getCodeButton.isEnabled = enabled
                   self?.getCodeButton.backgroundColor = enabled ? .systemBlue : .lightGray
               })
               .disposed(by: disposeBag)
        
           
           // 2. 验证码按钮标题（同时设置 normal/disabled，保证置灰时也显示文案）
           output.getCodeButtonTitle
               .drive(onNext: { [weak self] title in
                   self?.getCodeButton.setTitle(title, for: .normal)
                   self?.getCodeButton.setTitle(title, for: .disabled)
               })
               .disposed(by: disposeBag)
           
           // 4. 登录按钮状态
           output.isLoginEnabled
               .drive(onNext: { [weak self] isEnabled in
                   self?.updateLoginButtonState(isEnabled: isEnabled)
               })
               .disposed(by: disposeBag)
           
           // 5. 加载状态
           output.isLoading
               .drive(onNext: { [weak self] isLoading in
                   self?.handleLoadingState(isLoading)
               })
               .disposed(by: disposeBag)
           
           // 6. 登录结果
           output.loginResult
               .drive(onNext: { [weak self] result in
                   self?.handleLoginResult(result)
               })
               .disposed(by: disposeBag)
           
           // 7. 错误提示
           output.errorMessage
               .drive(onNext: { [weak self] message in
                   if let message = message {
                       self?.showErrorAlert(message: message)
                   }
               })
               .disposed(by: disposeBag)
           
           // 8. 获取验证码结果
           output.getCodeResult
               .drive(onNext: { [weak self] result in
                   self?.handleGetCodeResult(result)
               })
               .disposed(by: disposeBag)
       }
        
        // MARK: - UI 状态更新
        private func updateLoginButtonState(isEnabled: Bool) {
            loginInButton.isEnabled = isEnabled
            loginInButton.backgroundColor = isEnabled ? .systemGreen : .lightGray
            loginInButton.alpha = isEnabled ? 1.0 : 0.6
        }
        
        private func handleLoadingState(_ isLoading: Bool) {
            if isLoading {
                // 显示加载指示器
                showLoadingIndicator()
                // 禁用所有交互
                view.isUserInteractionEnabled = false
            } else {
                // 隐藏加载指示器
                hideLoadingIndicator()
                // 恢复交互
                view.isUserInteractionEnabled = true
            }
        }
        
        // MARK: - 结果处理
        private func handleLoginResult(_ result: LoginResult) {
            switch result {
            case .success(let userInfo):
                showSuccessAlert(message: "登录成功！\n欢迎回来，\(userInfo.name)")
                // 跳转到首页
                navigateToHomePage()
                
            case .failure(let error):
                let errorMessage: String
                switch error {
                case .invalidPhone:
                    errorMessage = "手机号格式错误"
                case .invalidCode:
                    errorMessage = "验证码错误"
                case .networkError:
                    errorMessage = "网络连接失败，请检查网络"
                case .serverError(let msg):
                    errorMessage = "服务器错误：\(msg)"
                }
                showErrorAlert(message: errorMessage)
            }
        }
        
        private func handleGetCodeResult(_ result: GetCodeResult) {
            switch result {
            case .success:
                showToast(message: "验证码已发送")
                
            case .failure(let error):
                let errorMessage: String
                switch error {
                case .tooFrequent:
                    errorMessage = "请求过于频繁，请稍后再试"
                case .phoneNotRegistered:
                    errorMessage = "手机号未注册"
                case .networkError:
                    errorMessage = "网络错误，请重试"
                }
                showErrorAlert(message: errorMessage)
            }
        }
        
        // MARK: - UI 辅助方法
        private func showLoadingIndicator() {
            let indicator = UIActivityIndicatorView(style: .large)
            indicator.center = view.center
            indicator.startAnimating()
            indicator.tag = 999
            view.addSubview(indicator)
        }
        
        private func hideLoadingIndicator() {
            if let indicator = view.viewWithTag(999) as? UIActivityIndicatorView {
                indicator.stopAnimating()
                indicator.removeFromSuperview()
            }
        }
        
        private func showErrorAlert(message: String) {
            let alert = UIAlertController(
                title: "提示",
                message: message,
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "确定", style: .default))
            present(alert, animated: true)
        }
        
        private func showSuccessAlert(message: String) {
            let alert = UIAlertController(
                title: "成功",
                message: message,
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "确定", style: .default))
            present(alert, animated: true)
        }
        
        private func showToast(message: String) {
            let toastLabel = UILabel()
            toastLabel.text = message
            toastLabel.textAlignment = .center
            toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.7)
            toastLabel.textColor = .white
            toastLabel.alpha = 0.0
            toastLabel.layer.cornerRadius = 10
            toastLabel.clipsToBounds = true
            
            let textSize = (message as NSString).size(withAttributes: [.font: toastLabel.font!])
            let labelWidth = min(textSize.width + 40, view.frame.width - 80)
            
            toastLabel.frame = CGRect(
                x: (view.frame.width - labelWidth) / 2,
                y: view.frame.height - 150,
                width: labelWidth,
                height: 44
            )
            
            view.addSubview(toastLabel)
            
            UIView.animate(withDuration: 0.3, animations: {
                toastLabel.alpha = 1.0
            }) { _ in
                UIView.animate(withDuration: 0.3, delay: 2.0, options: [], animations: {
                    toastLabel.alpha = 0.0
                }) { _ in
                    toastLabel.removeFromSuperview()
                }
            }
        }
        
        private func navigateToHomePage() {
            // 跳转到首页的逻辑
            print("跳转到首页")
            // 例如：
            // let homeVC = HomeViewController()
            // navigationController?.pushViewController(homeVC, animated: true)
        }

}
