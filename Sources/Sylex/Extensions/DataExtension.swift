//
//  File.swift
//  
//
//  Created by Pierre Tacchi on 29/09/20.
//

import Foundation

public extension Data {
    @inlinable func string(encoding: String.Encoding = .utf8) -> String? {
        String(data: self, encoding: encoding)
    }
}
