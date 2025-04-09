//
//  File.swift
//  Sylex
//
//  Created by Pierre Tacchi on 03/03/2025.
//

import Foundation

public final class BufferWritter {
    @usableFromInline var data: Data
    
    public var currentOffset: Int { data.count }
    public var bufferData: Data { data }
    
    public init() {
        self.data = Data()
    }
    
    public init(appendingTo data: Data) {
        self.data = data
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
    public func append<I: FixedWidthInteger>(_ array: [I]) -> Int {
        append(Data(array))
    }
    
    @discardableResult
    public func append<I: FixedWidthInteger>(be array: [I]) -> Int {
        append(Data(be: array))
    }
    
    @discardableResult
    public func append<T: DataEncodable>(_ subject: T) -> Int {
        subject.append(to: self)
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
                    data[.init(startIndex: 0, count: strData.count)] = strData
                } else {
                    if ntFlag {
                        data[.init(startIndex: 0, count: count-)] = strData[.init(startIndex: 0, count: count-)]
                    } else {
                        data[.init(startIndex: 0, count: count)] = strData[.init(startIndex: 0, count: count-)]
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
