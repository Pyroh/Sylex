//
//  OptionalExtension.swift
//  Sylex
//
//  Created by Pierre TACCHI on 25/07/2018.
//

public extension Optional {
    
    /// Returns `true` if `self` is `nil`, `false` otherwise.
    public var isNil: Bool {
        return self == nil
    }
    
    /// Makes `self` equals to `nil`.
    public mutating func nilify() {
        self = nil
    }
}
