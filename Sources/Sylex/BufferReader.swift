//
//  BufferReader.swift
//  Sylex
//
//  MIT License
//
//  Copyright (c) 2024 Pierre Tacchi
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

public final class BufferReader {
    public let data: Data
    public let count: Int
    
    @usableFromInline var offset: Data.Index
    @usableFromInline var readItemCount: Int
    @usableFromInline var readByteCount: Int
    
    public var currentOffset: Data.Index { offset }
    public var remainingBytes: Int { count - offset }
    public var isFinished: Bool { offset >= count }
    public var lastReadItemCount: Int { readItemCount }
    public var lastReadByteCount: Int { readByteCount }
    
    public init(_ data: Data) {
        self.data = data
        self.count = data.count
        self.offset = 0
        self.readItemCount = 0
        self.readByteCount = 0
    }
    
    @inlinable public func reset() {
        offset = 0
    }
    
    @inlinable public func advance(by offset: Data.Index) {
        checkAdvancePrecondition(offset)
        self.offset += offset
    }
    
    @usableFromInline func checkAdvancePrecondition(_ offset: Data.Index) {
        precondition((0...count).contains(self.offset + offset), "Offset \(self.offset + offset) out of data bounds.")
    }
    
    /// Reads an unsigned 8-bit integer from the data at the given offset.
    ///
    /// - Returns: The UInt8 value at the specified offset.
    @inlinable public func uint8() -> UInt8 {
        checkAdvancePrecondition(MemoryLayout<UInt8>.size)
        defer {
            offset += MemoryLayout<UInt8>.size
            readItemCount = 1
            readByteCount = MemoryLayout<UInt8>.size
        }
        return data[offset]
    }
    
    /// Reads an unsigned 16-bit integer from the data at the given offset.
    ///
    /// - Returns: The UInt16 value at the specified offset.
    @inlinable public func uint16() -> UInt16 {
        checkAdvancePrecondition(MemoryLayout<UInt16>.size)
        defer {
            offset += MemoryLayout<UInt16>.size
            readItemCount = 1
            readByteCount = MemoryLayout<UInt16>.size
        }
        return data.object(at: offset)
    }
    
    /// Reads a big-endian unsigned 16-bit integer from the data at the given offset.
    ///
    /// - Returns: The big-endian UInt16 value at the specified offset.
    @inlinable public func uint16BE() -> UInt16 { uint16().bigEndian }
    
    /// Reads an unsigned 32-bit integer from the data at the given offset.
    ///
    /// - Returns: The UInt32 value at the specified offset.
    @inlinable public func uint32() -> UInt32 {
        checkAdvancePrecondition(MemoryLayout<UInt32>.size)
        defer {
            offset += MemoryLayout<UInt32>.size
            readItemCount = 1
            readByteCount = MemoryLayout<UInt32>.size
        }
        return data.object(at: offset)
    }
    
    /// Reads a big-endian unsigned 32-bit integer from the data at the given offset.
    ///
    /// - Returns: The big-endian UInt32 value at the specified offset.
    @inlinable public func uint32BE() -> UInt32 { uint32().bigEndian }
    
    /// Reads an unsigned 64-bit integer from the data at the given offset.
    ///
    /// - Returns: The UInt64 value at the specified offset.
    @inlinable public func uint64() -> UInt64 {
        checkAdvancePrecondition(MemoryLayout<UInt64>.size)
        defer {
            offset += MemoryLayout<UInt64>.size
            readItemCount = 1
            readByteCount = MemoryLayout<UInt64>.size
        }
        return data.object(at: offset)
    }
    
    /// Reads a big-endian unsigned 64-bit integer from the data at the given offset.
    ///
    /// - Returns: The big-endian UInt64 value at the specified offset.
    @inlinable public func uint64BE() -> UInt64 { data.uint64(at: offset).bigEndian }
    
    /// Reads a signed 8-bit integer from the data at the given offset.
    ///
    /// - Returns: The Int8 value at the specified offset.
    @inlinable public func int8() -> Int8 {
        checkAdvancePrecondition(MemoryLayout<Int8>.size)
        defer {
            offset += MemoryLayout<Int8>.size
            readItemCount = 1
            readByteCount = MemoryLayout<Int8>.size
        }
        return Int8(bitPattern: data[offset])
    }
    
    /// Reads a signed 16-bit integer from the data at the given offset.
    ///
    /// - Returns: The Int16 value at the specified offset.
    @inlinable public func int16() -> Int16 {
        checkAdvancePrecondition(MemoryLayout<Int16>.size)
        defer {
            offset += MemoryLayout<Int16>.size
            readItemCount = 1
            readByteCount = MemoryLayout<Int16>.size
        }
        return data.object(at: offset)
    }
    
    /// Reads a big-endian signed 16-bit integer from the data at the given offset.
    ///
    /// - Returns: The big-endian Int16 value at the specified offset.
    @inlinable public func int16BE() -> Int16 { int16().bigEndian }
    
    /// Reads a signed 32-bit integer from the data at the given offset.
    ///
    /// - Returns: The Int32 value at the specified offset.
    @inlinable public func int32() -> Int32 {
        checkAdvancePrecondition(MemoryLayout<Int32>.size)
        defer {
            offset += MemoryLayout<Int32>.size
            readItemCount = 1
            readByteCount = MemoryLayout<Int32>.size
        }
        return data.object(at: offset)
    }
    
    /// Reads a big-endian signed 32-bit integer from the data at the given offset.
    ///
    /// - Returns: The big-endian Int32 value at the specified offset.
    @inlinable public func int32BE() -> Int32 { int32().bigEndian }
    
