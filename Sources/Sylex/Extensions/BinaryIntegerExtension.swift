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

public extension BinaryInteger {
    @inlinable mutating func cycle(in range: Range<Self>) {
        self = Sylex.cycle(self, in: range)
    }
    
    @inlinable func cycled(in range: Range<Self>) -> Self {
        Sylex.cycle(self, in: range)
    }
    
//    @inlinable mutating func cycle(in range: ClosedRange<Self>) {
//        self = Sylex.cycle(self, in: range)
//    }
//    
//    @inlinable func cycled(in range: ClosedRange<Self>) -> Self {
//        Sylex.cycle(self, in: range)
//    }
}

//@inlinable public func cycle<T: BinaryInteger>(_ value: T, in range: ClosedRange<T>) -> T {
//    let proxyValue = Double(value)
//    let proxyLowerBound = Double(range.lowerBound)
//    let proxyUpperBound = Double(range.upperBound)
//    let proxyRange = ClosedRange(uncheckedBounds: (lower: proxyLowerBound, upper: proxyUpperBound))
//
//    return T(cycle(proxyValue, in: proxyRange))
//}

@inlinable public func cycle<T: BinaryInteger>(_ value: T, in range: Range<T>) -> T {
    let proxyValue = Double(value)
    let proxyLowerBound = Double(range.lowerBound)
    let proxyUpperBound = Double(range.upperBound)
    let proxyRange = Range(uncheckedBounds: (lower: proxyLowerBound, upper: proxyUpperBound))
    
    return T(cycle(proxyValue, in: proxyRange))
}
