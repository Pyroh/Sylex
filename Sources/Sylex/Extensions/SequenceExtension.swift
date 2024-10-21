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
