//
//  CollectionExtension.swift
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

extension Collection where Element: BinaryInteger {
    /// Calculates the average (mean) of the elements in the collection.
    ///
    /// This method computes the arithmetic mean of all elements in the collection.
    /// It first calculates the sum of all elements, then divides by the count of elements.
    ///
    /// - Returns: The average of all elements as a `Double`.
    ///
    /// - Note: This method assumes that the collection has a `sum()` method that returns
    ///   a value that can be converted to `Double`, and a `count` property that returns
    ///   the number of elements in the collection.
    ///
    /// - Important: If the collection is empty, this method will return `NaN` (Not a Number)
    ///   due to division by zero.
    ///
    /// - Complexity: O(n), where n is the number of elements in the collection.
    ///
    /// - Example:
    ///   ```swift
    ///   let numbers = [1, 2, 3, 4, 5]
    ///   let average = numbers.avg()
    ///   print(average) // Prints: 3.0
    ///   ```
    ///
    /// - SeeAlso: `sum()`, `count`
    @inlinable public func avg() -> Double {
        Double(sum()) / Double(count)
    }
}

extension Collection where Element: BinaryFloatingPoint {
    /// Calculates the average (mean) of the elements in the collection.
    ///
    /// This method computes the arithmetic mean of all elements in the collection.
    /// It first calculates the sum of all elements, then divides by the count of elements.
    ///
    /// - Returns: The average of all elements as a value of type `Element`.
    ///
    /// - Note: This method assumes that the collection has a `sum()` method that returns
    ///   a value of type `Element`, and a `count` property that returns the number of
    ///   elements in the collection as an integer type.
    ///
    /// - Important: The behavior of this method depends on the `Element` type:
    ///   - For floating-point types, if the collection is empty, this method will likely return `NaN` (Not a Number).
    ///   - For integer types, if the collection is empty or if the sum is less than the count, it will return `0`.
    ///   - For other types, the behavior with empty collections or when sum is less than count may vary.
    ///
    /// - Complexity: O(n), where n is the number of elements in the collection.
    ///
    /// - Example:
    ///   ```swift
    ///   let numbers = [1, 2, 3, 4, 5]
    ///   let average = numbers.avg()
    ///   print(average) // Prints: 3
    ///
    ///   let doubles = [1.5, 2.5, 3.5]
    ///   let doubleAverage = doubles.avg()
    ///   print(doubleAverage) // Prints: 2.5
    ///   ```
    ///
    /// - SeeAlso: `sum()`, `count`
    @inlinable public func avg() -> Element {
        sum() * 1 / Element(count)
    }
}
