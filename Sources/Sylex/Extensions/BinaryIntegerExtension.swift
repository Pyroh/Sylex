//
//  BinaryIntegerExtension.swift
//  Sylex
//
//  Created by Pierre TACCHI on 13/08/2018.
//
import Foundation

public extension BinaryInteger {
    /// Increment `self` by one unit.
    ///
    /// - Returns: `self` incremented by one unit.
    @discardableResult
    postfix static func ++(lhs: inout Self) -> Self  {
        lhs += 1
        return lhs
    }
    
    /// Decrement `self` by one unit.
    ///
    /// - Returns: `self` decrement by one unit.
    @discardableResult
    postfix static func --(lhs: inout Self) -> Self  {
        lhs -= 1
        return lhs
    }
    
    /// Increment `self` by one unit.
    ///
    /// - Returns: `self`.
    prefix static func ++(rhs: inout Self) -> Self {
        defer { rhs += 1 }
        return rhs
    }
    
    /// Decrement `self` by one unit.
    ///
    /// - Returns: `self`.
    prefix static func --(rhs: inout Self) -> Self {
        defer { rhs -= 1 }
        return rhs
    }
}

extension BinaryInteger {
    public static func **<T: BinaryInteger>(lhs: Self, rhs: T) -> Self {
        return Self(pow(Double(lhs), Double(rhs)))
    }
    
    public static func **<T: BinaryFloatingPoint>(lhs: Self, rhs: T) -> Self {
        return Self(pow(Double(lhs), Double(rhs)))
    }
}

extension BinaryInteger {
    public postfix static func %(lhs: Self) -> Float {
        return Float(lhs) / 100.0
    }
    
    public postfix static func %(lhs: Self) -> Float80 {
        return Float80(lhs) / 100.0
    }
    
    public postfix static func %(lhs: Self) -> Double {
        return Double(lhs) / 100.0
    }
    
    public postfix static func %(lhs: Self) -> CGFloat {
        return CGFloat(lhs) / 100.0
    }
}
