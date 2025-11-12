//
//  BinaryFloatingPointExtension.swift
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
import SmoothOperators

public extension BinaryFloatingPoint {
    /// Rounds the floating-point value to the specified number of decimal digits.
    ///
    /// This method rounds the number to the given number of decimal places, returning a new value
    /// without modifying the original.
    ///
    /// - Parameter digits: The number of decimal digits to round to. Must be non-negative.
    /// - Returns: A new instance of `Self` rounded to the specified number of decimal digits.
    ///
    /// - Note: This method uses banker's rounding (round to nearest, ties to even) for the rounding operation.
    ///
    /// - Precondition: `digits` must be greater than or equal to 0.
    ///
    /// - Complexity: O(1)
    ///
    /// - Example:
    ///   ```swift
    ///   let pi = 3.14159
    ///   let rounded = pi.rounded(digits: 2)
    ///   print(rounded) // Prints: 3.14
    ///   ```
    ///
    /// - SeeAlso: `round(digits:)`
    @inlinable func rounded(digits: Int) -> Self {
        guard digits >= 0 else {
            fatalError("Floating point numbers can't be rounded to a negative number of digits.")
        }
        let f: Self = 10 ** digits
        return (self * f).rounded() / f
    }
    
    /// Rounds the floating-point value to the specified number of decimal digits in place.
    ///
    /// This method rounds the number to the given number of decimal places, modifying the original value.
    ///
    /// - Parameter digits: The number of decimal digits to round to. Must be non-negative.
    ///
    /// - Note: This method uses banker's rounding (round to nearest, ties to even) for the rounding operation.
    ///
    /// - Precondition: `digits` must be greater than or equal to 0.
    ///
    /// - Complexity: O(1)
    ///
    /// - Example:
    ///   ```swift
    ///   var pi = 3.14159
    ///   pi.round(digits: 2)
    ///   print(pi) // Prints: 3.14
    ///   ```
    ///
    /// - SeeAlso: `rounded(digits:)`
    @inlinable mutating func round(digits: Int) {
        self = rounded(digits: digits)
    }
}

public extension BinaryFloatingPoint {
    /// Returns an approximated version of the floating-point value.
    ///
    /// This property rounds the number to six decimal places, returning a new value
    /// without modifying the original.
    ///
    /// - Returns: A new instance of `Self` approximated to six decimal places.
    ///
    /// - Complexity: O(1)
    ///
    /// - Example:
    ///   ```swift
    ///   let pi = 3.14159265359
    ///   let approximated = pi.approximated
    ///   print(approximated) // Prints: 3.141593
    ///   ```
    ///
    /// - SeeAlso: `approximate()`
    @inlinable var approximated: Self { (self * 1_000_000).rounded() / 1_000_000 }
    
    /// Approximates the floating-point value in place.
    ///
    /// This method rounds the number to six decimal places, modifying the original value.
    ///
    /// - Complexity: O(1)
    ///
    /// - Example:
    ///   ```swift
    ///   var pi = 3.14159265359
    ///   pi.approximate()
    ///   print(pi) // Prints: 3.141593
    ///   ```
    ///
    /// - SeeAlso: `approximated`
    @inlinable mutating func approximate() { self = approximated }
}

public extension Double {
    /// The golden ratio (phi) as a `Double`.
    ///
    /// This is a high-precision representation of phi (φ), also known as the golden ratio.
    /// The value is approximately equal to (1 + √5) / 2, or about 1.61803398874989.
    ///
    /// - Note: This uses a bit pattern for high-precision representation.
    ///
    /// - Example:
    ///   ```swift
    ///   let goldenRatio = Double.phi
    ///   print(goldenRatio) // Prints: 1.618033988749895
    ///   ```
    @inlinable static var phi: Double { .init(bitPattern: 4609965796441453736) }
}

