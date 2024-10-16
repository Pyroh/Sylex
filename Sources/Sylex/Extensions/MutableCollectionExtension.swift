//
//  File.swift
//  
//
//  Created by Pierre Tacchi on 15/12/21.
//

import Foundation

@available(*, deprecated, message: "Use Consequences")
extension MutableCollection where Self: RandomAccessCollection {
    @inlinable mutating func sort<T: Comparable>(by key: KeyPath<Element, T>) {
        sort { (lhs, rhs) -> Bool in lhs[keyPath: key] < rhs[keyPath: key] }
    }
    
    @inlinable mutating func sort(alphabeticallyBy key: KeyPath<Element, String>) {
        sort { (lhs, rhs) -> Bool in lhs[keyPath: key].compare(rhs[keyPath: key]) == .orderedAscending }
    }
    
    @inlinable mutating func sort(caseInsensitiveBy key: KeyPath<Element, String>) {
        sort { (lhs, rhs) -> Bool in lhs[keyPath: key].caseInsensitiveCompare(rhs[keyPath: key]) == .orderedAscending }
    }
    
    @inlinable mutating func sort(localizedBy key: KeyPath<Element, String>) {
        sort { (lhs, rhs) -> Bool in lhs[keyPath: key].localizedCompare(rhs[keyPath: key]) == .orderedAscending }
    }
    
    @inlinable mutating func sort(localizedCaseInsensitiveBy key: KeyPath<Element, String>) {
        sort { (lhs, rhs) -> Bool in lhs[keyPath: key].localizedCaseInsensitiveCompare(rhs[keyPath: key]) == .orderedAscending }
    }
    
    @inlinable mutating func sort(localizedStandardBy key: KeyPath<Element, String>) {
        sort { (lhs, rhs) -> Bool in lhs[keyPath: key].localizedStandardCompare(rhs[keyPath: key]) == .orderedAscending }
    }
}
