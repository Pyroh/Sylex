//
//  OptionalExtension.swift
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

import ZeroableProtocol

public extension Optional {
    /// Sets the optional value to nil.
    ///
    /// This method provides a convenient way to set an optional value to nil,
    /// which can be particularly useful in certain programming patterns or to
    /// improve code readability.
    ///
    /// - Note: This method modifies the optional in place.
    ///
    /// - Example:
    ///   ```swift
    ///   var optionalValue: Int? = 5
    ///   print(optionalValue) // Prints: Optional(5)
    ///
    ///   optionalValue.nilify()
    ///   print(optionalValue) // Prints: nil
    ///   ```
    ///
    /// - SeeAlso: `Optional`
    @inlinable mutating func nilify() { self = nil }
}

@available(*, deprecated)
public extension Optional where Wrapped: Zeroable {
    @inlinable static prefix func ??(_ rhs: Self) -> Wrapped {
        rhs ?? Wrapped.zero
    }
}

@available(*, deprecated)
public extension Optional where Wrapped == String {
    @inlinable static prefix func ??(_ rhs: Self) -> Wrapped {
        rhs ?? ""
    }
}
