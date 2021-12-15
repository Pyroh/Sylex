//
//  StringExtension.swift
//  Sylex
//
//

import Foundation

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
