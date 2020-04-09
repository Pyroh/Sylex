//
//  BinaryFloatingPointExtension.swift
//  Sylex
//
//  Created by Pierre TACCHI on 13/08/2018.
//
import Foundation
#if !os(macOS)
import CoreGraphics
#endif

//extension BinaryFloatingPoint {
//    /// Increment `self` by one unit.
//    ///
//    /// - Returns: `self` incremented by one unit.
//    @discardableResult @inlinable
//    public prefix static func ++(lhs: inout Self) -> Self  {
//        lhs += 1
//        return lhs
//    }
//
//    /// Decrement `self` by one unit.
//    ///
//    /// - Returns: `self` decrement by one unit.
//    @discardableResult @inlinable
//    public prefix static func --(lhs: inout Self) -> Self  {
//        lhs -= 1
//        return lhs
//    }
//
//    /// Increment `self` by one unit.
//    ///
//    /// - Returns: `self`.
//    @discardableResult @inlinable
//    public postfix static func ++(rhs: inout Self) -> Self {
//        defer { rhs += 1 }
//        return rhs
//    }
//
//    /// Decrement `self` by one unit.
//    ///
//    /// - Returns: `self`.
//    @discardableResult @inlinable
//    public postfix static func --(rhs: inout Self) -> Self {
//        defer { rhs -= 1 }
//        return rhs
//    }
//}
//

extension BinaryFloatingPoint {

    /// Returns the exponentiation of `lhs` by `rhs`.
    /// - Parameter lhs: The value to exponentiate.
    /// - Parameter rhs: The exponent.
    @inlinable
    public static func **<T: BinaryInteger>(lhs: Self, rhs: T) -> Self {
        return Self(pow(CGFloat(lhs), CGFloat(rhs)))
    }

    /// Returns the exponentiation of `lhs` by `rhs`.
    /// - Parameter lhs: The value to exponentiate.
    /// - Parameter rhs: The exponent.
    public static func **<T: BinaryFloatingPoint>(lhs: Self, rhs: T) -> Self {
        return Self(pow(CGFloat(lhs), CGFloat(rhs)))
    }
}
