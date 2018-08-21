//
//  SequenceExtension.swift
//  Sylex
//
//  Created by Pierre TACCHI on 21/08/2018.
//

extension Sequence {
    func wholeMap<T>(_ transform: (Self) throws -> T) rethrows -> T {
        return try transform(self)
    }
}
