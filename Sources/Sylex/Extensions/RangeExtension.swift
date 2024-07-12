//
//  RangeExtension.swift
//  
//
//  Created by Pierre TACCHI on 18/10/2019.
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
    
    @inlinable mutating func shift(by amount: Bound.Stride) {
        self = self.shifted(by: amount)
    }
    
    @inlinable func shifted(by amount: Bound.Stride) -> Range<Bound> {
        let lower = self.lowerBound.advanced(by: amount)
        let upper = self.upperBound.advanced(by: amount)
        
        return .init(uncheckedBounds: (lower, upper))
    }
    
    /// Returns a sequence from the lower bound value to, but not including, the upper bound value of the receiver, stepping by the specified amount.
    @inlinable func stride(by amount: Bound.Stride) -> StrideTo<Bound> {
        Swift.stride(from: lowerBound, to: upperBound, by: amount)
    }
}

public extension ClosedRange where Bound: Strideable {
    @inlinable init(startIndex: Bound, count: Bound.Stride) {
        let endIndex = startIndex.advanced(by: count - 1)
        self = .init(uncheckedBounds: (startIndex, endIndex))
    }
    
    @inlinable init(endIndex: Bound, count: Bound.Stride) {
        let startIndex = endIndex.advanced(by: -(count - 1))
        self = .init(uncheckedBounds: (startIndex, endIndex))
    }
    
    @inlinable mutating func shift(by amount: Bound.Stride) {
        self = self.shifted(by: amount)
    }
    
    @inlinable func shifted(by amount: Bound.Stride) -> ClosedRange<Bound> {
        let lower = self.lowerBound.advanced(by: amount)
        let upper = self.upperBound.advanced(by: amount)
        
        return .init(uncheckedBounds: (lower, upper))
    }
    
    /// Returns a sequence from the lower bound value toward, and possibly including, the upper bound value of the receiver, stepping by the specified amount.
    @inlinable func stride(by amount: Bound.Stride) -> StrideThrough<Bound> {
        Swift.stride(from: lowerBound, through: upperBound, by: amount)
    }
}
