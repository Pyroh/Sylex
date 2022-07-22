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

public extension Array {
    static func +(lhs: Self, rhs: Self.Element) -> Self {
        withMutable(lhs) { $0.append(rhs) }
    }
    
    static func +<S>(lhs: Self, rhs: S) -> Self where S: Sequence, S.Element == Element {
        withMutable(lhs) { $0.append(contentsOf: rhs) }
    }
    
    static func +=(lhs: inout Self, rhs: Self.Element) {
        lhs.append(rhs)
    }
    
    static func +<S>(lhs: inout Self, rhs: S) where S: Sequence, S.Element == Element {
        lhs.append(contentsOf: rhs)
    }
}
