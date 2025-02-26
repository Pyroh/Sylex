//
//  NumberFormatterExtension.swift
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

public extension NumberFormatter {
    /// Creates a new `NumberFormatter` instance and configures it using the provided closure.
    ///
    /// This convenience initializer allows for a more concise and expressive way to create and configure
    /// a `NumberFormatter` instance in a single step.
    ///
    /// - Parameter configurator: A closure that takes a `NumberFormatter` instance as its parameter
    ///   and configures it. The closure has no return value.
    ///
    /// - Complexity: O(1)
    ///
    /// - Note: The configurator closure is called immediately after the `NumberFormatter` is initialized.
    ///
    /// - Example:
    ///   ```swift
    ///   let formatter = NumberFormatter { formatter in
    ///       formatter.numberStyle = .decimal
    ///       formatter.maximumFractionDigits = 2
    ///       formatter.minimumFractionDigits = 2
    ///   }
    ///
    ///   let number = 123.456
    ///   let formattedString = formatter.string(from: NSNumber(value: number))
    ///   // formattedString will be "123.46"
    ///   ```
    @inlinable
    convenience init(_ configurator: (NumberFormatter) -> ()) {
        self.init()
        configurator(self)
    }
}
