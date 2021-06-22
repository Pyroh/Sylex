//
//  File.swift
//  
//
//  Created by Pierre Tacchi on 15/06/21.
//

import Foundation

public extension RangeReplaceableCollection where Element: Zeroable {
    init(count: Int) { self.init(repeating: .zero, count: count) }
}
