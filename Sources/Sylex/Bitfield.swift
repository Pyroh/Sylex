//
//  Bitfield.swift
//  Sylex
//
//  MIT License
//
//  Copyright (c) 2025 Pierre Tacchi
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

import Foundation
import Sylex

public protocol Bitfield: Sendable, Equatable, Hashable, Zeroable {
    associatedtype Storage: UnsignedInteger&FixedWidthInteger
    
    var storage: Storage { get set }
    
    init(_ storage: Storage)
    
    mutating func clear()
    mutating func reverse()
    func reversed() -> Self
}

extension Bitfield {
    public static var zero: Self { .init() }
}

extension Bitfield {
    public static func ==(lhs: Self, rhs: Self) -> Bool {
        lhs.storage == rhs.storage
    }
    
    public static func ==(lhs: Self, rhs: Storage) -> Bool {
        lhs.storage == rhs
    }
    
    public static func ==(lhs: Storage, rhs: Self) -> Bool {
        lhs == rhs.storage
    }
}

public extension Bitfield {
    init() { self.init(.zero) }
    
    mutating func clear() {
        storage = .zero
    }
    
    mutating func reverse() {
        storage = ~storage
    }
    
    func reversed() -> Self {
        .init(~storage)
    }
}

public extension Bitfield {
    @inline(__always)
    private func validateIndex(_ index: Int) -> Bool {
        index >= 0 && index < Storage.bitWidth
    }
    
    subscript(_ index: Int) -> Bool {
        get {
            precondition(validateIndex(index), "Bit index out of bounds")
            return storage >> index & 1 == 1
        }
        set {
            precondition(validateIndex(index), "Bit index out of bounds")
            if newValue { storage |= (1 << index) }
            else { storage &= ~(1 << index) }
        }
    }
}

public extension Bitfield {
    mutating func toggle(_ index: Int) {
        precondition(validateIndex(index), "Bit index out of bounds")
        if storage >> index & 1 == 1 {
            storage &= ~(1 << index)
        } else {
            storage |= (1 << index)
        }
    }
}

public extension Bitfield {
    @inline(__always)
    private func validateRange<I: FixedWidthInteger>(_ range: Range<I>) -> Bool {
        range.lowerBound >= 0 && Int(range.upperBound) <= Storage.bitWidth
    }
    
    private func get<I: FixedWidthInteger>(_ range: Range<I>) -> Storage {
        precondition(range.count > 0, "Empty range")
        precondition(validateRange(range), "Bit range out of bounds")
        let (len, pos) = (range.count, range.lowerBound)
        let mask: Storage = (1 << len - 1) << pos
        return (storage & mask) >> pos
    }
    
    private mutating func set<I: FixedWidthInteger>(_ range: Range<I>, _ newValue: Storage) {
        precondition(range.count > 0, "Empty range")
        precondition(validateRange(range), "Bit range out of bounds")
        let (len, pos) = (range.count, range.lowerBound)
        let mask: Storage = (1 << len - 1) << pos
        let value = (newValue << pos) & mask
        storage = storage & ~mask | value
    }
    
    subscript<I: FixedWidthInteger>(_ range: Range<I>) -> Storage {
        get { get(range) }
        set { set(range, newValue) }
    }
    
    subscript<I: FixedWidthInteger>(_ range: ClosedRange<I>) -> Storage {
        get { get(.init(range)) }
        set { set(.init(range), newValue) }
    }
    
    subscript<I: FixedWidthInteger>(_ range: PartialRangeUpTo<I>) -> Storage {
        get { get(.init(uncheckedBounds: (0, range.upperBound))) }
        set { set(.init(uncheckedBounds: (0, range.upperBound)), newValue) }
    }
    
    subscript<I: FixedWidthInteger>(_ range: PartialRangeFrom<I>) -> Storage {
        get { get(.init(uncheckedBounds: (range.lowerBound, I(Storage.bitWidth)))) }
        set { set(.init(uncheckedBounds: (range.lowerBound, I(Storage.bitWidth))), newValue) }
    }
    
    subscript<I: FixedWidthInteger>(_ range: PartialRangeThrough<I>) -> Storage {
        get { get(.init(0...range.upperBound)) }
        set { set(.init(0...range.upperBound), newValue) }
    }
}

public struct Bitfield8: Bitfield {
    public var storage: UInt8
    
    public init(_ storage: UInt8) { self.storage = storage }
}

public struct Bitfield16: Bitfield {
    public var storage: UInt16
    
    public init(_ storage: UInt16) { self.storage = storage }
}

public struct Bitfield32: Bitfield {
    public var storage: UInt32
    
    public init(_ storage: UInt32) { self.storage = storage }
}

public struct Bitfield64: Bitfield {
    public var storage: UInt64
    
    public init(_ storage: UInt64) { self.storage = storage }
}
