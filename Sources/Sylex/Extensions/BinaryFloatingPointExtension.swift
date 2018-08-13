//
//  BinaryFloatingPointExtension.swift
//  Sylex
//
//  Created by Pierre TACCHI on 13/08/2018.
//
import CoreGraphics

extension BinaryFloatingPoint {
    /// Increment `self` by one unit.
    ///
    /// - Returns: `self` incremented by one unit.
    public postfix static func ++(lhs: inout Self) -> Self  {
        lhs += 1
        return lhs
    }
    
    /// Decrement `self` by one unit.
    ///
    /// - Returns: `self` decrement by one unit.
    public postfix static func --(lhs: inout Self) -> Self  {
        lhs -= 1
        return lhs
    }
    
    /// Increment `self` by one unit.
    ///
    /// - Returns: `self`.
    public prefix static func ++(rhs: inout Self) -> Self {
        defer { rhs += 1 }
        return rhs
    }
    
    /// Decrement `self` by one unit.
    ///
    /// - Returns: `self`.
    public prefix static func --(rhs: inout Self) -> Self {
        defer { rhs -= 1 }
        return rhs
    }
}

extension BinaryFloatingPoint {
    public static func **<T: BinaryInteger>(lhs: Self, rhs: T) -> Self {
        return Self(pow(CGFloat(lhs), CGFloat(rhs)))
    }
    
    public static func **<T: BinaryFloatingPoint>(lhs: Self, rhs: T) -> Self {
        return Self(pow(CGFloat(lhs), CGFloat(rhs)))
    }
}
