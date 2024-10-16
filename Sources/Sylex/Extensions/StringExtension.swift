//
//  StringExtension.swift
//  Sylex
//
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

@available(*, deprecated)
public extension StringProtocol {
    /// The number of lines in the receiver.
    @inlinable var lineCount: Int {
        filter(equalTo: "\n").count + 1
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
