//
//  DataExtension.swift
//
//
//  Created by Pierre Tacchi on 29/09/20.
//

import Foundation

public extension Data {
    @inlinable func string(encoding: String.Encoding = .utf8) -> String? {
        String(data: self, encoding: encoding)
    }
}

public extension Data {
    func load<T>(as: T, at offset: Index = 0) -> T { object(at: offset) }
    func autoLoad<T>(at offset: Index = 0) -> T { object(at: offset) }
    
    func uint8(at offset: Index = 0) -> UInt8 { self[offset] }
    
    func uint16(at offset: Index = 0) -> UInt16 { object(at: offset) }
    func uint16BE(at offset: Index = 0) -> UInt16 { uint16(at: offset).bigEndian }
    
    func uint32(at offset: Index = 0) -> UInt32 { object(at: offset) }
    func uint32BE(at offset: Index = 0) -> UInt32 { uint32(at: offset).bigEndian }
    
    func uint64(at offset: Index = 0) -> UInt64 { object(at: offset) }
    func uint64BE(at offset: Index = 0) -> UInt64 { uint64(at: offset).bigEndian }
    
    func int8(at offset: Index = 0) -> Int8 { Int8(bitPattern: self[offset]) }
    
    func int16(at offset: Index = 0) -> Int16 { object(at: offset) }
    func int16BE(at offset: Index = 0) -> Int16 { int16(at: offset).bigEndian }
    
    func int32(at offset: Index = 0) -> Int32 { object(at: offset) }
    func int32BE(at offset: Index = 0) -> Int32 { int32(at: offset).bigEndian }
    
    func int64(at offset: Index = 0) -> Int64 { object(at: offset) }
    func int64BE(at offset: Index = 0) -> Int64 { int64(at: offset).bigEndian }
    
    func double(at offset: Index = 0) -> Double { Double(bitPattern: object(at: offset)) }
    
    func subdata(at offset: Index) -> Self { subdata(in: offset...) }
    func subdata<R: RangeExpression>(in range: R) -> Self where R.Bound == Index { subdata(in: range.relative(to: self) ) }
    
    private func object<T>() -> T { withUnsafeBytes { $0.load(as: T.self) }}
    private func object<T>(at offset: Index) -> T { offset == 0 ? object() : subdata(at: offset).object() }
    
}

public extension Data {
    init<T: FixedWidthInteger>(_ value: T) { self = Self.data(value) }
    init<T: FixedWidthInteger>(be value: T) { self = Self.data(value.bigEndian) }
    
    init<T: BinaryFloatingPoint>(_ value: T) { self = Self.data(value) }
    
    private static func data<T>(_ value: T) -> Self { withUnsafePointer(to: value) { Data(bytes: .init($0), count: MemoryLayout<T>.size) } }
}
