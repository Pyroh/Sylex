//
//  BinaryIntegerExtension.swift
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

import CoreGraphics

public extension BinaryInteger {
    
    /// Returns the digit at the given index. Digit of index 0 is the rightmost digit.
    /// - Parameter index: The index of the desired digit.
    /// - Parameter radix: The radix to use for the number representation.
    @inlinable func digit(at index: Int, radix: Int = 10) -> Int {
        assert(radix > 1 && radix < 21)
        return Int(self) / Int(pow(CGFloat(radix), CGFloat(index))) % Int(radix)
    }
}

/// An extension to `BinaryInteger` that provides methods for wrapping values within a range.
public extension BinaryInteger {
    /// Wraps the current value within the specified range, modifying it in place.
    ///
    /// This method adjusts the current value to fall within the given range, wrapping around
    /// if necessary.
    ///
    /// - Parameter range: The range within which to wrap the value.
    ///
    /// - Example:
    ///   ```swift
    ///   var value: Int = 15
    ///   value.wrap(in: 0..<10)
    ///   print(value) // Prints: 5
    ///   ```
    ///
    /// - SeeAlso: `wrapped(in:)`, `wrap(_:in:)`
    @inlinable mutating func wrap(in range: Range<Self>) {
        self = Sylex.wrap(self, in: range)
    }
    
    /// Returns a new value wrapped within the specified range.
    ///
    /// This method returns a new value that falls within the given range, wrapping around
    /// if necessary, without modifying the original value.
    ///
    /// - Parameter range: The range within which to wrap the value.
    /// - Returns: A new value wrapped within the specified range.
    ///
    /// - Example:
    ///   ```swift
    ///   let value: Int = 15
    ///   let wrappedValue = value.wrapped(in: 0..<10)
    ///   print(wrappedValue) // Prints: 5
    ///   ```
    ///
    /// - SeeAlso: `wrap(in:)`, `wrap(_:in:)`
    @inlinable func wrapped(in range: Range<Self>) -> Self {
        Sylex.wrap(self, in: range)
    }
}

/// Wraps a value within a specified range.
///
/// This function takes a value and a range, and returns a new value that falls within the range,
/// wrapping around if necessary.
///
/// - Parameters:
///   - value: The value to wrap.
///   - range: The range within which to wrap the value.
/// - Returns: A new value wrapped within the specified range.
///
/// - Example:
///   ```swift
///   let wrappedValue = wrap(15, in: 0..<10)
///   print(wrappedValue) // Prints: 5
///   ```
///
/// - Note: This function handles wrapping for any value, whether it's above the upper bound
///   or below the lower bound of the range. It works efficiently with large numbers and
///   does not risk overflow.
///
/// - SeeAlso: `BinaryInteger.wrap(in:)`, `BinaryInteger.wrapped(in:)`
@inlinable public func wrap<T: BinaryInteger>(_ value: T, in range: Range<T>) -> T {
    let width = range.upperBound - range.lowerBound
    guard width != 0 else { return range.lowerBound }
    
    let offset = value - range.lowerBound
    let wrappedOffset = ((offset % width) + width) % width
    return wrappedOffset + range.lowerBound
}

public extension BinaryInteger {
    @available(*, deprecated, renamed: "wrap")
    @inlinable mutating func cycle(in range: Range<Self>) {
        self = Sylex.cycle(self, in: range)
    }
    
    @available(*, deprecated, renamed: "wrapped")
    @inlinable func cycled(in range: Range<Self>) -> Self {
        Sylex.cycle(self, in: range)
    }
}

@available(*, deprecated, renamed: "wrap")
@inlinable public func cycle<T: BinaryInteger>(_ value: T, in range: Range<T>) -> T {
    let proxyValue = Double(value)
    let proxyLowerBound = Double(range.lowerBound)
    let proxyUpperBound = Double(range.upperBound)
    let proxyRange = Range(uncheckedBounds: (lower: proxyLowerBound, upper: proxyUpperBound))
    
    return T(cycle(proxyValue, in: proxyRange))
}
