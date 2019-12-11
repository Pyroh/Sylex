//
//  BinaryIntegerExtension.swift
//  Sylex
//
//  Created by Pierre TACCHI on 13/08/2018.
//
import Foundation
import CoreGraphics


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
