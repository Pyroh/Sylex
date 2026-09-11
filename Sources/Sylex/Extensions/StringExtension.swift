//
//  StringExtension.swift
//  Sylex
//
//  MIT License
//
//  Copyright (c) 2025 Pierre Tacchi
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
import Algorithms

/// An extension to `String` that provides methods for base64 encoding and decoding.
public extension String {
    /// Encodes the string to its base64 representation.
    ///
    /// This method first converts the string to data using the specified encoding,
    /// then encodes that data to a base64 string.
    ///
    /// - Parameter encoding: The string encoding to use when converting the string to data.
    ///                       Defaults to `.utf8`.
    ///
    /// - Returns: A base64 encoded string, or `nil` if the string couldn't be converted to data
    ///            using the specified encoding.
    ///
    /// - Note: The resulting string will be longer than the original due to the nature of base64 encoding.
    ///
    /// - Example:
    ///   ```swift
    ///   let original = "Hello, World!"
    ///   if let encoded = original.base64Encoded() {
    ///       print(encoded) // Prints: SGVsbG8sIFdvcmxkIQ==
    ///   }
    ///   ```
    @inlinable func base64Encoded(encoding: Encoding = .utf8) -> String? {
        data(using: encoding)?.base64EncodedString()
    }
    
    /// Decodes a base64 encoded string back to its original form.
    ///
    /// This method first decodes the base64 string to data, then converts that data
    /// back to a string using the specified encoding.
    ///
    /// - Parameter encoding: The string encoding to use when converting the decoded data back to a string.
    ///                       Defaults to `.utf8`.
    ///
    /// - Returns: The decoded string, or `nil` if the string isn't a valid base64 encoding
    ///            or if the resulting data couldn't be converted to a string using the specified encoding.
    ///
    /// - Note: This method assumes that the current string is a valid base64 encoding.
    ///         If it's not, the method will return `nil`.
    ///
    /// - Example:
    ///   ```swift
    ///   let encoded = "SGVsbG8sIFdvcmxkIQ=="
    ///   if let decoded = encoded.base64Decoded() {
    ///       print(decoded) // Prints: Hello, World!
    ///   }
    ///   ```
    @inlinable func base64Decoded(encoding: Encoding = .utf8) -> String? {
        Data(base64Encoded: self).flatMap { String(data: $0, encoding: encoding) }
    }
}

/// Extends String to provide custom initializers for integer representations.
public extension String {
    
    /// Represents different integer representation formats.
    enum IntegerRepresentation {
        /// Binary representation (base 2)
        case binary
        /// Hexadecimal representation (base 16)
        case hexadecimal
        
        /// The radix (base) for the representation.
        fileprivate var radix: Int {
            switch self {
            case .binary: return 2
            case .hexadecimal: return 16
            }
        }
        
        /// The prefix used for the representation.
        fileprivate var prefix: String {
            switch self {
            case .binary: return "0b"
            case .hexadecimal: return "0x"
            }
        }
        
        /// The number of bits represented by each character.
        fileprivate var byteCount: Int {
            switch self {
            case .binary: return 8
            case .hexadecimal: return 2
            }
        }
        
        /// The grouping configuration for the representation.
        fileprivate var group: (count: Int, separator: String) {
            switch self {
            case .binary: return (8, "_")
            case .hexadecimal: return (4, " ")
            }
        }
    }
    
    /// Initializes a string with a custom integer representation.
    /// - Parameters:
    ///   - value: The integer value to represent.
    ///   - representation: The desired representation (binary or hexadecimal).
    ///   - group: Whether to group digits for readability.
    ///   - prefix: Whether to include the representation prefix.
    ///   - uppercase: Whether to use uppercase letters for hexadecimal.
    init<T: BinaryInteger>(_ value: T, representation: IntegerRepresentation, group: Bool = false, prefix: Bool = true, uppercase: Bool = false) {
        let og = Self.init(value, radix: representation.radix, uppercase: uppercase)
        let expectedCount = MemoryLayout<T>.size * representation.byteCount
        let bytes = String(repeating: "0", count: expectedCount - og.count) + og
        
        if group {
            let chunkCount = representation.group.count
            let chunkSeparator = representation.group.separator
            self = "\(prefix ? representation.prefix : "")\(bytes.chunks(ofCount: chunkCount).joined(separator: chunkSeparator))"
        } else {
            self = "\(prefix ? representation.prefix : "")\(bytes)"
        }
    }
}

