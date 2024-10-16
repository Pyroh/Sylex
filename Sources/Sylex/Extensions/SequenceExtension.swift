//
//  SequenceExtension.swift
//  Sylex
//
//  MIT License
//
//  Copyright (c) 2024 Pierre Tacchi
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

import Foundation

extension Sequence where Element: AdditiveArithmetic {
    /// Calculates the sum of all elements in the sequence.
    ///
    /// This method computes the sum of all elements in the sequence using
    /// the addition operation defined by the `AdditiveArithmetic` protocol.
    ///
    /// - Returns: The sum of all elements in the sequence. If the sequence is empty,
    ///            returns the `.zero` value for the `Element` type.
    ///
    /// - Complexity: O(n), where n is the number of elements in the sequence.
    ///
    /// - Note: This method uses the `reduce` operation internally, which means it
    ///         iterates through the entire sequence once.
    ///
    /// - Example:
    ///   ```swift
    ///   let numbers = [1, 2, 3, 4, 5]
    ///   let total = numbers.sum()
    ///   print(total) // Prints: 15
    ///
    ///   let emptyArray: [Int] = []
    ///   print(emptyArray.sum()) // Prints: 0
    ///
    ///   let vectors = [CGVector(dx: 1, dy: 2), CGVector(dx: 3, dy: 4)]
    ///   let sumVector = vectors.sum()
    ///   print(sumVector) // Prints: CGVector(dx: 4.0, dy: 6.0)
    ///   ```
    @inlinable public func sum() -> Element {
        reduce(.zero, +)
    }
}

@available(*, deprecated)
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

@available(*, deprecated, message: "Use Consequences")
public extension Sequence {
    @inlinable func zip<Sequence2: Sequence>(_ otherSequence: Sequence2) -> Zip2Sequence<Self, Sequence2> {
        Swift.zip(self, otherSequence)
    }
    
    @inlinable func zip<Sequence2: Sequence, Sequence3: Sequence>(_ otherSequence: Sequence2, _ anotherSequence: Sequence3) -> Zip3Sequence<Self, Sequence2, Sequence3> {
        zip3(self, otherSequence, anotherSequence)
    }
    
    @inlinable func zip<Sequence2: Sequence, Sequence3: Sequence, Sequence4: Sequence>(_ otherSequence: Sequence2, _ anotherSequence: Sequence3, _ notThisSequence: Sequence4) -> Zip4Sequence<Self, Sequence2, Sequence3, Sequence4> {
        zip4(self, otherSequence, anotherSequence, notThisSequence)
    }
}

@available(*, deprecated, message: "Use Consequences")
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
    
    @inlinable func filter<T>(onNotNil key: KeyPath<Element, T?>) -> [Element] {
        filter { $0[keyPath: key] != nil }
    }
    
    @inlinable func filter<T>(onNil key: KeyPath<Element, T?>) -> [Element] {
        filter { $0[keyPath: key] == nil }
    }
}

@available(*, deprecated, message: "Use Consequences")
public extension Sequence where Element: Equatable {
    @inlinable func filter(equalTo value: Element) -> [Element] {
        filter { $0 == value }
    }
    
    @inlinable func filter(notEqualTo value: Element) -> [Element] {
        filter { $0 != value }
    }
}

@available(*, deprecated, message: "Use Consequences")
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
    
@available(*, deprecated, message: "Use Consequences")
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

@available(*, deprecated, message: "Use Consequences")
public extension Sequence {
    @inlinable func first<T: Equatable>(where key: KeyPath<Element, T>, equalTo value: T) -> Element? {
        first { $0[keyPath: key] == value }
    }
    
    @inlinable func first<T: Equatable>(where key: KeyPath<Element, T>, notEqualTo value: T) -> Element? {
        first { $0[keyPath: key] != value }
    }
    
    @inlinable func first<T: Equatable>(where key: KeyPath<Element, T?>, equalTo value: T) -> Element? {
        first { $0[keyPath: key] == value }
    }
    
    @inlinable func first<T: Equatable>(where key: KeyPath<Element, T?>, notEqualTo value: T) -> Element? {
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

@available(*, deprecated, message: "Use Consequences")
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

@available(*, deprecated, message: "Use Consequences")
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

@available(*, deprecated, message: "Use Consequences")
public extension Sequence {
    
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

@available(*, deprecated, message: "Use Consequences")
public extension Sequence {
    @inlinable func contains<T: Equatable>(where key: KeyPath<Element, T>, equalTo value: T) -> Bool {
        contains { $0[keyPath: key] == value }
    }
    
    @inlinable func contains<T: Equatable>(where key: KeyPath<Element, T>, notEqualTo value: T) -> Bool {
        contains { $0[keyPath: key] != value }
    }
    
    @inlinable func contains<T: Comparable>(on key: KeyPath<Element, T>, lessThan value: T) -> Bool {
        contains { $0[keyPath: key] < value }
    }
    
    @inlinable func contains<T: Comparable>(on key: KeyPath<Element, T>, greaterThan value: T) -> Bool {
        contains { $0[keyPath: key] > value }
    }
    
    @inlinable func contains<T: Comparable>(on key: KeyPath<Element, T>, lessThanOrEqualTo value: T) -> Bool {
        contains { $0[keyPath: key] <= value }
    }
    
    @inlinable func contains<T: Comparable>(on key: KeyPath<Element, T>, greaterThanOrEqualTo value: T) -> Bool {
        contains { $0[keyPath: key] >= value }
    }
}
