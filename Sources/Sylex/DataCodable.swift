//
//  DataCodable.swift
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

public protocol DataEncodable {
    var dataRepresentation: Data { get }
    @discardableResult func append(to bw: BufferWritter) -> Int
}

public extension DataEncodable {
    @discardableResult func append(to bw: BufferWritter) -> Int {
        let data = dataRepresentation
        bw.append(dataRepresentation)
        return data.count
    }
}

public protocol DataDecodable {
    associatedtype DecodeError: Error
    static var dataRepresentationSize: Int { get }
    
    init(from data: Data) throws
    init(from br: BufferReader) throws
}

public extension DataDecodable {
    static var dataRepresentationSize: Int { MemoryLayout<Self>.size }
    init(from br: BufferReader) throws {
        let data = br.data(count: Self.dataRepresentationSize)
        try self.init(from: data)
    }
}

public typealias DataCodable = DataEncodable&DataDecodable

extension Data: DataCodable {
    public enum DecodeError: Error { }
    
    public var dataRepresentation: Data { self }
    
    public init(from data: Data) throws {
        self.init(data)
    }
}

extension UUID: DataCodable {
    public enum DecodeError: Error {
        case dataTooShort
    }
    
    public var dataRepresentation: Data {
        withUnsafePointer(to: self.uuid) { Data(bytes: $0, count: MemoryLayout<UUID>.size) }
    }
    
    public init(from data: Data) throws {
        guard data.count >= MemoryLayout<UUID>.size
        else { throw DecodeError.dataTooShort }
        self.init(uuid: data.autoLoad())
    }
}
