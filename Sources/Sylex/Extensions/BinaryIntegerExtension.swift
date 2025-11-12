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

import Foundation
import CoreGraphics

public extension FixedWidthInteger {
    var data: Data { .init(self) }
}

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

/// Extension providing convenient conversion properties and rounding utilities for binary integer types.
///
/// This extension adds type conversion shortcuts and methods for rounding integers to the nearest
/// multiple of a specified value, useful for alignment operations, quantization, and working with
/// fixed intervals.
public extension BinaryInteger {
    
    // MARK: - Type Conversion Properties
    
    /// Converts the integer value to a `Double`.
    ///
    /// This property provides a convenient shorthand for converting any `BinaryInteger` type to
    /// a floating-point `Double` value.
    ///
    /// - Complexity: O(1)
    ///
    /// # Example
    /// ```swift
    /// let value: Int = 42
    /// let doubleValue = value.d // 42.0
    /// ```
    @inline(__always) var d: Double { Double(self) }
    
    /// Converts the integer value to a `UInt`.
    ///
    /// This property provides a convenient shorthand for converting any `BinaryInteger` type to
    /// an unsigned integer. Note that converting a negative value will trap.
    ///
    /// - Complexity: O(1)
    ///
    /// - Warning: Converting a negative value to `UInt` will result in a runtime error.
    ///
    /// # Example
    /// ```swift
    /// let value: Int64 = 100
    /// let unsignedValue = value.u // UInt(100)
    /// ```
    @inline(__always) var u: UInt { UInt(self) }
    
    /// Converts the integer value to an `Int`.
    ///
    /// This property provides a convenient shorthand for converting any `BinaryInteger` type to
    /// a signed integer.
    ///
    /// - Complexity: O(1)
    ///
    /// - Warning: Converting a value outside the `Int` range will trap.
    ///
    /// # Example
    /// ```swift
    /// let value: UInt8 = 50
    /// let signedValue = value.i // Int(50)
    /// ```
    @inline(__always) var i: Int { Int(self) }
    
    // MARK: - Rounding Methods
    
    /// Rounds the value to the nearest multiple of the specified value using the default rounding rule.
    ///
    /// This method modifies the integer in place, rounding it to the nearest multiple of the given
    /// value using the `.toNearestOrEven` rounding rule (banker's rounding).
    ///
    /// - Parameter value: The multiple to round to. Must be non-zero.
    ///
    /// - Complexity: O(1)
    ///
    /// - Note: Uses banker's rounding (.toNearestOrEven) by default. When equidistant from two
    ///   multiples, rounds to the even multiple.
    ///
    /// # Example
    /// ```swift
    /// var number = 23
    /// number.roundToNearest(10) // number is now 20
    ///
    /// var value = 25
    /// value.roundToNearest(10) // value is now 20 (banker's rounding)
    /// ```
    @inlinable
    mutating func roundToNearest(_ value: Self) {
        self = Self((Double(self) / Double(value)).rounded() * Double(value))
    }
    
    /// Returns the value rounded to the nearest multiple of the specified value using the default rounding rule.
    ///
    /// This method returns a new integer rounded to the nearest multiple of the given value using
    /// the `.toNearestOrEven` rounding rule (banker's rounding), without modifying the original value.
    ///
    /// - Parameter value: The multiple to round to. Must be non-zero.
    ///
    /// - Returns: A new integer rounded to the nearest multiple of `value`.
    ///
    /// - Complexity: O(1)
    ///
    /// - Note: Uses banker's rounding (.toNearestOrEven) by default. When equidistant from two
    ///   multiples, rounds to the even multiple.
    ///
    /// # Example
    /// ```swift
    /// let number = 23
    /// let rounded = number.roundedToNearest(10) // 20
    ///
    /// let value = 25
    /// let result = value.roundedToNearest(10) // 20 (banker's rounding)
    /// ```
    @inlinable
    func roundedToNearest(_ value: Self) -> Self {
        Self((Double(self) / Double(value)).rounded() * Double(value))
    }
    
