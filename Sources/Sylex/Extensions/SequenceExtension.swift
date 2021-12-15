//
//  SequenceExtension.swift
//  Sylex
//

import Foundation

extension Sequence where Element: AdditiveArithmetic {
    
    /// Computes the sum of all elements in the Sequence.
    @inlinable public func sum() -> Element {
        reduce(.zero, +)
    }
}

public extension Sequence {
    
    /// Transforms the whole Sequence.
    @inlinable func wholeMap<Output>(_ transform: (Self) throws -> Output) rethrows -> Output {
        try transform(self)
    }
}

public extension Sequence {
    @inlinable func flattened() -> [Element] { .init(self) }
}

public extension Sequence where Element == Any {
    @inlinable func flattened() -> [Any] {
        reduce(into: []) {
            if let seq = $1 as? Self { $0.append(contentsOf: seq.flattened()) }
            else { $0.append($1) }
        }
    }
}

public extension Sequence where Element: Sequence {
    @inlinable func flattened() -> [Element.Element] {
        reduce(into: []) { $0.append(contentsOf: $1) }.flattened()
    }
}

public extension Sequence {
    @inlinable var signal: [Void] { map { _ in } }
}

public extension LazySequence {
    @inlinable var signal: LazyMapSequence<Base, Void> { map { _ in } }
}

public extension Sequence {
    @inlinable func zip<OtherSequence: Sequence>(_ otherSequence: OtherSequence) -> Zip2Sequence<Self, OtherSequence> {
        Swift.zip(self, otherSequence)
    }
    
    @inlinable func zip<OtherSequence: Sequence, AnotherSequence: Sequence>(_ otherSequence: OtherSequence, _ anotherSequence: AnotherSequence) -> Zip3Sequence<Self, OtherSequence, AnotherSequence> {
        zip3(self, otherSequence, anotherSequence)
    }
    
    @inlinable func zip<OtherSequence: Sequence, AnotherSequence: Sequence, NotThisSequence: Sequence>(_ otherSequence: OtherSequence, _ anotherSequence: AnotherSequence, _ notThisSequence: NotThisSequence) -> Zip4Sequence<Self, OtherSequence, AnotherSequence, NotThisSequence> {
        zip4(self, otherSequence, anotherSequence, notThisSequence)
    }
}

public extension Sequence {
    
    @inlinable func filter<T: Equatable>(on key: KeyPath<Element, T>, equalTo value: T) -> [Element] {
        filter { $0[keyPath: key] == value }
    }
    
    @inlinable func filter<T: Equatable>(on key: KeyPath<Element, T>, notEqualTo value: T) -> [Element] {
        filter { $0[keyPath: key] != value }
    }
    
    @inlinable func filter<T: Comparable>(on key: KeyPath<Element, T>, lessThan value: T) -> [Element] {
        filter { $0[keyPath: key] < value }
    }
    
    @inlinable func filter<T: Comparable>(on key: KeyPath<Element, T>, greaterThan value: T) -> [Element] {
        filter { $0[keyPath: key] > value }
    }
    
    @inlinable func filter<T: Comparable>(on key: KeyPath<Element, T>, lessThanOrEqualTo value: T) -> [Element] {
        filter { $0[keyPath: key] <= value }
    }
    
    @inlinable func filter<T: Comparable>(on key: KeyPath<Element, T>, greaterThanOrEqualTo value: T) -> [Element] {
        filter { $0[keyPath: key] >= value }
    }
}

public extension Sequence where Element: Equatable {

    @inlinable func filter(equalTo value: Element) -> [Element] {
        filter { $0 == value }
    }
}
   
public extension Sequence where Element: Comparable {
    
    @inlinable func filter(lessThan value: Element) -> [Element] {
        filter { $0 < value }
    }
    
    @inlinable func filter(greaterThan value: Element) -> [Element] {
        filter { $0 > value }
    }
    
    @inlinable func filter(lessThanOrEqualTo value: Element) -> [Element] {
        filter { $0 <= value }
    }
    
