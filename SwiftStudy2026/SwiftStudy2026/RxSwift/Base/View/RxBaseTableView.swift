//
//  RxBaseTableView.swift
//  SwiftStudy2026
//
//  Created by 宋永建 on 2026/1/16.
//

import UIKit

class RxBaseTableView: UIView {

    @IBOutlet weak var tableview: UITableView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupTableView()
    }
    
    private func setupTableView() {
        // 注册 cell
        tableview.register(MusicCell.self, forCellReuseIdentifier: MusicCell.identifier)
    }
}
