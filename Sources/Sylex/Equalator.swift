//
//  Equalator.swift
//  Sylex
//
//  MIT License
//
//  Copyright (c) 2023 Pierre Tacchi
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

import Foundation

/// A structure that provides custom equality comparison for objects of type `T`.
///
/// `Equalator` allows for defining complex equality checks based on multiple properties of an object.
@frozen public struct Equalator<T> {
    /// A unit of comparison within an `Equalator`.
    ///
    /// Each `Unit` represents a single property comparison.
    public struct Unit {
        let equalator: (T, T) -> Bool
        
        /// Initializes a new `Unit` with a key path to an `Equatable` property.
        ///
        /// - Parameter key: A key path to an `Equatable` property of `T`.
        init<E: Equatable>(_ key: KeyPath<T, E>) {
            self.equalator = { $0[keyPath: key] == $1[keyPath: key] }
        }
        
        /// Compares two objects based on the property defined by this unit.
        ///
        /// - Parameters:
        ///   - lhs: The left-hand side object to compare.
        ///   - rhs: The right-hand side object to compare.
        /// - Returns: `true` if the properties are equal, `false` otherwise.
        func areEqual(_ lhs: T, _ rhs: T) -> Bool { equalator(lhs, rhs) }
    }
    
    let units: [Unit]
    
    /// Compares two objects based on all units in this `Equalator`.
    ///
    /// - Parameters:
    ///   - lhs: The left-hand side object to compare.
    ///   - rhs: The right-hand side object to compare.
    /// - Returns: `true` if all properties defined by the units are equal, `false` otherwise.
    func areEqual(_ lhs: T, _ rhs: T) -> Bool {
        for unit in units { guard unit.areEqual(lhs, rhs) else { return false } }
        return true
    }
}

/// A result builder for creating `Equalator` instances.
///
/// This builder allows for a declarative syntax when defining `Equalator` instances.
@resultBuilder
public enum EqualatorBuilder {
    /// Builds an `Equalator.Unit` from a key path.
    ///
    /// - Parameter key: A key path to an `Equatable` property.
    /// - Returns: An `Equalator.Unit` for the given key path.
    public static func buildExpression<T, E: Equatable>(_ key: KeyPath<T, E>) -> Equalator<T>.Unit {
        .init(key)
    }
    
    /// Combines multiple `Equalator.Unit` instances into an array.
    ///
    /// - Parameter units: A variadic list of `Equalator.Unit` instances.
    /// - Returns: An array of `Equalator.Unit` instances.
    public static func buildBlock<T>(_ units: Equalator<T>.Unit...) -> [Equalator<T>.Unit] {
        units
    }
    
    /// Builds the final `Equalator` from an array of `Unit` instances.
    ///
    /// - Parameter units: An array of `Equalator.Unit` instances.
    /// - Returns: An `Equalator` instance containing all the provided units.
    public static func buildFinalResult<T>(_ units: [Equalator<T>.Unit]) -> Equalator<T> {
        .init(units: units)
    }
}

/// Compares two objects of the same type based on an `Equalator` definition.
///
/// This function allows for a declarative syntax to define which properties should be compared for equality.
///
/// - Parameters:
///   - lhs: The left-hand side object to compare.
///   - rhs: The right-hand side object to compare.
///   - equalator: A closure that returns an `Equalator` instance, defined using the `EqualatorBuilder` syntax.
/// - Returns: `true` if all specified properties are equal between `lhs` and `rhs`, `false` otherwise.
///
/// - Example:
///   ```swift
///   struct Person {
///       let name: String
///       let age: Int
///   }
///
///   let person1 = Person(name: "Alice", age: 30)
///   let person2 = Person(name: "Alice", age: 31)
///
///   let areEqual = allKeysEqual(between: person1, and: person2) {
///       \.name
///       \.age
///   }
///   print(areEqual) // Prints: false
///   ```
public func allKeysEqual<T>(between lhs: T,
                            and rhs: T,
                            @EqualatorBuilder _ equalator: () -> Equalator<T>) -> Bool {
    equalator().areEqual(lhs, rhs)
}
