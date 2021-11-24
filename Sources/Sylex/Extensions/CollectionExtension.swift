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
        sum() * Element(1 / count)
    }
}

public extension Collection {
    @inlinable func firstIndex<T: Equatable>(where key: KeyPath<Element, T>, equalTo value: T) -> Index? {
        firstIndex { $0[keyPath: key] == value }
    }
    
    @inlinable func firstIndex<T: Equatable>(where key: KeyPath<Element, T>, notEqualTo value: T) -> Index? {
        firstIndex { $0[keyPath: key] != value }
    }
    
    @inlinable func filterIndex<T: Comparable>(where key: KeyPath<Element, T>, lessThan value: T) -> Index? {
        firstIndex { $0[keyPath: key] < value }
    }
    
    @inlinable func filterIndex<T: Comparable>(where key: KeyPath<Element, T>, greaterThan value: T) -> Index? {
        firstIndex { $0[keyPath: key] > value }
    }
    
    @inlinable func filterIndex<T: Comparable>(where key: KeyPath<Element, T>, lessThanOrEqualTo value: T) -> Index? {
        firstIndex { $0[keyPath: key] <= value }
    }
    
    @inlinable func filterIndex<T: Comparable>(where key: KeyPath<Element, T>, greaterThanOrEqualTo value: T) -> Index? {
        firstIndex { $0[keyPath: key] >= value }
    }
}
