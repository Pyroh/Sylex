//
//  SequenceExtension.swift
//  Sylex
//

import Foundation

public extension Sequence {
    
    func filter<T: Equatable>(on key: KeyPath<Element, T>, equalTo value: T) -> [Element] {
        filter { $0[keyPath: key] == value }
    }
    
    func filter<T: Comparable>(on key: KeyPath<Element, T>, lessThan value: T) -> [Element] {
        filter { $0[keyPath: key] < value }
    }
    
    func filter<T: Comparable>(on key: KeyPath<Element, T>, greaterThan value: T) -> [Element] {
        filter { $0[keyPath: key] > value }
    }
    
    func filter<T: Comparable>(on key: KeyPath<Element, T>, lessThanOrEqualTo value: T) -> [Element] {
        filter { $0[keyPath: key] <= value }
    }
    
    func filter<T: Comparable>(on key: KeyPath<Element, T>, greaterThanOrEqualTo value: T) -> [Element] {
        filter { $0[keyPath: key] >= value }
    }
}

public extension Sequence where Element: Equatable {
    
    func filter(equalTo value: Element) -> [Element] {
        filter { $0 == value }
    }
}
   
public extension Sequence where Element: Comparable {
    
    func filter(lessThan value: Element) -> [Element] {
        filter { $0 < value }
    }
    
    func filter(greaterThan value: Element) -> [Element] {
        filter { $0 > value }
    }
    
    func filter(lessThanOrEqualTo value: Element) -> [Element] {
        filter { $0 <= value }
    }
    
    func filter(greaterThanOrEqualTo value: Element) -> [Element] {
        filter { $0 >= value }
    }
}
    
public extension Sequence {
    
    func filter(on key: KeyPath<Element, Bool>) -> [Element] {
        filter(on: key, equalTo: true)
    }
    
    func filter(onNot key: KeyPath<Element, Bool>) -> [Element] {
        filter(on: key, equalTo: false)
    }
    
}

public extension Sequence {
    
    func filter<S: StringProtocol>(_ key: KeyPath<Element, String>, contains substring: S, containsEmpty flag: Bool = true) -> [Element] {
        guard !(substring.isEmpty && flag) else { return .init(self) }
        return filter { $0[keyPath: key].contains(substring) }
    }
    
    func filter<S: StringProtocol>(_ key: KeyPath<Element, String>, localizedCaseInsensitiveContains substring: S, containsEmpty flag: Bool = true) -> [Element] {
        guard !(substring.isEmpty && flag) else { return .init(self) }
        return filter { $0[keyPath: key].localizedCaseInsensitiveContains(substring) }
    }
    
    func filter<S: StringProtocol>(_ key: KeyPath<Element, String>, localizedStandardContains substring: S, containsEmpty flag: Bool = true) -> [Element] {
        guard !(substring.isEmpty && flag) else { return .init(self) }
        return filter { $0[keyPath: key].localizedStandardContains(substring) }
    }
}

public extension Sequence {
    
    func first<T: Equatable>(where key: KeyPath<Element, T>, equalTo value: T) -> Element? {
        first { $0[keyPath: key] == value }
    }
    
    func first<T: Comparable>(where key: KeyPath<Element, T>, lessThan value: T) -> Element? {
        first { $0[keyPath: key] < value }
    }
    
    func first<T: Comparable>(where key: KeyPath<Element, T>, greaterThan value: T) -> Element? {
        first { $0[keyPath: key] > value }
    }
    
    func first<T: Comparable>(where key: KeyPath<Element, T>, lessThanOrEqualTo value: T) -> Element? {
        first { $0[keyPath: key] <= value }
    }
    
    func first<T: Comparable>(where key: KeyPath<Element, T>, greaterThanOrEqualTo value: T) -> Element? {
        first { $0[keyPath: key] >= value }
    }
}

public extension LazySequence {
    
    func filter<T: Equatable>(on key: KeyPath<Element, T>, equal value: T) -> LazyFilterSequence<Elements> {
        filter { $0[keyPath: key] == value }
    }
    
    func filter(on key: KeyPath<Element, Bool>) -> LazyFilterSequence<Elements> {
        filter(on: key, equal: true)
    }
    
    func filter(onNot key: KeyPath<Element, Bool>) -> LazyFilterSequence<Elements> {
        filter(on: key, equal: false)
    }
}

public extension Sequence {
    
    func sorted<T: Comparable>(by key: KeyPath<Element, T>) -> [Element] {
        sorted { (lhs, rhs) -> Bool in lhs[keyPath: key] < rhs[keyPath: key] }
    }
    
    func sorted(alphabetically key: KeyPath<Element, String>) -> [Element] {
        sorted { (lhs, rhs) -> Bool in lhs[keyPath: key].compare(rhs[keyPath: key]) == .orderedAscending }
    }
    
    func sorted(caseInsensitiveBy key: KeyPath<Element, String>) -> [Element] {
        sorted { (lhs, rhs) -> Bool in lhs[keyPath: key].caseInsensitiveCompare(rhs[keyPath: key]) == .orderedAscending }
    }
    
    func sorted(localizedBy key: KeyPath<Element, String>) -> [Element] {
        sorted { (lhs, rhs) -> Bool in lhs[keyPath: key].localizedCompare(rhs[keyPath: key]) == .orderedAscending }
    }
    
    func sorted(localizedCaseInsensitiveBy key: KeyPath<Element, String>) -> [Element] {
        sorted { (lhs, rhs) -> Bool in lhs[keyPath: key].localizedCaseInsensitiveCompare(rhs[keyPath: key]) == .orderedAscending }
    }
    
    func sorted(localizedStandardBy key: KeyPath<Element, String>) -> [Element] {
        sorted { (lhs, rhs) -> Bool in lhs[keyPath: key].localizedStandardCompare(rhs[keyPath: key]) == .orderedAscending }
    }
}
