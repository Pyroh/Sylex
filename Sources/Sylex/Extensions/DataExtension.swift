//
//  DataExtension.swift
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

public extension Data {
    /// Converts the `Data` instance to a `String` using the specified encoding.
    ///
    /// This method attempts to create a `String` from the `Data` instance using the given character encoding.
    /// If the data cannot be converted to a string using the specified encoding, the method returns `nil`.
    ///
    /// - Parameter encoding: The character encoding to use for the string.
    ///   Defaults to `.utf8` if not specified.
    ///
    /// - Returns: A `String` created from the `Data`, or `nil` if the conversion fails.
    ///
    /// - Note: This method is a convenience wrapper around the `String(data:encoding:)` initializer.
    ///
    /// - Example:
    ///   ```swift
    ///   let data = Data([72, 101, 108, 108, 111]) // "Hello" in ASCII
    ///   if let string = data.string() {
    ///       print(string) // Prints: Hello
    ///   }
    ///
    ///   // Using a different encoding
    ///   let utf16Data = Data([72, 0, 101, 0, 108, 0, 108, 0, 111, 0]) // "Hello" in UTF-16
    ///   if let utf16String = utf16Data.string(encoding: .utf16LittleEndian) {
    ///       print(utf16String) // Prints: Hello
    ///   }
    ///   ```
    ///
    /// - SeeAlso: `String.Encoding`
    @inlinable func string(encoding: String.Encoding = .utf8) -> String? {
        String(data: self, encoding: encoding)
    }
}

public extension Data {
    /// Loads a value of the specified type from the data at the given offset.
    ///
    /// - Parameters:
    ///   - as: The type of the value to load.
    ///   - offset: The offset in the data from which to load the value. Defaults to 0.
    /// - Returns: The loaded value of type `T`.
    @inlinable func load<T>(as: T, at offset: Index = 0) -> T { object(at: offset) }
    
    /// Automatically loads a value of the inferred type from the data at the given offset.
    ///
    /// - Parameter offset: The offset in the data from which to load the value. Defaults to 0.
    /// - Returns: The loaded value of type `T`.
    @inlinable func autoLoad<T>(at offset: Index = 0) -> T { object(at: offset) }
    
    @inlinable func subject<T: DataDecodable>(at offset: Index = 0) throws -> T {
        try .init(from: subdata(in: .init(startIndex: offset, count: T.dataRepresentationSize)))
    }
    
    /// Reads an unsigned 8-bit integer from the data at the given offset.
    ///
    /// - Parameter offset: The offset in the data from which to read. Defaults to 0.
    /// - Returns: The UInt8 value at the specified offset.
    @inlinable func uint8(at offset: Index = 0) -> UInt8 { self[offset] }
    
    /// Reads an unsigned 16-bit integer from the data at the given offset.
    ///
    /// - Parameter offset: The offset in the data from which to read. Defaults to 0.
    /// - Returns: The UInt16 value at the specified offset.
    @inlinable func uint16(at offset: Index = 0) -> UInt16 { object(at: offset) }
    
    /// Reads a big-endian unsigned 16-bit integer from the data at the given offset.
    ///
    /// - Parameter offset: The offset in the data from which to read. Defaults to 0.
    /// - Returns: The big-endian UInt16 value at the specified offset.
    @inlinable func uint16BE(at offset: Index = 0) -> UInt16 { uint16(at: offset).bigEndian }
    
    /// Reads an unsigned 32-bit integer from the data at the given offset.
    ///
    /// - Parameter offset: The offset in the data from which to read. Defaults to 0.
    /// - Returns: The UInt32 value at the specified offset.
    @inlinable func uint32(at offset: Index = 0) -> UInt32 { object(at: offset) }
    
    /// Reads a big-endian unsigned 32-bit integer from the data at the given offset.
    ///
    /// - Parameter offset: The offset in the data from which to read. Defaults to 0.
    /// - Returns: The big-endian UInt32 value at the specified offset.
    @inlinable func uint32BE(at offset: Index = 0) -> UInt32 { uint32(at: offset).bigEndian }
    
    /// Reads an unsigned 64-bit integer from the data at the given offset.
    ///
    /// - Parameter offset: The offset in the data from which to read. Defaults to 0.
    /// - Returns: The UInt64 value at the specified offset.
    @inlinable func uint64(at offset: Index = 0) -> UInt64 { object(at: offset) }
    
