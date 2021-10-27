//
//  OptionalExtension.swift
//  Sylex
//
//  Created by Pierre TACCHI on 25/07/2018.
//

public extension Optional {
    /// Returns `true` if `self` is `nil`, `false` otherwise.
    @inlinable
    var isNil: Bool {
        return self == nil
    }
    
    /// Makes `self` equal to `nil`.
    @inlinable
    mutating func nilify() {
        self = nil
    }
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
