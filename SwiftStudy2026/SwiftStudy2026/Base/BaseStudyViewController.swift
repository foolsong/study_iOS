//
//  BaseStudyViewController.swift
//  rxStudy
//
//  Created by 宋永建 on 2026/1/15.
//

import UIKit
import RxSwift

/// 学习页面基类，方便添加通用设置
class BaseStudyViewController: UIViewController {
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        // TODO: 在这里添加通用设置，如导航栏样式、通用 UI 等
    }
}
