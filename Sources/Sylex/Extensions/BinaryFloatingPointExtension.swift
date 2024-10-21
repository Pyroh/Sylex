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
