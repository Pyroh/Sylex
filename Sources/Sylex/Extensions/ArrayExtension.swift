//
//  ArrayExtension.swift
//  Sylex
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

public extension Array {
    mutating func sort<T: Comparable>(by key: KeyPath<Element, T>) {
        sort { (lhs, rhs) -> Bool in lhs[keyPath: key] < rhs[keyPath: key] }
    }
    
    mutating func sort(alphabeticallyBy key: KeyPath<Element, String>) {
        sort { (lhs, rhs) -> Bool in lhs[keyPath: key].compare(rhs[keyPath: key]) == .orderedAscending }
    }
    
    mutating func sort(caseInsensitiveBy key: KeyPath<Element, String>) {
        sort { (lhs, rhs) -> Bool in lhs[keyPath: key].caseInsensitiveCompare(rhs[keyPath: key]) == .orderedAscending }
    }
    
    mutating func sort(localizedBy key: KeyPath<Element, String>) {
        sort { (lhs, rhs) -> Bool in lhs[keyPath: key].localizedCompare(rhs[keyPath: key]) == .orderedAscending }
    }
    
    mutating func sort(localizedCaseInsensitiveBy key: KeyPath<Element, String>) {
        sort { (lhs, rhs) -> Bool in lhs[keyPath: key].localizedCaseInsensitiveCompare(rhs[keyPath: key]) == .orderedAscending }
    }
    
    mutating func sort(localizedStandardBy key: KeyPath<Element, String>) {
        sort { (lhs, rhs) -> Bool in lhs[keyPath: key].localizedStandardCompare(rhs[keyPath: key]) == .orderedAscending }
    }
}
