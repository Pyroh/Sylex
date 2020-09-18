//
//  CollectionExtension.swift
//  
//
//  Created by Pierre TACCHI on 25/11/2019.
//

//public extension Collection {
//    
//    /// Returns the indexes of the elements in the collection that matche the given predicate.
//    /// - Parameter predicate: A closure that takes an element as its argument and returns a `Bool` value that indicates whether the passed element represents a match.
//    func allIndexes(where predicate: (Element) throws -> Bool) rethrows -> [Int]? {
//        try self.enumerated().compactMap {
//            try predicate($0.element) ? $0.offset : nil
//            }..{ $0.isEmpty ? nil : $0 }
//    }
//}
//
//public extension Collection where Element: Equatable {
//    
//    /// Returns all the indexes of the givien value.
//    /// - Parameter element: The element to search for in the array.
//    func allIndexes(of element: Element) -> [Int]? {
//        self.enumerated().compactMap {
//            element == $0.element ? $0.offset : nil
//            }..{ $0.isEmpty ? nil : $0 }
//    }
//}