public extension Float {
    /// The golden ratio (phi) as a `Float`.
    ///
    /// This is a single-precision representation of phi (φ), also known as the golden ratio.
    /// The value is approximately equal to (1 + √5) / 2, or about 1.61803398874989.
    ///
    /// - Note: This uses a bit pattern for precision representation.
    ///
    /// - Example:
    ///   ```swift
    ///   let goldenRatio = Float.phi
    ///   print(goldenRatio) // Prints: 1.6180339
    ///   ```
    @inlinable static var phi: Float { .init(bitPattern: 1070537661) }
}

public extension CGFloat {
    /// The golden ratio (phi) as a `CGFloat`.
    ///
    /// This is a platform-appropriate precision representation of phi (φ), also known as the golden ratio.
    /// The value is approximately equal to (1 + √5) / 2, or about 1.61803398874989.
    ///
    /// - Note: This uses the native type's phi value for representation.
    ///
    /// - Example:
    ///   ```swift
    ///   let goldenRatio = CGFloat.phi
    ///   print(goldenRatio) // Prints a platform-appropriate precision of phi
    ///   ```
    @inlinable static var phi: CGFloat { .init(NativeType.phi) }
}

/// An extension to `BinaryFloatingPoint` that provides methods for wrapping values within a range.
public extension BinaryFloatingPoint {
    /// Wraps the current value within the specified range, modifying it in place.
    ///
    /// This method adjusts the current value to fall within the given range, wrapping around
    /// if necessary.
    ///
    /// - Parameter range: The range within which to wrap the value.
    ///
    /// - Example:
    ///   ```swift
    ///   var value: Double = 3.5
    ///   value.wrap(in: 0.0..<1.0)
    ///   print(value) // Prints: 0.5
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
    ///   let value: Double = 3.5
    ///   let wrappedValue = value.wrapped(in: 0.0..<1.0)
    ///   print(wrappedValue) // Prints: 0.5
    ///   ```
    ///
    /// - SeeAlso: `wrap(in:)`, `wrap(_:in:)`
    @inlinable func wrapped(in range: Range<Self>) -> Self {
        Sylex.wrap(self, in: range)
    }
}

/// Extension providing convenient conversion properties and rounding utilities for binary floating-point types.
///
/// This extension adds type conversion shortcuts and methods for rounding floating-point values to the
/// nearest multiple of a specified value, useful for quantization, grid alignment, and working with
/// fixed intervals or precision requirements.
public extension BinaryFloatingPoint {
    
    // MARK: - Type Conversion Properties
    
    /// Converts the floating-point value to a `Double`.
    ///
    /// This property provides a convenient shorthand for converting any `BinaryFloatingPoint` type to
    /// a `Double` value, preserving precision where possible.
    ///
    /// - Complexity: O(1)
    ///
    /// # Example
    /// ```swift
    /// let value: Float = 3.14
    /// let doubleValue = value.d // 3.14 (as Double)
    /// ```
    @inline(__always) var d: Double { Double(self) }
    
    /// Converts the floating-point value to a `UInt`.
    ///
    /// This property provides a convenient shorthand for converting any `BinaryFloatingPoint` type to
    /// an unsigned integer, truncating any fractional part.
    ///
    /// - Complexity: O(1)
    ///
    /// - Warning: Converting a negative value to `UInt` will result in a runtime error. Values outside
    ///   the `UInt` range will also trap.
    ///
    /// - Note: The fractional part is truncated, not rounded.
    ///
    /// # Example
    /// ```swift
    /// let value: Double = 42.7
    /// let unsignedValue = value.u // UInt(42)
    /// ```
    @inline(__always) var u: UInt { UInt(self) }
    
    /// Converts the floating-point value to an `Int`.
    ///
    /// This property provides a convenient shorthand for converting any `BinaryFloatingPoint` type to
    /// a signed integer, truncating any fractional part.
    ///
    /// - Complexity: O(1)
    ///
    /// - Warning: Values outside the `Int` range will trap.
    ///
    /// - Note: The fractional part is truncated, not rounded.
    ///
    /// # Example
    /// ```swift
    /// let value: Float = -17.8
    /// let signedValue = value.i // Int(-17)
    /// ```
    @inline(__always) var i: Int { Int(self) }
    
