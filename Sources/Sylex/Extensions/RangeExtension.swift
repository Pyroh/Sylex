//
//  RangeExtension.swift
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

public extension Range where Bound: Strideable {
    /// Initializes a range with a given start index and count of elements.
    ///
    /// This initializer creates a range starting from the given `startIndex` and spanning a specified number of elements, `count`.
    /// The end index is calculated by advancing the `startIndex` by `count` strides.
    ///
    /// - Parameters:
    ///   - startIndex: The starting index of the range.
    ///   - count: The number of elements in the range, represented as the stride from the `startIndex`.
    ///
    /// - Example:
    ///   ```swift
    ///   let startIndex = 0
    ///   let count = 5
    ///   let range = Range<Int>(startIndex: startIndex, count: count)
    ///   print(range) // Prints "0..<5"
    ///   ```
    ///
    /// - SeeAlso: `Range`, `advanced(by:)`
    @inlinable init(startIndex: Bound, count: Bound.Stride) {
        let endIndex = startIndex.advanced(by: count)
        self = .init(uncheckedBounds: (startIndex, endIndex))
    }
    
    /// Initializes a range with a given end index and count of elements.
    ///
    /// This initializer creates a range ending at the given `endIndex` and spanning a specified number of elements, `count`.
    /// The start index is calculated by subtracting `count` strides from the `endIndex`.
    ///
    /// - Parameters:
    ///   - endIndex: The ending index of the range.
    ///   - count: The number of elements in the range, represented as the stride from the `endIndex`.
    ///
    /// - Example:
    ///   ```swift
    ///   let endIndex = 5
    ///   let count = 5
    ///   let range = Range<Int>(endIndex: endIndex, count: count)
    ///   print(range) // Prints "0..<5"
    ///   ```
    ///
    /// - SeeAlso: `Range`, `advanced(by:)`
    @inlinable init(endIndex: Bound, count: Bound.Stride) {
        let startIndex = endIndex.advanced(by: -count)
        self = .init(uncheckedBounds: (startIndex, endIndex))
    }
    
    /// Shifts the range in place by the specified amount.
    ///
    /// This method modifies the current range by advancing both its lower and upper bounds
    /// by the given amount.
    ///
    /// - Parameter amount: The distance by which to shift the range. This can be positive
    ///   (shifting forward) or negative (shifting backward).
    ///
    /// - Note: This method assumes that advancing the bounds by the given amount will not
    ///   cause an overflow. Exercise caution when using large shift amounts.
    ///
    /// - Example:
    ///   ```swift
    ///   var range = 1..<4
    ///   range.shift(by: 2)
    ///   print(range) // Prints "3..<6"
    ///   ```
    @inlinable mutating func shift(by amount: Bound.Stride) {
        self = self.shifted(by: amount)
    }
    
    /// Returns a new range shifted by the specified amount.
    ///
    /// This method creates a new range by advancing both the lower and upper bounds
    /// of the current range by the given amount.
    ///
    /// - Parameter amount: The distance by which to shift the range. This can be positive
    ///   (shifting forward) or negative (shifting backward).
    ///
    /// - Returns: A new `Range<Bound>` that's shifted by the specified amount.
    ///
    /// - Note: This method assumes that advancing the bounds by the given amount will not
    ///   cause an overflow. Exercise caution when using large shift amounts.
    ///
    /// - Example:
    ///   ```swift
    ///   let range = 1..<4
    ///   let shiftedRange = range.shifted(by: -1)
    ///   print(shiftedRange) // Prints "0..<3"
    ///   ```
    @inlinable func shifted(by amount: Bound.Stride) -> Range<Bound> {
        let lower = self.lowerBound.advanced(by: amount)
        let upper = self.upperBound.advanced(by: amount)
        
        return .init(uncheckedBounds: (lower, upper))
    }
    
    /// Returns a sequence from the lower bound value to, but not including, the upper bound value of the receiver, stepping by the specified amount.
    ///
    /// - Parameter amount: The distance between each value in the sequence.
    ///
    /// - Returns: A `StrideTo<Bound>` sequence from the lower bound towards the upper bound, exclusive.
    ///
    /// - Note: If `amount` is positive, the sequence will progress from lower bound towards upper bound.
    ///         If negative, it will progress backwards from the lower bound.
    ///         This method naturally excludes the upper bound, as `Range` is half-open.
    ///
    /// - Example:
    ///   ```swift
    ///   let range = 1..<5
    ///   for value in range.stride(by: 2) {
    ///       print(value)
    ///   }
    ///   // Prints:
    ///   // 1
    ///   // 3
    ///   ```
    @inlinable func stride(by amount: Bound.Stride) -> StrideTo<Bound> {
        Swift.stride(from: lowerBound, to: upperBound, by: amount)
    }
}

