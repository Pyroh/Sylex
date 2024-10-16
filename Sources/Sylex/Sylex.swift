//
//  Sylex.swift
//
//  Sylex
//
//  MIT License
//
//  Copyright (c) 2024 Pierre Tacchi
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

@_exported import CoreGeometry
@_exported import OptionalType
@_exported import SmoothOperators
@_exported import SwizzleIMD
@_exported import ZeroableProtocol
@_exported import Consequences


prefix operator ??

public typealias CompletionHandler = () -> Void
public typealias Callback<each T> = (repeat each T) -> Void

@available(*, deprecated, renamed: "Callback", message: "")
public typealias CallbackDuo<A, B> = (A, B) -> Void
@available(*, deprecated, renamed: "Callback", message: "")
public typealias CallbackTrio<A, B, C> = (A, B, C) -> Void

@available(*, deprecated)
@inlinable public func completion<A>(_ block: @escaping () -> ()) -> (A) -> () { { _ in block() } }
@available(*, deprecated)
@inlinable public func completion<A, B>(_ block: @escaping () -> ()) -> (A, B) -> () { { _,_ in block() } }
@available(*, deprecated)
@inlinable public func completion<A, B, C>(_ block: @escaping () -> ()) -> (A, B, C) -> () { { _,_,_ in block() } }
@available(*, deprecated)
@inlinable public func completion<A, B, C, D>(_ block: @escaping () -> ()) -> (A, B, C, D) -> () { { _,_,_,_ in block() } }
@available(*, deprecated)
@inlinable public func completion<A, B, C, D, E>(_ block: @escaping () -> ()) -> (A, B, C, D, E) -> () { { _,_,_,_,_ in block() } }
@available(*, deprecated)
@inlinable public func completion<A, B, C, D, E, F>(_ block: @escaping () -> ()) -> (A, B, C, D, E, F) -> () { { _,_,_,_,_,_ in block() } }
@available(*, deprecated)
@inlinable public func completion<A, B, C, D, E, F, G>(_ block: @escaping () -> ()) -> (A, B, C, D, E, F, G) -> () { { _,_,_,_,_,_,_ in block() } }
@available(*, deprecated)
@inlinable public func completion<A, B, C, D, E, F, G, H>(_ block: @escaping () -> ()) -> (A, B, C, D, E, F, G, H) -> () { { _,_,_,_,_,_,_,_ in block() } }
@available(*, deprecated)
@inlinable public func completion<A, B, C, D, E, F, G, H, I>(_ block: @escaping () -> ()) -> (A, B, C, D, E, F, G, H, I) -> () { { _,_,_,_,_,_,_,_,_ in block() } }
@available(*, deprecated)
@inlinable public func completion<A, B, C, D, E, F, G, H, I, J>(_ block: @escaping () -> ()) -> (A, B, C, D, E, F, G, H, I, J) -> () { { _,_,_,_,_,_,_,_,_,_ in block() } }

/// Constrains a value within a specified range.
///
/// This function takes a value x and ensures it falls within the range defined by min and max.
/// If x is less than min, the function returns min. If x is greater than max, it returns max.
/// Otherwise, it returns x unchanged.
///
/// - Parameters:
///   - x: The value to clamp.
///   - min: The lower bound of the range.
///   - max: The upper bound of the range.
/// - Returns: A value not less than min and not greater than max.
///
/// - Note: The @inlinable attribute suggests that the compiler may replace calls to this function
///   with its implementation at the call site, potentially improving performance.
///
/// - Example:
///   swift ///   let clamped = clamp(10, min: 0, max: 5) ///   print(clamped) // Outputs: 5 /// ///   let clamped2 = clamp(-3, min: 0, max: 5) ///   print(clamped2) // Outputs: 0 /// ///   let clamped3 = clamp(3, min: 0, max: 5) ///   print(clamped3) // Outputs: 3 ///
///
/// - SeeAlso: min(_:_:), max(_:_:)
@inlinable public func clamp<T: Comparable>(_ x: T, _ min: T, _ max: T) -> T {
    return Swift.min(Swift.max(x, min), max)
}

@available(*, deprecated)
@inlinable public func address<T>(of object: T) -> Int {
    unsafeBitCast(object, to: Int.self)
}

/// Creates a sequence of integers from zero up to, but not including, the given end value.
///
/// This function generates a sequence that starts from 0 and increments by 1, stopping before it reaches
/// the specified upper bound.
///
/// - Parameter bound: The upper bound of the sequence (exclusive).
/// - Returns: A `StrideTo<I>` sequence from 0 to `bound` (exclusive), incrementing by 1.
///
/// - Note: This is a convenience wrapper around the more general `stride(from:to:by:)` function.
///
/// - Example:
///   ```swift
///   for i in stride(to: 5) {
///       print(i)
///   }
///   // Prints: 0, 1, 2, 3, 4
///   ```
///
/// - SeeAlso: `stride(from:to:by:)`, `stride(through:)`
@inlinable public func stride<I: BinaryInteger>(to bound: I) -> StrideTo<I> {
    stride(from: 0, to: bound, by: 1)
}

/// Creates a sequence of integers from zero through the given end value, inclusive.
///
/// This function generates a sequence that starts from 0 and increments by 1, including the specified
/// upper bound as the last value if it's reachable.
///
/// - Parameter bound: The upper bound of the sequence (inclusive).
/// - Returns: A `StrideThrough<I>` sequence from 0 through `bound` (inclusive), incrementing by 1.
///
/// - Note: This is a convenience wrapper around the more general `stride(from:through:by:)` function.
///
/// - Example:
///   ```swift
///   for i in stride(through: 5) {
///       print(i)
///   }
///   // Prints: 0, 1, 2, 3, 4, 5
///   ```
///
/// - SeeAlso: `stride(from:through:by:)`, `stride(to:)`
@inlinable public func stride<I: BinaryInteger>(through bound: I) -> StrideThrough<I> {
    stride(from: 0, through: bound, by: 1)
}