    // MARK: - Rounding Methods
    
    /// Rounds the value to the nearest multiple of the specified value using the default rounding rule.
    ///
    /// This method modifies the floating-point value in place, rounding it to the nearest multiple of
    /// the given value using the `.toNearestOrEven` rounding rule (banker's rounding).
    ///
    /// - Parameter value: The multiple to round to. Must be non-zero and finite.
    ///
    /// - Complexity: O(1)
    ///
    /// - Note: Uses banker's rounding (.toNearestOrEven) by default. When equidistant from two
    ///   multiples, rounds to the even multiple.
    ///
    /// # Example
    /// ```swift
    /// var number = 23.7
    /// number.roundToNearest(5.0) // number is now 25.0
    ///
    /// var value = 2.5
    /// value.roundToNearest(1.0) // value is now 2.0 (banker's rounding)
    /// ```
    @inlinable
    mutating func roundToNearest(_ value: Self) {
        self = Self((Double(self) / Double(value)).rounded() * Double(value))
    }
    
    /// Returns the value rounded to the nearest multiple of the specified value using the default rounding rule.
    ///
    /// This method returns a new floating-point value rounded to the nearest multiple of the given value
    /// using the `.toNearestOrEven` rounding rule (banker's rounding), without modifying the original value.
    ///
    /// - Parameter value: The multiple to round to. Must be non-zero and finite.
    ///
    /// - Returns: A new floating-point value rounded to the nearest multiple of `value`.
    ///
    /// - Complexity: O(1)
    ///
    /// - Note: Uses banker's rounding (.toNearestOrEven) by default. When equidistant from two
    ///   multiples, rounds to the even multiple.
    ///
    /// # Example
    /// ```swift
    /// let number = 23.7
    /// let rounded = number.roundedToNearest(5.0) // 25.0
    ///
    /// let value = 2.5
    /// let result = value.roundedToNearest(1.0) // 2.0 (banker's rounding)
    /// ```
    @inlinable
    func roundedToNearest(_ value: Self) -> Self {
        Self((Double(self) / Double(value)).rounded() * Double(value))
    }
    
    /// Rounds the value to the nearest multiple of the specified value using a custom rounding rule.
    ///
    /// This method modifies the floating-point value in place, rounding it to the nearest multiple of
    /// the given value using the specified rounding rule.
    ///
    /// - Parameters:
    ///   - value: The multiple to round to. Must be non-zero and finite.
    ///   - rule: The rounding rule to apply (e.g., `.up`, `.down`, `.toNearestOrAwayFromZero`).
    ///
    /// - Complexity: O(1)
    ///
    /// # Example
    /// ```swift
    /// var number = 23.3
    /// number.roundToNearest(5.0, rule: .up) // number is now 25.0
    ///
    /// var value = 23.7
    /// value.roundToNearest(5.0, rule: .down) // value is now 20.0
    /// ```
    @inlinable
    mutating func roundToNearest(_ value: Self, rule: FloatingPointRoundingRule) {
        self = Self((Double(self) / Double(value)).rounded(rule) * Double(value))
    }
    
