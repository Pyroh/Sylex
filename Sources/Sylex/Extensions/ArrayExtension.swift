//
//  ArrayExtension.swift
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

@available(*, deprecated, message: "Use Swift Collection")
public extension Array where Element: Equatable {
    /// Produces a copy of `self` where all duplicates have been removed.
    ///
    /// - Returns: A copy of `self` where all items are garanteed unique.
    @inlinable func removingDuplicates() -> Array {
        return self.reduce(into: []) { result, element in
            if !result.contains(element) {
                result.append(element)
            }
        }
    }
    
    /// Removes all the duplicates from `self`.
    @inlinable mutating func removeDuplicates() {
        self = self.removingDuplicates()
    }
}

@available(*, deprecated, message: "Use Swift Collection")
public extension Array where Element: Hashable {
    /// An instance of `Set<Element>` from `self`.
    @inlinable var set: Set<Element> {
        return Set(self)
    }
    
    /// Produces a copy of `self` where all duplicates have been removed.
    ///
    /// - Returns: A copy of `self` where all items are garanteed unique.
    @inlinable func removingDuplicates() -> [Element] {
        return self.set.array
    }
    
    /// Removes all the duplicates from `self`.
    @inlinable mutating func removeDuplicates() {
        self = self.removingDuplicates()
    }
}

@available(*, deprecated, message: "Use Consequences")
public extension Array {
    static func +(lhs: Self, rhs: Self.Element) -> Self {
        withMutable(lhs) { $0.append(rhs) }
    }
    
    static func +<S>(lhs: Self, rhs: S) -> Self where S: Sequence, S.Element == Element {
        withMutable(lhs) { $0.append(contentsOf: rhs) }
    }
    
    static func +=(lhs: inout Self, rhs: Self.Element) {
        lhs.append(rhs)
    }
    
    static func +<S>(lhs: inout Self, rhs: S) where S: Sequence, S.Element == Element {
        lhs.append(contentsOf: rhs)
    }
}
