//
//  ArrayExtension.swift
//  Sylex
//
//  Created by Pierre TACCHI on 25/07/2018.
//

public extension Array where Element: Equatable {
    /// Produces a copy of `self` where all duplicates have been removed.
    ///
    /// - Returns: A copy of `self` where all items are garanteed unique.
    public func removingDuplicates() -> Array {
        return self.reduce(into: []) { result, element in
            if !result.contains(element) {
                result.append(element)
            }
        }
    }
    
    
    /// Removes all the duplicates from `self`.
    public mutating func removeDuplicates() {
        self = self.removingDuplicates()
    }
}
