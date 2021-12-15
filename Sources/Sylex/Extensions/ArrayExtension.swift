//
//  ArrayExtension.swift
//  Sylex
//

public extension Array where Element: Equatable {
    /// Produces a copy of `self` where all duplicates have been removed.
    ///
    /// - Returns: A copy of `self` where all items are garanteed unique.
    @inlinable func removingDuplicates() -> Array {
        return self.reduce(into: []) { result, element in
            if !result.contains(element) {
                result.append(element)
            }
        }
    }
    
    /// Removes all the duplicates from `self`.
    @inlinable mutating func removeDuplicates() {
        self = self.removingDuplicates()
    }
}

public extension Array where Element: Hashable {
    /// An instance of `Set<Element>` from `self`.
    @inlinable var set: Set<Element> {
        return Set(self)
    }
    
    /// Produces a copy of `self` where all duplicates have been removed.
    ///
    /// - Returns: A copy of `self` where all items are garanteed unique.
    @inlinable func removingDuplicates() -> [Element] {
        return self.set.array
    }
    
    /// Removes all the duplicates from `self`.
    @inlinable mutating func removeDuplicates() {
        self = self.removingDuplicates()
    }
}