    /// Reads a signed 64-bit integer from the data at the given offset.
    ///
    /// - Returns: The Int64 value at the specified offset.
    @inlinable public func int64() -> Int64 {
        checkAdvancePrecondition(MemoryLayout<Int64>.size)
        defer {
            offset += MemoryLayout<Int64>.size
            readItemCount = 1
            readByteCount = MemoryLayout<Int64>.size
        }
        return data.object(at: offset)
    }
    
    /// Reads a big-endian signed 64-bit integer from the data at the given offset.
    ///
    /// - Returns: The big-endian Int64 value at the specified offset.
    @inlinable public func int64BE() -> Int64 { int64().bigEndian }
}

extension BufferReader {
    @usableFromInline func checkAtleastOnePrecondition(_ size: Int) {
        precondition((offset + size) <= count, "Not enough remaining bytes to read such an array.")
    }
    
    @usableFromInline func checkItemAvailablePrecondition(_ count: Int, size: Int) {
        precondition((offset + count * size) <= self.count, "Not enough remaining bytes to read an array of \(count) item(\(count > 1 ? "s" : "").")
    }
 
    @inlinable public func uint8Array(count: Int? = nil) -> [UInt8] {
        if let count { checkItemAvailablePrecondition(count, size: MemoryLayout<UInt8>.size) }
        else { checkAtleastOnePrecondition(MemoryLayout<UInt8>.size) }
        
        let array = data.uint8Array(at: offset, count: count)
        readItemCount = array.count
        readByteCount = readItemCount * MemoryLayout<UInt8>.size
        offset += readByteCount
        
        return array
    }
    
    @inlinable public func int8Array(count: Int? = nil) -> [Int8] {
        if let count { checkItemAvailablePrecondition(count, size: MemoryLayout<Int8>.size) }
        else { checkAtleastOnePrecondition(MemoryLayout<Int8>.size) }
        
        let array = data.int8Array(at: offset, count: count)
        readItemCount = array.count
        readByteCount = readItemCount * MemoryLayout<Int8>.size
        offset += readByteCount
        
        return array
    }
 
    @inlinable public func uint16Array(count: Int? = nil) -> [UInt16] {
        if let count { checkItemAvailablePrecondition(count, size: MemoryLayout<UInt16>.size) }
        else { checkAtleastOnePrecondition(MemoryLayout<UInt16>.size) }
        
        let array = data.uint16Array(at: offset, count: count)
        readItemCount = array.count
        readByteCount = readItemCount * MemoryLayout<UInt16>.size
        offset += readByteCount
        
        return array
    }
    
    @inlinable public func int16Array(count: Int? = nil) -> [Int16] {
        if let count { checkItemAvailablePrecondition(count, size: MemoryLayout<Int16>.size) }
        else { checkAtleastOnePrecondition(MemoryLayout<Int16>.size) }
        
        let array = data.int16Array(at: offset, count: count)
        readItemCount = array.count
        readByteCount = readItemCount * MemoryLayout<Int16>.size
        offset += readByteCount
        
        return array
    }
 
    @inlinable public func uint32Array(count: Int? = nil) -> [UInt32] {
        if let count { checkItemAvailablePrecondition(count, size: MemoryLayout<UInt32>.size) }
        else { checkAtleastOnePrecondition(MemoryLayout<UInt32>.size) }
        
        let array = data.uint32Array(at: offset, count: count)
        readItemCount = array.count
        readByteCount = readItemCount * MemoryLayout<UInt32>.size
        offset += readByteCount
        
        return array
    }
    
    @inlinable public func int32Array(count: Int? = nil) -> [Int32] {
        if let count { checkItemAvailablePrecondition(count, size: MemoryLayout<Int32>.size) }
        else { checkAtleastOnePrecondition(MemoryLayout<Int32>.size) }
        
        let array = data.int32Array(at: offset, count: count)
        readItemCount = array.count
        readByteCount = readItemCount * MemoryLayout<Int32>.size
        offset += readByteCount
        
        return array
    }
 
    @inlinable public func uint64Array(count: Int? = nil) -> [UInt64] {
        if let count { checkItemAvailablePrecondition(count, size: MemoryLayout<UInt64>.size) }
        else { checkAtleastOnePrecondition(MemoryLayout<UInt64>.size) }
        
        let array = data.uint64Array(at: offset, count: count)
        readItemCount = array.count
        readByteCount = readItemCount * MemoryLayout<UInt64>.size
        offset += readByteCount
        
        return array
    }
    
    @inlinable public func int64Array(count: Int? = nil) -> [Int64] {
        if let count { checkItemAvailablePrecondition(count, size: MemoryLayout<Int64>.size) }
        else { checkAtleastOnePrecondition(MemoryLayout<Int64>.size) }
        
        let array = data.int64Array(at: offset, count: count)
        readItemCount = array.count
        readByteCount = readItemCount * MemoryLayout<Int64>.size
        offset += readByteCount
        
        return array
    }
    
    @inlinable func uint16BEArray(count: Int? = nil) -> [UInt16] {
        uint16Array(count: count).map(\.bigEndian)
    }
    
    @inlinable func int16BEArray(count: Int? = nil) -> [Int16] {
        int16Array(count: count).map(\.bigEndian)
    }
    
    @inlinable func uint32BEArray(count: Int? = nil) -> [UInt32] {
        uint32Array(count: count).map(\.bigEndian)
    }
    
    @inlinable func int16BEArray(count: Int? = nil) -> [Int32] {
        int32Array(count: count).map(\.bigEndian)
    }
    
    @inlinable func uint64BEArray(count: Int? = nil) -> [UInt64] {
        uint64Array(count: count).map(\.bigEndian)
    }
    
    @inlinable func int16BEArray(count: Int? = nil) -> [Int64] {
        int64Array(count: count).map(\.bigEndian)
    }
}
