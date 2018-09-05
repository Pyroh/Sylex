//
//  ArrayExtension.swift
//  Sylex
//
//  Created by Pierre TACCHI on 22/08/2018.
//

public extension Array where Element: Hashable {
    public func diff(from rhs: [Element]) -> DifferenceSet {
        var differentiator = ArrayDiff(source: rhs, target: self)
        return DifferenceSet(from: differentiator.computeDiff())
    }
}