    /// Reads a big-endian unsigned 64-bit integer from the data at the given offset.
    ///
    /// - Parameter offset: The offset in the data from which to read. Defaults to 0.
    /// - Returns: The big-endian UInt64 value at the specified offset.
    @inlinable func uint64BE(at offset: Index = 0) -> UInt64 { uint64(at: offset).bigEndian }
    
    /// Reads a signed 8-bit integer from the data at the given offset.
    ///
    /// - Parameter offset: The offset in the data from which to read. Defaults to 0.
    /// - Returns: The Int8 value at the specified offset.
    @inlinable func int8(at offset: Index = 0) -> Int8 { Int8(bitPattern: self[offset]) }
    
    /// Reads a signed 16-bit integer from the data at the given offset.
    ///
    /// - Parameter offset: The offset in the data from which to read. Defaults to 0.
    /// - Returns: The Int16 value at the specified offset.
    @inlinable func int16(at offset: Index = 0) -> Int16 { object(at: offset) }
    
    /// Reads a big-endian signed 16-bit integer from the data at the given offset.
    ///
    /// - Parameter offset: The offset in the data from which to read. Defaults to 0.
    /// - Returns: The big-endian Int16 value at the specified offset.
    @inlinable func int16BE(at offset: Index = 0) -> Int16 { int16(at: offset).bigEndian }
    
    /// Reads a signed 32-bit integer from the data at the given offset.
    ///
    /// - Parameter offset: The offset in the data from which to read. Defaults to 0.
    /// - Returns: The Int32 value at the specified offset.
    @inlinable func int32(at offset: Index = 0) -> Int32 { object(at: offset) }
    
    /// Reads a big-endian signed 32-bit integer from the data at the given offset.
    ///
    /// - Parameter offset: The offset in the data from which to read. Defaults to 0.
    /// - Returns: The big-endian Int32 value at the specified offset.
    @inlinable func int32BE(at offset: Index = 0) -> Int32 { int32(at: offset).bigEndian }
    
    /// Reads a signed 64-bit integer from the data at the given offset.
    ///
    /// - Parameter offset: The offset in the data from which to read. Defaults to 0.
    /// - Returns: The Int64 value at the specified offset.
    @inlinable func int64(at offset: Index = 0) -> Int64 { object(at: offset) }
    
    /// Reads a big-endian signed 64-bit integer from the data at the given offset.
    ///
    /// - Parameter offset: The offset in the data from which to read. Defaults to 0.
    /// - Returns: The big-endian Int64 value at the specified offset.
    @inlinable func int64BE(at offset: Index = 0) -> Int64 { int64(at: offset).bigEndian }
    
    /// Reads a double-precision floating-point value from the data at the given offset.
    ///
    /// - Parameter offset: The offset in the data from which to read. Defaults to 0.
    /// - Returns: The Double value at the specified offset.
    @inlinable func double(at offset: Index = 0) -> Double { Double(bitPattern: object(at: offset)) }
    
    /// Loads an object of type `T` from the specified offset in the data.
    ///
    /// If the offset is 0, this method calls `object()` directly. Otherwise, it creates a subdata starting
    /// at the specified offset and calls `object()` on that subdata.
    ///
    /// - Parameter offset: The offset from which to load the object.
    /// - Returns: An object of type `T` loaded from the specified offset in the data.
    ///
    /// - Note: This method is marked as `@usableFromInline`, allowing it to be used by inlinable public methods
    ///         while keeping it internal to the module.
    @usableFromInline internal func object<T>(at offset: Index = 0) -> T {
        withUnsafeBytes { $0.loadUnaligned(fromByteOffset: offset, as: T.self) }
    }
}

public extension Data {
    @inlinable func uint8Array(at offset: Index = 0, count: Int? = nil) -> [UInt8] {
        array(at: offset, count: count)
    }
    @inlinable func int8Array(at offset: Index = 0, count: Int? = nil) -> [Int8] {
        array(at: offset, count: count)
    }
    
    @inlinable func uint16Array(at offset: Index = 0, count: Int? = nil) -> [UInt16] {
        array(at: offset, count: count)
    }
    @inlinable func int16Array(at offset: Index = 0, count: Int? = nil) -> [Int16] {
        array(at: offset, count: count)
    }
    
    @inlinable func uint32Array(at offset: Index = 0, count: Int? = nil) -> [UInt32] {
        array(at: offset, count: count)
    }
    @inlinable func int32Array(at offset: Index = 0, count: Int? = nil) -> [Int32] {
        array(at: offset, count: count)
    }
    