    /// Returns the value rounded to the nearest multiple of the specified value using a custom rounding rule.
    ///
    /// This method returns a new floating-point value rounded to the nearest multiple of the given value
    /// using the specified rounding rule, without modifying the original value.
    ///
    /// - Parameters:
    ///   - value: The multiple to round to. Must be non-zero and finite.
    ///   - rule: The rounding rule to apply (e.g., `.up`, `.down`, `.toNearestOrAwayFromZero`).
    ///
    /// - Returns: A new floating-point value rounded to the nearest multiple of `value` according to `rule`.
    ///
    /// - Complexity: O(1)
    ///
    /// # Example
    /// ```swift
    /// let number = 23.3
    /// let roundedUp = number.roundedToNearest(5.0, rule: .up) // 25.0
    /// let roundedDown = number.roundedToNearest(5.0, rule: .down) // 20.0
    /// let roundedAway = number.roundedToNearest(0.5, rule: .toNearestOrAwayFromZero) // 23.5
    /// ```
    @inlinable
    func roundedToNearest(_ value: Self, rule: FloatingPointRoundingRule) -> Self {
        Self((Double(self) / Double(value)).rounded(rule) * Double(value))
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
///   let wrappedValue = wrap(3.5, in: 0.0..<1.0)
///   print(wrappedValue) // Prints: 0.5
///   ```
///
/// - Note: This function handles wrapping for any value, whether it's above the upper bound
///   or below the lower bound of the range.
///
/// - SeeAlso: `BinaryFloatingPoint.wrap(in:)`, `BinaryFloatingPoint.wrapped(in:)`
@inlinable public func wrap<T: BinaryFloatingPoint>(_ value: T, in range: Range<T>) -> T {
    let start = range.lowerBound
    let width = range.upperBound - start
    let offset = value - range.lowerBound
    
    return (offset - (floor(offset / width) * width)) + start
}

/// Rounds a floating-point value to the nearest multiple of a specified step using the default rounding rule.
///
/// This function returns a new floating-point value rounded to the nearest multiple of the given step
/// using the `.toNearestOrEven` rounding rule (banker's rounding). This is useful for quantizing values
/// to fixed intervals, aligning to grids, or working with specific precision requirements.
///
/// - Parameters:
///   - value: The floating-point value to round.
///   - step: The multiple to round to. Must be non-zero and finite.
///
/// - Returns: A new floating-point value rounded to the nearest multiple of `step`.
///
/// - Complexity: O(1)
///
/// - Note: Uses banker's rounding (.toNearestOrEven) by default. When equidistant from two
///   multiples, rounds to the even multiple.
///
/// # Example
/// ```swift
/// let rounded = round(23.7, toNearest: 5.0) // 25.0
/// let value = round(2.5, toNearest: 1.0) // 2.0 (banker's rounding)
/// let precise = round(0.123, toNearest: 0.05) // 0.10
/// ```
@inlinable public func round<T: BinaryFloatingPoint>(_ value: T, toNearest step: T) -> T {
    T((Double(value) / Double(step)).rounded() * Double(step))
}

/// Rounds a floating-point value to the nearest multiple of a specified step using a custom rounding rule.
///
/// This function returns a new floating-point value rounded to the nearest multiple of the given step
/// using the specified rounding rule. This provides fine-grained control over rounding behavior for
/// quantization, grid alignment, or precision operations.
///
/// - Parameters:
///   - value: The floating-point value to round.
///   - step: The multiple to round to. Must be non-zero and finite.
///   - rule: The rounding rule to apply. Common rules include:
///     - `.up`: Round toward positive infinity
///     - `.down`: Round toward negative infinity
///     - `.toNearestOrAwayFromZero`: Round to nearest, ties away from zero
///     - `.toNearestOrEven`: Round to nearest, ties to even (default)
///     - `.towardZero`: Round toward zero
///     - `.awayFromZero`: Round away from zero
///
/// - Returns: A new floating-point value rounded to the nearest multiple of `step` according to `rule`.
///
/// - Complexity: O(1)
///
/// # Example
/// ```swift
/// let roundedUp = round(23.3, toNearest: 5.0, rule: .up) // 25.0
/// let roundedDown = round(23.7, toNearest: 5.0, rule: .down) // 20.0
/// let roundedAway = round(2.5, toNearest: 1.0, rule: .toNearestOrAwayFromZero) // 3.0
/// let toZero = round(-7.3, toNearest: 5.0, rule: .towardZero) // -5.0
/// ```
@inlinable public func round<T: BinaryFloatingPoint>(_ value: T, toNearest step: T, rule: FloatingPointRoundingRule) -> T {
    T((Double(value) / Double(step)).rounded(rule) * Double(step))
}
