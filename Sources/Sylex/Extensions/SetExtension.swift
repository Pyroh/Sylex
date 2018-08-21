//
//  SetExtension.swift
//  Sylex
//
//  Created by Pierre TACCHI on 19/08/2018.
//

public extension Set {
    /// Transform `self` in an instance of `[Element]`.
    ///
    /// - Returns: An instance of `[Element]` from `self`.
    public func array() -> [Element] {
        return Array(self)
    }
}
