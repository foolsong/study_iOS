//
//  XibStudyViewController.swift
//  rxStudy
//
//  Created by 宋永建 on 2026/1/15.
//

import UIKit
import SnapKit

/// XIB 使用学习页面
class XibStackViewViewController: BaseStudyViewController {
    
    private lazy var stackView: XibStackView = {
        return XibStackView.loadFromNib()
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    private func setupUI() {
        view.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalToSuperview().offset(20)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
}
