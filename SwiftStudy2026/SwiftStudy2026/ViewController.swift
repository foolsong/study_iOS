
//
//  ViewController.swift
//  SwiftStudy
//
//  Created by 宋永建 on 2026/1/15.
//

import UIKit
//import RxSwift

/// 学习目录节点：既可以表示「一级目录」，也可以表示「二级目录」或最终学习页面
struct StudyItem {
    /// 标题，例如「RxSwift」「基础操作」「XIB使用」
    let title: String
    
    /// 对应要跳转的 VC 类型（如果为 nil，表示只是一个分组目录，不直接跳转）
    let viewControllerType: UIViewController.Type?
    
    /// 子节点：
    /// - 一级目录：children 存放二级目录或最终 VC
    /// - 没有二级目录的情况：children 为空，直接通过 viewControllerType 跳转
    let children: [StudyItem]
    
    /// 方便判断是否为叶子节点（真正学习页面）
    var isLeaf: Bool { children.isEmpty && viewControllerType != nil }
}

/// 示例配置（只示例数据结构使用方式，具体 VC 类型你可以自己新建并替换）
///
/// - RxSwift
///   - 基础操作 -> RxSwiftBasicViewController
///   - 实例场景 -> RxSwiftSceneViewController
/// - XIB 使用（没有二级目录，直接进入学习 VC）
///
/// 使用方式：在 tableView 的数据源里用 `studyMenu` 来渲染；点击时根据
/// `viewControllerType` 决定是否跳转，或进入 children 作为二级列表。
let studyMenu: [StudyItem] = [
    StudyItem(
        title: "RxSwift",
        viewControllerType: nil,
        children: [
            StudyItem(
                title: "基础操作",
                viewControllerType: RxSwiftBasicViewController.self,
                children: []
            ),
            StudyItem(
                title: "实例场景",
                viewControllerType: RxSwiftSceneViewController.self,
                children: []
            )
        ]
    ),
    StudyItem(
        title: "XIB 使用",
        viewControllerType: XibStackViewViewController.self,
        children: []
    )
]


class ViewController: UIViewController {
    
    /// 开发时自动跳转的目标 VC（设置为 nil 则禁用自动跳转）
    /// 使用示例：ViewController.autoFocusVC = RxSwiftBasicViewController.self
    static var autoFocusVC: UIViewController.Type? = RxSwiftLoginInViewController.self
    
    /// 当前这一层要展示的条目（根目录就是 `studyMenu`）
    private let items: [StudyItem]
    
    /// 复用标识
    private let cellIdentifier = "StudyCell"
    
    /// 用代码创建 tableView，简单一点
    private lazy var tableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .plain)
        tv.dataSource = self
        tv.delegate = self
        tv.tableFooterView = UIView()
        return tv
    }()
    
    // MARK: - 初始化
    
    /// 根目录用这个初始化（Storyboard 默认会走 init(coder:)）
    required init?(coder: NSCoder) {
        self.items = studyMenu
        super.init(coder: coder)
    }
    
    /// 内部用于 push 二级目录
    init(title: String, items: [StudyItem]) {
        self.items = items
        super.init(nibName: nil, bundle: nil)
        self.title = title
    }
    
    // MARK: - 生命周期
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        // 自动跳转到目标页面（如果已设置）
        if let targetVCType = Self.autoFocusVC,
           let nav = navigationController,
           nav.topViewController?.isKind(of: targetVCType) != true {
            let targetVC = targetVCType.init()
            nav.pushViewController(targetVC, animated: true)
        }
    }
}

// MARK: - UITableViewDataSource

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
            ?? UITableViewCell(style: .default, reuseIdentifier: cellIdentifier)
        
        let item = items[indexPath.row]
        cell.textLabel?.text = item.title
        
        // 有子节点就显示一个 disclosure indicator
        if !item.children.isEmpty {
            cell.accessoryType = .disclosureIndicator
        } else {
            cell.accessoryType = item.viewControllerType != nil ? .disclosureIndicator : .none
        }
        
        return cell
    }
}

// MARK: - UITableViewDelegate

extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let item = items[indexPath.row]
        
        if !item.children.isEmpty {
            // 有二级目录：push 一个新的 ViewController 展示 children
            let vc = ViewController(title: item.title, items: item.children)
            navigationController?.pushViewController(vc, animated: true)
        } else if let vcType = item.viewControllerType {
            // 叶子节点：直接跳转到学习 VC
            let vc = vcType.init()
            vc.title = item.title
            navigationController?.pushViewController(vc, animated: true)
        } else {
            // 理论上不会到这里：既没有 children 又没有 VC
        }
    }
}


/**
 
 #!/bin/bash
 # fix_cocoapods_scripts.sh

 echo "修复 CocoaPods 脚本权限..."

 # 1. 修复所有脚本文件
 find Pods -name "*.sh" -o -name "*.rb" | while read script; do
     chmod +x "$script"
     # 移除隔离属性
     sudo xattr -rd com.apple.quarantine "$script" 2>/dev/null || true
 done

 # 2. 修复目标支持文件
 find "Pods/Target Support Files" -type f | while read file; do
     chmod 644 "$file"
     chown $(whoami) "$file"
 done

 # 3. 修复 resources-to-copy 文件
 find Pods -name "resources-to-copy-*.txt" -type f | while read file; do
     rm -f "$file"
 done

 # 4. 重新生成
 pod install --no-repo-update

 echo "✅ 脚本权限修复完成"
 
 */
