//
//  MusicCell.swift
//  SwiftStudy2026
//
//  Created by 宋永建 on 2026/1/15.
//

import UIKit

class MusicCell: UITableViewCell {
    
    static let identifier = "musicCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
