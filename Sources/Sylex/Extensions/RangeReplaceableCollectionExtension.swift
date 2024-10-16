//
//  RangeReplaceableCollectionExtension.swift
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

import ZeroableProtocol

public extension RangeReplaceableCollection where Element: Zeroable {
    /// Initializes a new collection with the specified number of zero elements.
    ///
    /// This initializer creates a new collection containing `count` number of zero elements.
    /// It uses the `zero` value provided by the `Zeroable` protocol to populate the collection.
    ///
    /// - Parameter count: The number of zero elements to include in the new collection.
    ///
    /// - Complexity: O(n), where n is the `count`.
    ///
    /// - Note: This initializer requires that the `Element` type conforms to `Zeroable`,
    ///         which provides the `.zero` value.
    ///
    /// - Example:
    ///   ```swift
    ///   // Assuming Int conforms to Zeroable
    ///   let zeroArray = [Int](count: 5)
    ///   print(zeroArray) // Prints: [0, 0, 0, 0, 0]
    ///
    ///   // Assuming Double conforms to Zeroable
    ///   let zeroDoubles = [Double](count: 3)
    ///   print(zeroDoubles) // Prints: [0.0, 0.0, 0.0]
    ///   ```
    @inlinable init(count: Int) { self.init(repeating: .zero, count: count) }
}
