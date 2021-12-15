//
//  OptionalExtension.swift
//  Sylex
//
//  Created by Pierre TACCHI on 25/07/2018.
//

import ZeroableProtocol

public extension Optional {
    /// Makes `self` equal to `nil`.
    @inlinable mutating func nilify() { self = nil }
}

public extension Optional where Wrapped: Zeroable {
    @inlinable static prefix func ??(_ rhs: Self) -> Wrapped {
        rhs ?? Wrapped.zero
    }
}

public extension Optional where Wrapped == String {
    @inlinable static prefix func ??(_ rhs: Self) -> Wrapped {
        rhs ?? ""
    }
}
