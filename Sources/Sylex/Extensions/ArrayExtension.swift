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
    func removingDuplicates() -> Array {
        return self.reduce(into: []) { result, element in
            if !result.contains(element) {
                result.append(element)
            }
        }
    }
    
    
    /// Removes all the duplicates from `self`.
    mutating func removeDuplicates() {
        self = self.removingDuplicates()
    }
}

public extension Array where Element: Hashable {
    /// An instance of `Set<Element>` from `self`.
    var set: Set<Element> {
        return Set(self)
    }
    
    /// Produces a copy of `self` where all duplicates have been removed.
    ///
    /// - Returns: A copy of `self` where all items are garanteed unique.
    func removingDuplicates() -> [Element] {
        return self.set.array
    }
    
    /// Removes all the duplicates from `self`.
    mutating func removeDuplicates() {
        self = self.removingDuplicates()
    }
}
