//
//  File.swift
//  
//
//  Created by Pierre Tacchi on 12/03/21.
//

import CoreGraphics

public extension BinaryInteger {
    
    /// Returns the digit at the given index. Digit of index 0 it the rightmost digit.
    /// - Parameter index: The index of the desired digit.
    /// - Parameter radix: The radix to use for the number representation.
    @inlinable func digit(at index: Int, radix: Int = 10) -> Int {
        assert(radix > 1 && radix < 21)
        return Int(self) / Int(pow(CGFloat(radix), CGFloat(index))) % Int(radix)
    }
}
