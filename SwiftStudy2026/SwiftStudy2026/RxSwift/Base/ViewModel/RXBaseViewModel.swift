//
//  RXBaseViewModel.swift
//  SwiftStudy2026
//
//  Created by 宋永建 on 2026/1/16.
//

import Foundation
import RxSwift

struct RXBaseViewModel {
    let data: Observable<[Music]>
    
    init() {
        // 初始数据
        let initialData = [
            Music(name: "name1", singer: "singer1"),
            Music(name: "name2", singer: "singer2"),
            Music(name: "name3", singer: "singer3"),
            Music(name: "name4", singer: "singer4"),
            Music(name: "name5", singer: "singer5"),
            Music(name: "name6", singer: "singer6"),
            Music(name: "name7", singer: "singer7"),
        ]
        
        // 每隔2秒更新一次，更新5次
        data = Observable<Int>
            .interval(.seconds(2), scheduler: MainScheduler.instance)
            .take(5)
            .map { index in
                // 每次更新时生成新的数据（可以根据 index 变化数据）
                initialData.map { music in
                    Music(name: "\(music.name)_更新\(index + 1)", singer: "\(music.singer)_更新\(index + 1)")
                }
            }
            .startWith(initialData) // 立即发送初始数据
    }
}
