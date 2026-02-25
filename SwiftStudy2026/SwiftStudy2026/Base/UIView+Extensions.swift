//
//  UIView+Extensions.swift
//  SwiftStudy2026
//
//  Created by 宋永建 on 2026/1/15.
//

import UIKit

extension UIView {
    /// 从 xib 文件加载视图实例
    /// - Parameter nibName: xib 文件名，如果为 nil 则使用类名作为 xib 文件名
    /// - Parameter bundle: Bundle，默认为 nil（使用 main bundle）
    /// - Returns: 加载的视图实例
    static func loadFromNib(nibName: String? = nil, bundle: Bundle? = nil) -> Self {
        let name = nibName ?? String(describing: Self.self)
        let bundle = bundle ?? Bundle(for: Self.self)
        let nib = UINib(nibName: name, bundle: bundle)
        return nib.instantiate(withOwner: nil, options: nil).first as! Self
    }
}
