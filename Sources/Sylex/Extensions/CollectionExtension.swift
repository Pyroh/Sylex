//
//  File.swift
//  
//
//  Created by Pierre Tacchi on 13/04/21.
//

import Foundation

extension Collection where Element: BinaryInteger {
    @inlinable public func avg() -> Double {
        Double(sum()) / Double(count)
    }
}

extension Collection where Element: BinaryFloatingPoint {
    @inlinable public func avg() -> Element {
        sum() * 1 / Element(count)
    }
}