public extension ClosedRange where Bound: Strideable {
    /// Initializes a closed range with a start index and count.
    ///
    /// - Parameters:
    ///   - startIndex: The lower bound of the range.
    ///   - count: The number of elements in the range.
    ///
    /// - Note: This initializer creates a range that includes both the start index and the element at `startIndex.advanced(by: count - 1)`.
    ///
    /// - Example:
    ///   ```swift
    ///   let range = ClosedRange(startIndex: 5, count: 3)
    ///   print(range) // Prints "5...7"
    ///   ```
    @inlinable init(startIndex: Bound, count: Bound.Stride) {
        let endIndex = startIndex.advanced(by: count - 1)
        self = .init(uncheckedBounds: (startIndex, endIndex))
    }
    
    /// Initializes a closed range with an end index and count.
    ///
    /// - Parameters:
    ///   - endIndex: The upper bound of the range.
    ///   - count: The number of elements in the range.
    ///
    /// - Note: This initializer creates a range that includes both the end index and the element at `endIndex.advanced(by: -(count - 1))`.
    ///
    /// - Example:
    ///   ```swift
    ///   let range = ClosedRange(endIndex: 7, count: 3)
    ///   print(range) // Prints "5...7"
    ///   ```
    @inlinable init(endIndex: Bound, count: Bound.Stride) {
        let startIndex = endIndex.advanced(by: -(count - 1))
        self = .init(uncheckedBounds: (startIndex, endIndex))
    }
    
    /// Shifts the range in place by the specified amount.
    ///
    /// This method modifies the current range by advancing both its lower and upper bounds by the given amount.
    ///
    /// - Parameter amount: The distance by which to shift the range. This can be positive (shifting forward) or negative (shifting backward).
    ///
    /// - Note: This method assumes that advancing the bounds by the given amount will not cause an overflow.
    ///
    /// - Example:
    ///   ```swift
    ///   var range = 1...3
    ///   range.shift(by: 2)
    ///   print(range) // Prints "3...5"
    ///   ```
    @inlinable mutating func shift(by amount: Bound.Stride) {
        self = self.shifted(by: amount)
    }
    
    /// Returns a new range shifted by the specified amount.
    ///
    /// This method creates a new range by advancing both the lower and upper bounds of the current range by the given amount.
    ///
    /// - Parameter amount: The distance by which to shift the range. This can be positive (shifting forward) or negative (shifting backward).
    ///
    /// - Returns: A new `ClosedRange<Bound>` that's shifted by the specified amount.
    ///
    /// - Note: This method assumes that advancing the bounds by the given amount will not cause an overflow.
    ///
    /// - Example:
    ///   ```swift
    ///   let range = 1...3
    ///   let shiftedRange = range.shifted(by: -1)
    ///   print(shiftedRange) // Prints "0...2"
    ///   ```
    @inlinable func shifted(by amount: Bound.Stride) -> ClosedRange<Bound> {
        let lower = self.lowerBound.advanced(by: amount)
        let upper = self.upperBound.advanced(by: amount)
        
        return .init(uncheckedBounds: (lower, upper))
    }
    
    /// Returns a sequence of values from the lower bound to the upper bound, stepping by the specified amount.
    ///
    /// - Parameter amount: The distance between each value in the sequence.
    ///
    /// - Returns: A `StrideThrough<Bound>` sequence from the lower bound to the upper bound, inclusive.
    ///
    /// - Note: If `amount` is positive, the sequence will progress from lower to upper bound. If negative, it will progress from upper to lower bound.
    ///
    /// - Example:
    ///   ```swift
    ///   let range = 1...5
    ///   for value in range.stride(by: 2) {
    ///       print(value)
    ///   }
    ///   // Prints:
    ///   // 1
    ///   // 3
    ///   // 5
    ///   ```
    @inlinable func stride(by amount: Bound.Stride) -> StrideThrough<Bound> {
        Swift.stride(from: lowerBound, through: upperBound, by: amount)
    }
}
