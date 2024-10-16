//
//  Utils.swift
//  Sylex
//
/// An array containing the elements of the set.
///
/// This property returns a new array containing all the elements of the set.
/// The order of the elements in the resulting array is undefined.
///
/// - Returns: An array containing the elements of the set.
///
/// - Complexity: O(n), where n is the number of elements in the set.
///
/// - Note: This property creates a new array each time it's accessed.
///         If you need to perform multiple operations on the array,
///         consider storing the result in a variable.
///
/// - Example:
///   ```swift
///   let set: Set = [1, 2, 3, 4, 5]
///   let array = set.array
///   print(array) // Prints: [1, 2, 3, 4, 5] (order may vary)
///
///   // Using it in a for-in loop
///   for element in set.array {
///       print(element)
///   }
///   ```

import ZeroableProtocol

@frozen public struct MatrixCoordinate: Equatable, Hashable, Codable, Zeroable {
    public var column: Int
    public var row: Int
    
    @inlinable public init(column: Int, row: Int) {
        self.column = column
        self.row = row
    }
    
    @usableFromInline init(_ pair: (row: Int, column: Int)) {
        self.column = pair.column
        self.row = pair.row
    }
    
    @inlinable public static var zero: MatrixCoordinate { .init(column: .zero, row: .zero) }
}

@frozen public struct MatrixSize: Equatable, Hashable, Codable, Zeroable {
    public var width: Int
    public var height: Int
    
    @inlinable public var count: Int { width * height }
    
    @inlinable public init(width: Int, height: Int) {
        self.width = width
        self.height = height
    }
    
    @inlinable public init(square amount: Int) {
        self.width = amount
        self.height = amount
    }
    
    @inlinable public static var zero: MatrixSize { .init(square: .zero) }
}


