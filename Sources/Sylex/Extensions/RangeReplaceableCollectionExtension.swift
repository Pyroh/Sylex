//
//  File.swift
//  
//
//  Created by Pierre Tacchi on 15/06/21.
//

import Foundation

import ZeroableProtocol

public extension RangeReplaceableCollection where Element: Zeroable {
    @inlinable init(count: Int) { self.init(repeating: .zero, count: count) }
}