    @inlinable func uint64Array(at offset: Index = 0, count: Int? = nil) -> [UInt64] {
        array(at: offset, count: count)
    }
    @inlinable func int64Array(at offset: Index = 0, count: Int? = nil) -> [Int64] {
        array(at: offset, count: count)
    }
    
    @inlinable func uint16BEArray(at offset: Index = 0, count: Int? = nil) -> [UInt16] {
        array(at: offset, count: count).map(\UInt16.bigEndian)
    }
    @inlinable func int16BEArray(at offset: Index = 0, count: Int? = nil) -> [Int16] {
        array(at: offset, count: count).map(\Int16.bigEndian)
    }
    
    @inlinable func uint32BEArray(at offset: Index = 0, count: Int? = nil) -> [UInt32] {
        array(at: offset, count: count).map(\UInt32.bigEndian)
    }
    @inlinable func int32BEArray(at offset: Index = 0, count: Int? = nil) -> [Int32] {
        array(at: offset, count: count).map(\Int32.bigEndian)
    }
    
    @inlinable func uint64BEArray(at offset: Index = 0, count: Int? = nil) -> [UInt64] {
        array(at: offset, count: count).map(\UInt64.bigEndian)
    }
    @inlinable func int64BEArray(at offset: Index = 0, count: Int? = nil) -> [Int64] {
        array(at: offset, count: count).map(\Int64.bigEndian)
    }
    
    @usableFromInline internal func array<T>(at offset: Index = 0, count: Int? = nil) -> [T] {
        if let count {
            withUnsafeBytes { [T]($0.suffix(from: offset).assumingMemoryBound(to: T.self).prefix(upTo: count)) }
        } else {
            withUnsafeBytes { [T]($0.suffix(from: offset).assumingMemoryBound(to: T.self)) }
        }
    }
}

public extension Data {
    /// Initializes a new `Data` instance with the bytes of the given fixed-width integer value.
    ///
    /// - Parameter value: The integer value to convert to `Data`.
    ///
    /// - Example:
    ///   ```swift
    ///   let intValue: Int32 = 42
    ///   let data = Data(intValue)
    ///   ```
    init<T: FixedWidthInteger>(_ value: T) { self = Self.data(value) }
    
    /// Initializes a new `Data` instance with the bytes of the given fixed-width integer value in big-endian order.
    ///
    /// - Parameter value: The integer value to convert to `Data` in big-endian order.
    ///
    /// - Example:
    ///   ```swift
    ///   let intValue: Int32 = 42
    ///   let bigEndianData = Data(be: intValue)
    ///   ```
    init<T: FixedWidthInteger>(be value: T) { self = Self.data(value.bigEndian) }
    
    /// Initializes a new `Data` instance with the bytes of the given binary floating-point value.
    ///
    /// - Parameter value: The floating-point value to convert to `Data`.
    ///
    /// - Example:
    ///   ```swift
    ///   let doubleValue: Double = 3.14159
    ///   let data = Data(doubleValue)
    ///   ```
    init<T: BinaryFloatingPoint>(_ value: T) { self = Self.data(value) }
    
    @_disfavoredOverload
    init<T: DataEncodable>(_ value: T) { self = value.dataRepresentation }
    
    @_disfavoredOverload
    init<T>(_ value: T) { self = .data(value) }
    
    /// Creates a `Data` instance from the bytes of the given value.
    ///
    /// This method uses `withUnsafePointer` to safely access the bytes of the value
    /// and create a `Data` instance from them.
    ///
    /// - Parameter value: The value to convert to `Data`.
    /// - Returns: A `Data` instance containing the bytes of the value.
    ///
    /// - Note: This method is marked as `internal` and is used by the public initializers.
    internal static func data<T>(_ value: T) -> Self {
        withUnsafePointer(to: value) { Data(bytes: .init($0), count: MemoryLayout<T>.size) }
    }
}

public extension Data {
    @_disfavoredOverload
    init<T: FixedWidthInteger>(_ array: [T]) {
        self = array.withUnsafeBufferPointer(Data.init(buffer:))
    }
    
    init<T: FixedWidthInteger>(be array: [T]) {
        self = array.lazy.map(\.bigEndian).withUnsafeBufferPointer(Data.init(buffer:))
    }
}