    @inlinable func filter(greaterThanOrEqualTo value: Element) -> [Element] {
        filter { $0 >= value }
    }
}
    
public extension Sequence {
    @inlinable func filter(on key: KeyPath<Element, Bool>) -> [Element] {
        filter(on: key, equalTo: true)
    }
    
    @inlinable func filter(onNot key: KeyPath<Element, Bool>) -> [Element] {
        filter(on: key, equalTo: false)
    }
    
}

public extension Sequence {
    @available(*, deprecated)
    @inlinable func filter<S: StringProtocol>(_ key: KeyPath<Element, String>, contains substring: S, containsEmpty flag: Bool = true) -> [Element] {
        guard !(substring.isEmpty && flag) else { return .init(self) }
        return filter { $0[keyPath: key].contains(substring) }
    }
    
    @available(*, deprecated)
    @inlinable func filter<S: StringProtocol>(_ key: KeyPath<Element, String>, localizedCaseInsensitiveContains substring: S, containsEmpty flag: Bool = true) -> [Element] {
        guard !(substring.isEmpty && flag) else { return .init(self) }
        return filter { $0[keyPath: key].localizedCaseInsensitiveContains(substring) }
    }
    
    @available(*, deprecated)
    @inlinable func filter<S: StringProtocol>(_ key: KeyPath<Element, String>, localizedStandardContains substring: S, containsEmpty flag: Bool = true) -> [Element] {
        guard !(substring.isEmpty && flag) else { return .init(self) }
        return filter { $0[keyPath: key].localizedStandardContains(substring) }
    }
    
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

public extension Sequence {
    
    @inlinable func first<T: Equatable>(where key: KeyPath<Element, T>, equalTo value: T) -> Element? {
        first { $0[keyPath: key] == value }
    }
    
    @inlinable func first<T: Equatable>(where key: KeyPath<Element, T>, notEqualTo value: T) -> Element? {
        first { $0[keyPath: key] != value }
    }
    
    @inlinable func first<T: Comparable>(where key: KeyPath<Element, T>, lessThan value: T) -> Element? {
        first { $0[keyPath: key] < value }
    }
    
    @inlinable func first<T: Comparable>(where key: KeyPath<Element, T>, greaterThan value: T) -> Element? {
        first { $0[keyPath: key] > value }
    }
    
    @inlinable func first<T: Comparable>(where key: KeyPath<Element, T>, lessThanOrEqualTo value: T) -> Element? {
        first { $0[keyPath: key] <= value }
    }
    
    @inlinable func first<T: Comparable>(where key: KeyPath<Element, T>, greaterThanOrEqualTo value: T) -> Element? {
        first { $0[keyPath: key] >= value }
    }
}

public extension Sequence {
    @inlinable func first<S: StringProtocol>(where key: KeyPath<Element, String>, contains substring: S) -> Element? {
        first { $0[keyPath: key].contains(substring) }
    }
    
    @inlinable func first<S: StringProtocol>(where key: KeyPath<Element, String>, localizedCaseInsensitiveContains substring: S) -> Element? {
        first { $0[keyPath: key].localizedCaseInsensitiveContains(substring) }
    }
    
    @inlinable func first<S: StringProtocol>(where key: KeyPath<Element, String>, localizedStandardContains substring: S) -> Element? {
        first { $0[keyPath: key].localizedStandardContains(substring) }
    }
}

public extension LazySequence {
    
    @inlinable func filter<T: Equatable>(on key: KeyPath<Element, T>, equal value: T) -> LazyFilterSequence<Elements> {
        filter { $0[keyPath: key] == value }
    }
    
    @inlinable func filter(on key: KeyPath<Element, Bool>) -> LazyFilterSequence<Elements> {
        filter(on: key, equal: true)
    }
    
    @inlinable func filter(onNot key: KeyPath<Element, Bool>) -> LazyFilterSequence<Elements> {
        filter(on: key, equal: false)
    }
}

public extension Sequence {
    
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
