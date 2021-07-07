//
//  File.swift
//  
//
//  Created by Pierre Tacchi on 06/11/20.
//

import Foundation
import SmoothOperators

public extension BinaryFloatingPoint {
    func rounded(digits: Int) -> Self {
        guard digits >= 0 else {
            fatalError("Floating point numbers can't be rounded to a negative number of digits. Dumbass...")
        }
        let f: Self = 10 ** digits
        return (self * f).rounded() / f
    }
    
    mutating func round(digits: Int) {
        self = rounded(digits: digits)
    }
}

public extension BinaryFloatingPoint {
    @inlinable var approximated: Self { (self * 1_000_000).rounded() / 1_000_000 }
    @inlinable mutating func approximate() { self = approximated }
}

public extension Double {
    @inlinable static var phi: Double { .init(bitPattern: 4609965796441453736) }
}

public extension Float {
    @inlinable static var phi: Float { .init(bitPattern: 1070537661) }
}

public extension CGFloat {
    @inlinable static var phi: CGFloat { .init(NativeType.phi) }
}

public extension BinaryFloatingPoint {
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

//@inlinable public func cycle<T: BinaryFloatingPoint>(_ value: T, in range: ClosedRange<T>) -> T {
//    let start = range.lowerBound
//    let width = range.upperBound - start + 1
//    let offset = value - range.lowerBound
//    
//    return (offset - (floor(offset / width) * width)) + start
//}

@inlinable public func cycle<T: BinaryFloatingPoint>(_ value: T, in range: Range<T>) -> T {
    let start = range.lowerBound
    let width = range.upperBound - start
    let offset = value - range.lowerBound
    
    return (offset - (floor(offset / width) * width)) + start
}




