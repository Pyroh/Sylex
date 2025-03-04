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
    
    @discardableResult
    public func append<S: StringProtocol>(_ string: S,
                                          encoding: String.Encoding = .utf8,
                                          count: Int? = nil,
                                          allowLossyConversion lcFlag: Bool = false,
                                          nullTerminated ntFlag: Bool = true) -> Int {
        if string.isEmpty, !!!count {
            if ntFlag { return append(UInt8.zero) }
            else { return 0 }
        } else if let count {
            var data = Data(count: count)
            if let strData = string.data(using: encoding, allowLossyConversion: lcFlag) {
                if strData.count < count {
                    data[.init(startIndex: offset, count: strData.count)] = strData
                } else {
                    if ntFlag {
                        data[.init(startIndex: offset, count: count-)] = strData[.init(startIndex: 0, count: count-)]
                    } else {
                        data[.init(startIndex: offset, count: count)] = strData[.init(startIndex: 0, count: count-)]
                    }
                }
            }
            return append(data)
        } else {
            if let strData = string.data(using: encoding, allowLossyConversion: lcFlag) {
                return append(strData + (ntFlag ? [0x00] : []))
            } else {
                return 0
            }
        }
    }
}
