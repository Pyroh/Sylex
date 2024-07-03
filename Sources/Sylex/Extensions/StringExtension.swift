//
//  StringExtension.swift
//  Sylex
//
//

import Foundation
import Algorithms

public extension String {
    
    /// Base64 encodes the receiver.
    @inlinable func base64Encoded(encoding: Encoding = .utf8) -> String? {
        data(using: encoding)?.base64EncodedString()
    }
    
    /// Tries to Base64 decode the receiver.
    /// - Returns: The decoded string or `nil` if the receiver cannot be decoded.
    @inlinable func base64Decoded(encoding: Encoding = .utf8) -> String? {
        Data(base64Encoded: self).flatMap { String(data: $0, encoding: encoding) }
    }
    
}

public extension StringProtocol {
    @inlinable var lineCount: Int {
        filter(equalTo: "\n").count + 1
    }
}

public extension String {
    enum IntegerRepresentation {
        case binary, hexadecimal
        
        fileprivate var radix: Int {
            switch self {
            case .binary: 2
            case .hexadecimal: 16
            }
        }
        
        fileprivate var prefix: String {
            switch self {
            case .binary: "0b"
            case .hexadecimal: "0x"
            }
        }
        
        fileprivate var byteCount: Int {
            switch self {
            case .binary: 8
            case .hexadecimal: 2
            }
        }
        
        fileprivate var group: (count: Int, separator: String) {
            switch self {
            case .binary: (8, "_")
            case .hexadecimal: (4, " ")
            }
        }
    }
    
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
