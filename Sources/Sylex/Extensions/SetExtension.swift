//
//  SetExtension.swift
//  Sylex
//
//  Created by Pierre TACCHI on 19/08/2018.
//

public extension Set {
    /// An instance of `[Element]` from `self`.
    @inlinable var array: [Element] {
        return Array(self)
    }
}