    /// Rounds the value to the nearest multiple of the specified value using a custom rounding rule.
    ///
    /// This method modifies the integer in place, rounding it to the nearest multiple of the given
    /// value using the specified rounding rule.
    ///
    /// - Parameters:
    ///   - value: The multiple to round to. Must be non-zero.
    ///   - rule: The rounding rule to apply (e.g., `.up`, `.down`, `.toNearestOrAwayFromZero`).
    ///
    /// - Complexity: O(1)
    ///
    /// # Example
    /// ```swift
    /// var number = 23
    /// number.roundToNearest(10, rule: .up) // number is now 30
    ///
    /// var value = 23
    /// value.roundToNearest(10, rule: .down) // value is now 20
    /// ```
    @inlinable
    mutating func roundToNearest(_ value: Self, rule: FloatingPointRoundingRule) {
        self = Self((Double(self) / Double(value)).rounded(rule) * Double(value))
    }
    
    /// Returns the value rounded to the nearest multiple of the specified value using a custom rounding rule.
    ///
    /// This method returns a new integer rounded to the nearest multiple of the given value using
    /// the specified rounding rule, without modifying the original value.
    ///
    /// - Parameters:
    ///   - value: The multiple to round to. Must be non-zero.
    ///   - rule: The rounding rule to apply (e.g., `.up`, `.down`, `.toNearestOrAwayFromZero`).
    ///
    /// - Returns: A new integer rounded to the nearest multiple of `value` according to `rule`.
    ///
    /// - Complexity: O(1)
    ///
    /// # Example
    /// ```swift
    /// let number = 23
    /// let roundedUp = number.roundedToNearest(10, rule: .up) // 30
    /// let roundedDown = number.roundedToNearest(10, rule: .down) // 20
    /// let roundedAway = number.roundedToNearest(10, rule: .toNearestOrAwayFromZero) // 20
    /// ```
    @inlinable
    func roundedToNearest(_ value: Self, rule: FloatingPointRoundingRule) -> Self {
        Self((Double(self) / Double(value)).rounded(rule) * Double(value))
    }
}

/// Rounds an integer value to the nearest multiple of a specified step using the default rounding rule.
///
/// This function returns a new integer rounded to the nearest multiple of the given step
/// using the `.toNearestOrEven` rounding rule (banker's rounding). This is useful for aligning values
/// to specific boundaries, quantizing to fixed intervals, or working with memory alignment requirements.
///
/// - Parameters:
///   - value: The integer value to round.
///   - step: The multiple to round to. Must be non-zero.
///
/// - Returns: A new integer rounded to the nearest multiple of `step`.
///
/// - Complexity: O(1)
///
/// - Note: Uses banker's rounding (.toNearestOrEven) by default. When equidistant from two
///   multiples, rounds to the even multiple.
///
/// # Example
/// ```swift
/// let rounded = round(23, toNearest: 10) // 20
/// let aligned = round(25, toNearest: 10) // 20 (banker's rounding)
/// let size = round(137, toNearest: 16) // 136 (memory alignment)
/// ```
@inlinable public func round<T: BinaryInteger>(_ value: T, toNearest step: T) -> T {
    T((Double(value) / Double(step)).rounded() * Double(step))
}

/// Rounds an integer value to the nearest multiple of a specified step using a custom rounding rule.
///
/// This function returns a new integer rounded to the nearest multiple of the given step
/// using the specified rounding rule. This provides fine-grained control over rounding behavior for
/// alignment operations, quantization, or boundary calculations.
///
/// - Parameters:
///   - value: The integer value to round.
///   - step: The multiple to round to. Must be non-zero.
///   - rule: The rounding rule to apply. Common rules include:
///     - `.up`: Round toward positive infinity (round up)
///     - `.down`: Round toward negative infinity (round down)
///     - `.toNearestOrAwayFromZero`: Round to nearest, ties away from zero
///     - `.toNearestOrEven`: Round to nearest, ties to even (default)
///     - `.towardZero`: Round toward zero (truncate)
///     - `.awayFromZero`: Round away from zero
///
/// - Returns: A new integer rounded to the nearest multiple of `step` according to `rule`.
///
/// - Complexity: O(1)
///
/// # Example
/// ```swift
/// let roundedUp = round(23, toNearest: 10, rule: .up) // 30
/// let roundedDown = round(23, toNearest: 10, rule: .down) // 20
/// let aligned = round(137, toNearest: 16, rule: .up) // 144 (memory alignment)
/// let toZero = round(-23, toNearest: 10, rule: .towardZero) // -20
/// ```
@inlinable public func round<T: BinaryInteger>(_ value: T, toNearest step: T, rule: FloatingPointRoundingRule) -> T {
    T((Double(value) / Double(step)).rounded(rule) * Double(step))
}
