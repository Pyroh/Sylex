//
//  File.swift
//  
//
//  Created by Pierre TACCHI on 11/12/2019.
//

import Foundation

// MARK: - Operator ++

/// Increments the given value by one unit and returns it.
@discardableResult @inlinable
public prefix func ++<T: Strideable>(rhs: inout T) -> T  {
    rhs = rhs.advanced(by: 1)
    return rhs
}

/// Returns the given value and increments it by one unit.
@discardableResult @inlinable
public postfix func ++<T: Strideable>(lhs: inout T) -> T {
    defer { lhs = lhs.advanced(by: 1) }
    return lhs
}
// MARK: - Operator --

/// Decrements the given value by one unit and returns it.
@discardableResult @inlinable
public prefix func --<T: Strideable>(rhs: inout T) -> T  {
    rhs = rhs.advanced(by: -1)
    return rhs
}

/// Returns the given value and decrements it by one unit.
@discardableResult @inlinable
public postfix func --<T: Strideable>(lhs: inout T) -> T {
    defer { lhs = lhs.advanced(by: -1) }
    return lhs
}

// MARK: -

/// Returns the given value incremented by one unit.
@inlinable
public postfix func +<T: Strideable>(lhs: T) -> T {
    return lhs.advanced(by: 1)
}

/// Returns the given value decremented by one unit.
@inlinable
public postfix func -<T: Strideable>(lhs: T) -> T {
    return lhs.advanced(by: -1)
}

@inlinable
public postfix func %<T: FloatingPoint>(lhs: T) -> T {
    return lhs / 100
}
