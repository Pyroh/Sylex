//
//  ComparableExtension.swift
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

public extension Comparable {
    /// Returns a value clamped to the given closed range.
    ///
    /// This method constrains the value within the specified range. If the value is less than the lower bound,
    /// it returns the lower bound. If the value is greater than the upper bound, it returns the upper bound.
    /// Otherwise, it returns the value itself.
    ///
    /// - Parameter range: The closed range to clamp the value within.
    /// - Returns: The value clamped to the given range.
    ///
    /// - Example:
    ///   ```swift
    ///   let value = 10
    ///   let clampedValue = value.clamped(to: 0...5)
    ///   print(clampedValue) // Prints: 5
    ///
    ///   let temp = 72.0
    ///   let celsiusTemp = temp.clamped(to: -273.15...100.0)
    ///   print(celsiusTemp) // Prints: 72.0
    ///   ```
    ///
    /// - Note: This method works with any type that conforms to `Comparable`, including numeric types,
    ///   strings, and custom types that implement the `Comparable` protocol.
    ///
    /// - SeeAlso: `clamp(to:)`
    @inlinable func clamped(to range: ClosedRange<Self>) -> Self {
        Sylex.clamp(self, range.lowerBound, range.upperBound)
    }
    
    /// Clamps the value to the given closed range in place.
    ///
    /// This method constrains the value within the specified range. If the value is less than the lower bound,
    /// it sets the value to the lower bound. If the value is greater than the upper bound, it sets the value
    /// to the upper bound. Otherwise, the value remains unchanged.
    ///
    /// - Parameter range: The closed range to clamp the value within.
    ///
    /// - Example:
    ///   ```swift
    ///   var value = 10
    ///   value.clamp(to: 0...5)
    ///   print(value) // Prints: 5
    ///
    ///   var temp = 72.0
    ///   temp.clamp(to: -273.15...100.0)
    ///   print(temp) // Prints: 72.0
    ///   ```
    ///
    /// - Note: This method works with any type that conforms to `Comparable`, including numeric types,
    ///   strings, and custom types that implement the `Comparable` protocol.
    ///
    /// - SeeAlso: `clamped(to:)`
    @inlinable mutating func clamp(to range: ClosedRange<Self>) {
        self = self.clamped(to: range)
    }
}
