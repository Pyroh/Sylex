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
    @inlinable mutating func sort<T: Comparable>(by key: KeyPath<Element, T>) {
        sort { (lhs, rhs) -> Bool in lhs[keyPath: key] < rhs[keyPath: key] }
    }
    
    @inlinable mutating func sort(alphabeticallyBy key: KeyPath<Element, String>) {
        sort { (lhs, rhs) -> Bool in lhs[keyPath: key].compare(rhs[keyPath: key]) == .orderedAscending }
    }
    
    @inlinable mutating func sort(caseInsensitiveBy key: KeyPath<Element, String>) {
        sort { (lhs, rhs) -> Bool in lhs[keyPath: key].caseInsensitiveCompare(rhs[keyPath: key]) == .orderedAscending }
    }
    
    @inlinable mutating func sort(localizedBy key: KeyPath<Element, String>) {
        sort { (lhs, rhs) -> Bool in lhs[keyPath: key].localizedCompare(rhs[keyPath: key]) == .orderedAscending }
    }
    
    @inlinable mutating func sort(localizedCaseInsensitiveBy key: KeyPath<Element, String>) {
        sort { (lhs, rhs) -> Bool in lhs[keyPath: key].localizedCaseInsensitiveCompare(rhs[keyPath: key]) == .orderedAscending }
    }
    
    @inlinable mutating func sort(localizedStandardBy key: KeyPath<Element, String>) {
        sort { (lhs, rhs) -> Bool in lhs[keyPath: key].localizedStandardCompare(rhs[keyPath: key]) == .orderedAscending }
    }
}
