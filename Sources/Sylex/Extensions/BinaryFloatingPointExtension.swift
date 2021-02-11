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
    var approximated: Self { (self * 1_000_000).rounded() / 1_000_000 }
    mutating func approximate() { self = approximated }
}

public extension Double {
    @inlinable static var phi: Double { .init(bitPattern: 4609965796441453736) }
}

public extension Float {
    @inlinable static var phi: Float { .init(bitPattern: 1070537661) }
}

public extension CGFloat {
    @inlinable static var phi: NativeType { NativeType.phi }
}
