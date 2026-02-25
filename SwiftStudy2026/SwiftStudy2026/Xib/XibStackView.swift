//
//  SC2View.swift
//  RxExample-iOS
//
//  Created by 宋永建 on 2025/12/31.
//  Copyright © 2025 Krunoslav Zaher. All rights reserved.
//

import UIKit

class XibStackView: UIView {
    
    @IBOutlet weak var view1: UIView!
    @IBOutlet weak var view2: UIView!
    
    @IBOutlet weak var view3: UIView!
    
    @IBOutlet weak var view4: UIView!
    
    @IBOutlet weak var sview1: UIView!
    
    @IBOutlet weak var sview2: UIView!
    
    private var timer: Timer?
    
    /// 启动定时器，每2秒生成随机数并控制视图的显示/隐藏
    func startTimer() {
        // 如果定时器已存在，先停止
        stopTimer()
        
        // 创建定时器，每2秒执行一次
        timer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { [weak self] _ in
            self?.updateViewsVisibility()
        }
    }
    
    /// 停止定时器
    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    /// 更新视图的显示/隐藏状态
    private func updateViewsVisibility() {
        // 为每个视图生成随机数并控制显示/隐藏
        updateViewVisibility(view: view1)
        updateViewVisibility(view: view2)
        updateViewVisibility(view: view3)
        updateViewVisibility(view: view4)
        updateViewVisibility(view: sview1)
        updateViewVisibility(view: sview2)
    }
    
    /// 为单个视图生成随机数并控制显示/隐藏
    private func updateViewVisibility(view: UIView?) {
        guard let view = view else { return }
        
        // 生成随机数
        let randomNumber = Int.random(in: 1...100)
        
        // 如果数字可以被2整除则隐藏，否则显示
        view.isHidden = (randomNumber % 2 == 0)
    }
    
    deinit {
        stopTimer()
    }
}
