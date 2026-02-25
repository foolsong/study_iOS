//
//  ViewModelType.swift
//  SwiftStudy2026
//
//  Created by 宋永建 on 2026/1/21.
//

import Foundation

protocol ViewModelType {
    associatedtype Input
    associatedtype Output
    
    func transform(input: Input) -> Output
}