/// Performs a mutable operation on a copy of the given value and returns the result.
///
/// This function creates a mutable copy of the input, applies the given transformation,
/// and returns the modified copy. The original value is not modified.
///
/// - Parameters:
///   - subject: The value to be transformed.
///   - transform: A closure that takes an inout parameter of the same type as `subject`
///                and performs the desired modifications.
///
/// - Returns: A new instance of `T` with the applied transformations.
///
/// - Throws: Rethrows any error that the `transform` closure might throw.
///
/// - Example:
///   ```swift
///   let original = [1, 2, 3]
///   let modified = withMutable(original) { $0.append(4) }
///   print(original) // Prints: [1, 2, 3]
///   print(modified) // Prints: [1, 2, 3, 4]
///   ```
@inlinable public func withMutable<T>(_ subject: T,
                                      transform: (inout T) throws -> ()) rethrows -> T {
    var proxy = subject
    try transform(&proxy)
    
    return proxy
}

/// Creates a copy of the given value with a single property modified.
///
/// This function creates a copy of the input, modifies the specified property,
/// and returns the modified copy. The original value is not modified.
///
/// - Parameters:
///   - subject: The value to be copied and modified.
///   - keyPath: A writable key path indicating the property to be modified.
///   - value: The new value to set for the specified property.
///
/// - Returns: A new instance of `T` with the specified property modified.
///
/// - Example:
///   ```swift
///   struct User { var name: String }
///   let user = User(name: "Alice")
///   let updatedUser = copy(user, replacing: \.name, with: "Bob")
///   print(user.name) // Prints: "Alice"
///   print(updatedUser.name) // Prints: "Bob"
///   ```
@inlinable public func copy<T, U>(_ subject: T,
                                  replacing keyPath: WritableKeyPath<T, U>,
                                  with value: U) -> T {
    withMutable(subject) { $0[keyPath: keyPath] = value }
}

/// Bridges a Swift object to an `UnsafeRawPointer`.
///
/// This function creates an unmanaged reference to the object and returns it as a raw pointer.
/// The object is not retained, and the caller is responsible for ensuring the object remains alive
/// while the pointer is in use.
///
/// - Parameter object: The object to bridge to a raw pointer.
///
/// - Returns: An `UnsafeRawPointer` representing the object.
///
/// - Warning: The returned pointer is valid only for the lifetime of the object.
///            Ensure the object is not deallocated while using the pointer.
///
/// - Example:
///   ```swift
///   let obj = NSObject()
///   let ptr = bridge(obj)
///   ```
@inlinable public func bridge<T: AnyObject>(_ object: T) -> UnsafeRawPointer {
    .init(Unmanaged.passUnretained(object).toOpaque())
}

/// Bridges a Swift object to an `UnsafeMutableRawPointer`.
///
/// This function creates an unmanaged reference to the object and returns it as a mutable raw pointer.
/// The object is not retained, and the caller is responsible for ensuring the object remains alive
/// while the pointer is in use.
///
/// - Parameter object: The object to bridge to a mutable raw pointer.
///
/// - Returns: An `UnsafeMutableRawPointer` representing the object.
///
/// - Warning: The returned pointer is valid only for the lifetime of the object.
///            Ensure the object is not deallocated while using the pointer.
///
/// - Example:
///   ```swift
///   let obj = NSMutableData()
///   let ptr = mutableBridge(obj)
///   ```
@inlinable public func mutableBridge<T: AnyObject>(_ object: T) -> UnsafeMutableRawPointer {
    .init(mutating: bridge(object))
}

/// Bridges an `UnsafeRawPointer` back to a Swift object.
///
/// This function takes a raw pointer that was previously created from a Swift object
/// and returns the original object. The object is not retained.
///
/// - Parameter ptr: The raw pointer to bridge back to a Swift object.
///
/// - Returns: The original Swift object of type `T`.
///
/// - Warning: Ensure that the pointer was created from an object of type `T`.
///            Passing an invalid pointer or a pointer to an object of a different type
///            will result in undefined behavior.
///
/// - Example:
///   ```swift
///   let obj = NSObject()
///   let ptr = bridge(obj)
///   let bridgedObj: NSObject = bridge(ptr)
///   ```
@inlinable public func bridge<T:AnyObject>(_ ptr: UnsafeRawPointer) -> T {
    Unmanaged<T>.fromOpaque(ptr).takeUnretainedValue()
}

/// Bridges an `UnsafeMutableRawPointer` back to a Swift object.
///
/// This function takes a mutable raw pointer that was previously created from a Swift object
/// and returns the original object. The object is not retained.
///
/// - Parameter ptr: The mutable raw pointer to bridge back to a Swift object.
///
/// - Returns: The original Swift object of type `T`.
///
/// - Warning: Ensure that the pointer was created from an object of type `T`.
///            Passing an invalid pointer or a pointer to an object of a different type
///            will result in undefined behavior.
///
/// - Example:
///   ```swift
///   let obj = NSMutableData()
///   let ptr = mutableBridge(obj)
///   let bridgedObj: NSMutableData = mutableBridge(ptr)
///   ```
@inlinable public func mutableBridge<T: AnyObject>(_ ptr: UnsafeMutableRawPointer) -> T {
    bridge(UnsafeRawPointer(ptr))
}
