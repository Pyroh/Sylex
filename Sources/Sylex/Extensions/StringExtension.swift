//
//  StringExtension.swift
//  Sylex
//
//

import Foundation

extension String {
    
    /// Base64 encodes the receiver.
    func base64Encoded() -> String {
        Data(utf8).base64EncodedString()
    }
    
    /// Tries to Base64 decode the receiver.
    /// - Returns: The decoded string or `nil` if the receiver cannot be decoded.
    func base64Decoded() -> String? {
        Data(base64Encoded: self).flatMap { String(data: $0, encoding: .utf8) }
    }
}
