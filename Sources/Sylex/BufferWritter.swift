//
//  BufferWritter.swift
//  Sylex
//
//  MIT License
//
//  Copyright (c) 2026 Pierre Tacchi
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

public final class BufferWritter {
    @usableFromInline var data: Data
    
    public var currentOffset: Int { data.count }
    public var bufferData: Data { Data(data[0..<currentOffset]) }
    
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
