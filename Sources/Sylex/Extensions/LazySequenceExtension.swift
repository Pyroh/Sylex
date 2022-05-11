//
//  File.swift
//  
//
//  Created by Pierre Tacchi on 11/05/22.
//

import Foundation

public extension LazySequenceProtocol {
    @inlinable func filter<T: Equatable>(on key: KeyPath<Element, T>,
                                         equalTo value: T) -> LazyFilterSequence<Elements> {
        filter { $0[keyPath: key] == value }
    }
    
    @inlinable func filter<T: Equatable>(on key: KeyPath<Element, T>,
                                         notEqualTo value: T) -> LazyFilterSequence<Elements> {
        filter { $0[keyPath: key] != value }
    }
    
    @inlinable func filter<T: Comparable>(on key: KeyPath<Element, T>,
                                          lessThan value: T) -> LazyFilterSequence<Elements> {
        filter { $0[keyPath: key] < value }
    }
    
    @inlinable func filter<T: Comparable>(on key: KeyPath<Element, T>,
                                          greaterThan value: T) -> LazyFilterSequence<Elements> {
        filter { $0[keyPath: key] > value }
    }
    
    @inlinable func filter<T: Comparable>(on key: KeyPath<Element, T>,
                                          lessThanOrEqualTo value: T) -> LazyFilterSequence<Elements> {
        filter { $0[keyPath: key] <= value }
    }
    
    @inlinable func filter<T: Comparable>(on key: KeyPath<Element, T>,
                                          greaterThanOrEqualTo value: T) -> LazyFilterSequence<Elements> {
        filter { $0[keyPath: key] >= value }
    }
}

public extension LazySequenceProtocol where Element: Equatable {
    @inlinable func filter(equalTo value: Element) -> LazyFilterSequence<Elements> {
        filter { $0 == value }
    }
    
    @inlinable func filter(notEqualTo value: Element) -> LazyFilterSequence<Elements> {
        filter { $0 != value }
    }
}

public extension LazySequenceProtocol where Element: Comparable {
    
    @inlinable func filter(lessThan value: Element) -> LazyFilterSequence<Elements> {
        filter { $0 < value }
    }
    
    @inlinable func filter(greaterThan value: Element) -> LazyFilterSequence<Elements> {
        filter { $0 > value }
    }
    
    @inlinable func filter(lessThanOrEqualTo value: Element) -> LazyFilterSequence<Elements> {
        filter { $0 <= value }
    }
    
    @inlinable func filter(greaterThanOrEqualTo value: Element) -> LazyFilterSequence<Elements> {
        filter { $0 >= value }
    }
}

public extension LazySequenceProtocol {
    @inlinable func filter(on key: KeyPath<Element, Bool>) -> LazyFilterSequence<Elements> {
        filter(on: key, equalTo: true)
    }
    
    @inlinable func filter(onNot key: KeyPath<Element, Bool>) -> LazyFilterSequence<Elements> {
        filter(on: key, equalTo: false)
    }
}

public extension LazySequenceProtocol {
    
    @inlinable func filter<S: StringProtocol>(on key: KeyPath<Element, String>, contains substring: S, containsEmpty flag: Bool = true) -> [Element] {
        guard !(substring.isEmpty && flag) else { return .init(self) }
        return filter { $0[keyPath: key].contains(substring) }
    }
    
    @inlinable func filter<S: StringProtocol>(on key: KeyPath<Element, String>, localizedCaseInsensitiveContains substring: S, containsEmpty flag: Bool = true) -> [Element] {
        guard !(substring.isEmpty && flag) else { return .init(self) }
        return filter { $0[keyPath: key].localizedCaseInsensitiveContains(substring) }
    }
    
    @inlinable func filter<S: StringProtocol>(on key: KeyPath<Element, String>, localizedStandardContains substring: S, containsEmpty flag: Bool = true) -> [Element] {
        guard !(substring.isEmpty && flag) else { return .init(self) }
        return filter { $0[keyPath: key].localizedStandardContains(substring) }
    }
}

public extension LazySequenceProtocol {
    
    @inlinable func first<T: Equatable>(where key: KeyPath<Element, T>,
                                        equalTo value: T) -> Element? {
        first { $0[keyPath: key] == value }
    }
    
    @inlinable func first<T: Equatable>(where key: KeyPath<Element, T>,
                                        notEqualTo value: T) -> Element? {
        first { $0[keyPath: key] != value }
    }
    
    @inlinable func first<T: Equatable>(where key: KeyPath<Element, T?>, equalTo value: T) -> Element? {
        first { $0[keyPath: key] == value }
    }
    
    @inlinable func first<T: Equatable>(where key: KeyPath<Element, T?>, notEqualTo value: T) -> Element? {
        first { $0[keyPath: key] != value }
    }
    
    @inlinable func first<T: Comparable>(where key: KeyPath<Element, T>,
                                         lessThan value: T) -> Element? {
        first { $0[keyPath: key] < value }
    }
    
    @inlinable func first<T: Comparable>(where key: KeyPath<Element, T>,
                                         greaterThan value: T) -> Element? {
        first { $0[keyPath: key] > value }
    }
    
