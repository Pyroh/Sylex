//
//  BinaryIntegerExtension.swift
//  Sylex
//
//  Created by Pierre TACCHI on 13/08/2018.
//
import Foundation
import CoreGraphics

public extension BinaryInteger {
    /// Increment `self` by one unit.
    ///
    /// - Returns: `self` incremented by one unit.
    @discardableResult @inlinable
    prefix static func ++(lhs: inout Self) -> Self  {
        lhs += 1
        return lhs
    }
    
    /// Decrement `self` by one unit.
    ///
    /// - Returns: `self` decrement by one unit.
    @discardableResult @inlinable
    prefix static func --(lhs: inout Self) -> Self  {
        lhs -= 1
        return lhs
    }
    
    /// Increment `self` by one unit.
    ///
    /// - Returns: `self`.
    @discardableResult @inlinable
    postfix static func ++(rhs: inout Self) -> Self {
        defer { rhs += 1 }
        return rhs
    }
    
    /// Decrement `self` by one unit.
    ///
    /// - Returns: `self`.
    @discardableResult @inlinable
    postfix static func --(rhs: inout Self) -> Self {
        defer { rhs -= 1 }
        return rhs
    }
}

extension BinaryInteger {
    
    /// Returns the exponentiation of `lhs` by `rhs`.
    /// - Parameter lhs: The value to exponentiate.
    /// - Parameter rhs: The exponent.
    @inlinable
    public static func **<T: BinaryInteger>(lhs: Self, rhs: T) -> Self {
        return Self(pow(Double(lhs), Double(rhs)))
    }
    
    /// Returns the exponentiation of `lhs` by `rhs`.
    /// - Parameter lhs: The value to exponentiate.
    /// - Parameter rhs: The exponent.
    @inlinable
    public static func **<T: BinaryFloatingPoint>(lhs: Self, rhs: T) -> Self {
        return Self(pow(Double(lhs), Double(rhs)))
    }
}

extension BinaryInteger {
    
    @inlinable
    public postfix static func %(lhs: Self) -> Float {
        return Float(lhs) / 100.0
    }
    
    @inlinable
    public postfix static func %(lhs: Self) -> Double {
        return Double(lhs) / 100.0
    }
    
    @inlinable
    public postfix static func %(lhs: Self) -> CGFloat {
        return CGFloat(lhs) / 100.0
    }
}

extension BinaryInteger {
    
    @inlinable
    public postfix static func -(rhs: Self) -> Self {
        return rhs - 1
    }
    
    @inlinable
    public postfix static func +(rhs: Self) -> Self {
        return rhs + 1
    }
}
