//
//  OptionalExtension.swift
//  Sylex
//
//  Created by Pierre TACCHI on 25/07/2018.
//

public extension Optional {
    /// Returns `true` if `self` is `nil`, `false` otherwise.
    var isNil: Bool {
        return self == nil
    }
    
    /// Makes `self` equals to `nil`.
    mutating func nilify() {
        self = nil
    }
}
