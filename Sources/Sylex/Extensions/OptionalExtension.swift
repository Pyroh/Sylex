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
    
    /// Makes `self` equals to `nil`.
    @inlinable
    mutating func nilify() {
        self = nil
    }
    
    
    /// Returns true if `rhs` is not nil.
    /// - Parameter rhs: The value to test if nil.
    @inlinable
    prefix static func !!(rhs: Self) -> Bool {
        return !rhs.isNil
    }
}