/// An extension to `String` that provides utilities for line/word analysis and character padding.
public extension String {
    /// Splits the string into its constituent lines, as determined by `enumerateLines(_:)`.
    ///
    /// This relies on `Foundation`'s line enumeration, which recognizes `"\n"`, `"\r"`,
    /// `"\r\n"`, and other Unicode line/paragraph separators as line boundaries, and does
    /// not produce a trailing empty line after a final line terminator. `lines.count` and
    /// `lineCount` therefore always agree.
    ///
    /// - Example:
    ///   ```swift
    ///   "a\nb\n".lines // ["a", "b"]
    ///   ```
    var lines: [String] {
        var result: [String] = []
        enumerateLines { line, _ in result.append(line) }
        return result
    }
    
    /// The number of lines in the string, as determined by `enumerateLines(_:)`.
    ///
    /// This relies on `Foundation`'s line enumeration, which recognizes `"\n"`, `"\r"`,
    /// `"\r\n"`, and other Unicode line/paragraph separators as line boundaries, and does
    /// not count a trailing empty line after a final line terminator.
    var lineCount: Int {
        var count = 0
        enumerateLines { _, _ in ++count }
        return count
    }
    
    #if !os(Linux)
    /// The number of words in the string, as determined by locale-aware word enumeration.
    ///
    /// Word boundaries are computed using `enumerateSubstrings(in:options:)` with the
    /// `.byWords` option, matching the same word-tokenization Foundation uses elsewhere
    /// (e.g. text views), rather than a simple whitespace split.
    var wordCount: Int {
        var count = 0
        enumerateSubstrings(in: ..<endIndex, options: .byWords) { _, _, _, _ in ++count }
        return count
    }
    #endif
    
    /// Pads the string on the left with a repeated character until it reaches a minimum length.
    ///
    /// If the string's character count is already `count` or greater, it's returned unchanged.
    /// Otherwise, enough copies of `prefix` are prepended to bring the total length up to `count`.
    ///
    /// - Parameters:
    ///   - prefix: The character to repeat and prepend.
    ///   - count: The minimum character count the result should have.
    /// - Returns: The padded string, or the original string if it already meets `count`.
    ///
    /// - Example:
    ///   ```swift
    ///   "7".prefix(with: "0", ifCharCountIsUnder: 3) // "007"
    ///   ```
    func prefix(with prefix: Character, ifCharCountIsUnder count: Int) -> String {
        guard self.count < count else { return string }
        let lead = Array(repeating: prefix, count: count - self.count)
        
        return lead.string + self
    }
    
    /// Pads the string on the right with a repeated character until it reaches a minimum length.
    ///
    /// If the string's character count is already `count` or greater, it's returned unchanged.
    /// Otherwise, enough copies of `suffix` are appended to bring the total length up to `count`.
    ///
    /// - Parameters:
    ///   - suffix: The character to repeat and append.
    ///   - count: The minimum character count the result should have.
    /// - Returns: The padded string, or the original string if it already meets `count`.
    ///
    /// - Example:
    ///   ```swift
    ///   "7".suffix(with: "0", ifCharCountIsUnder: 3) // "700"
    ///   ```
    func suffix(with suffix: Character, ifCharCountIsUnder count: Int) -> String {
        guard self.count < count else { return string }
        let trail = Array(repeating: suffix, count: count - self.count)
        
        return self + trail.string
    }
}
