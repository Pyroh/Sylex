//
//  File.swift
//  Sylex
//
//  Created by Pierre Tacchi on 03/03/2025.
//

import Foundation

public final class BufferWritter {
    @usableFromInline var data: Data
    @usableFromInline var offset: Int
    @usableFromInline var writtenItemCount: Int
    @usableFromInline var writtenByteCount: Int
    
    public var currentOffset: Int { offset }
    public var lastWrittenItemCount: Int { writtenItemCount }
    public var lastWrittenByteCount: Int { writtenByteCount }
    public var bufferData: Data { data }
    
    public init() {
        self.data = Data()
        self.offset = 0
        self.writtenItemCount = 0
        self.writtenByteCount = 0
    }
    
    public init(appendingTo data: Data) {
        self.data = data
        self.offset = data.count
        self.writtenItemCount = 0
        self.writtenByteCount = 0
    }
    
    @discardableResult
    public func append(_ data: Data) -> Int {
        self.data += data
        return data.count
    }
    
    @discardableResult
    public func append<I: FixedWidthInteger>(_ value: I) -> Int {
        append(value.data)
    }
    
    @discardableResult
    public func append<I: FixedWidthInteger>(be value: I) -> Int {
        append(value.bigEndian.data)
    }
    
    @discardableResult
    public func append<I: FixedWidthInteger>(_ value: [I]) -> Int {
        append(Data(value))
    }
    
    @discardableResult
    public func append<I: FixedWidthInteger>(be value: [I]) -> Int {
        append(Data(be: value))
    }
    
    @discardableResult
    public func append<T: DataEncodable>(_ subject: T) -> Int {
        append(subject.dataRepresentation)
    }
}