    @inlinable func first<T: Comparable>(where key: KeyPath<Element, T>,
                                         lessThanOrEqualTo value: T) -> Element? {
        first { $0[keyPath: key] <= value }
    }
    
    @inlinable func first<T: Comparable>(where key: KeyPath<Element, T>,
                                         greaterThanOrEqualTo value: T) -> Element? {
        first { $0[keyPath: key] >= value }
    }
}

public extension LazySequenceProtocol {
    @inlinable func first<S: StringProtocol>(where key: KeyPath<Element, String>,
                                             contains substring: S) -> Element? {
        first { $0[keyPath: key].contains(substring) }
    }
    
    @inlinable func first<S: StringProtocol>(where key: KeyPath<Element, String>,
                                             localizedCaseInsensitiveContains substring: S) -> Element? {
        first { $0[keyPath: key].localizedCaseInsensitiveContains(substring) }
    }
    
    @inlinable func first<S: StringProtocol>(where key: KeyPath<Element, String>,
                                             localizedStandardContains substring: S) -> Element? {
        first { $0[keyPath: key].localizedStandardContains(substring) }
    }
}

public extension LazySequenceProtocol {
    
    @inlinable func sorted<T: Comparable>(by key: KeyPath<Element, T>) -> [Element] {
        sorted { (lhs, rhs) -> Bool in lhs[keyPath: key] < rhs[keyPath: key] }
    }
    
    @inlinable func sorted(alphabetically key: KeyPath<Element, String>) -> [Element] {
        sorted { (lhs, rhs) -> Bool in lhs[keyPath: key].compare(rhs[keyPath: key]) == .orderedAscending }
    }
    
    @inlinable func sorted(caseInsensitiveBy key: KeyPath<Element, String>) -> [Element] {
        sorted { (lhs, rhs) -> Bool in lhs[keyPath: key].caseInsensitiveCompare(rhs[keyPath: key]) == .orderedAscending }
    }
    
    @inlinable func sorted(localizedBy key: KeyPath<Element, String>) -> [Element] {
        sorted { (lhs, rhs) -> Bool in lhs[keyPath: key].localizedCompare(rhs[keyPath: key]) == .orderedAscending }
    }
    
    @inlinable func sorted(localizedCaseInsensitiveBy key: KeyPath<Element, String>) -> [Element] {
        sorted { (lhs, rhs) -> Bool in lhs[keyPath: key].localizedCaseInsensitiveCompare(rhs[keyPath: key]) == .orderedAscending }
    }
    
    @inlinable func sorted(localizedStandardBy key: KeyPath<Element, String>) -> [Element] {
        sorted { (lhs, rhs) -> Bool in lhs[keyPath: key].localizedStandardCompare(rhs[keyPath: key]) == .orderedAscending }
    }
}

public extension LazySequenceProtocol {
    
    @inlinable func sorted<T: Comparable>(by key: KeyPath<Element, T?>) -> [Element] {
        sorted { (lhs, rhs) -> Bool in
            switch (lhs[keyPath: key], rhs[keyPath: key]) {
            case (.some, .none): return false
            case (.some(let l), .some(let r)): return l < r
            default: return true
            }
        }
    }
    
    @inlinable func sorted(alphabetically key: KeyPath<Element, String?>) -> [Element] {
        sorted { (lhs, rhs) -> Bool in
            switch (lhs[keyPath: key], rhs[keyPath: key]) {
            case (.some, .none): return false
            case (.some(let l), .some(let r)):
                return l.compare(r) == .orderedAscending
            default: return true
            }
        }
    }
    
    @inlinable func sorted(caseInsensitiveBy key: KeyPath<Element, String?>) -> [Element] {
        sorted { (lhs, rhs) -> Bool in
            switch (lhs[keyPath: key], rhs[keyPath: key]) {
            case (.some, .none): return false
            case (.some(let l), .some(let r)):
                return l.caseInsensitiveCompare(r) == .orderedAscending
            default: return true
            }
        }
    }
    
    @inlinable func sorted(localizedBy key: KeyPath<Element, String?>) -> [Element] {
        sorted { (lhs, rhs) -> Bool in
            switch (lhs[keyPath: key], rhs[keyPath: key]) {
            case (.some, .none): return false
            case (.some(let l), .some(let r)):
                return l.localizedCompare(r) == .orderedAscending
            default: return true
            }
        }
    }
    
    @inlinable func sorted(localizedCaseInsensitiveBy key: KeyPath<Element, String?>) -> [Element] {
        sorted { (lhs, rhs) -> Bool in
            switch (lhs[keyPath: key], rhs[keyPath: key]) {
            case (.some, .none): return false
            case (.some(let l), .some(let r)):
                return l.localizedCaseInsensitiveCompare(r) == .orderedAscending
            default: return true
            }
        }
    }
    
    @inlinable func sorted(localizedStandardBy key: KeyPath<Element, String?>) -> [Element] {
        sorted { (lhs, rhs) -> Bool in
            switch (lhs[keyPath: key], rhs[keyPath: key]) {
            case (.some, .none): return false
            case (.some(let l), .some(let r)):
                return l.localizedStandardCompare(r) == .orderedAscending
            default: return true
            }
        }
    }
}
