//
//  SetExtension.swift
//  Sylex
//
//  Created by Pierre TACCHI on 19/08/2018.
//

public extension Set {
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
    @inlinable var array: [Element] {
        return Array(self)
    }
}
