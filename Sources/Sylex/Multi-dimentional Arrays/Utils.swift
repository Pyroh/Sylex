//
//  Utils.swift
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

import ZeroableProtocol

@frozen public struct MatrixCoordinate: Equatable, Hashable, Codable, Zeroable {
    public var column: Int
    public var row: Int
    
    @inlinable public init(column: Int, row: Int) {
        self.column = column
        self.row = row
    }
    
    @usableFromInline init(_ pair: (row: Int, column: Int)) {
        self.column = pair.column
        self.row = pair.row
    }
    
    @inlinable public static var zero: MatrixCoordinate { .init(column: .zero, row: .zero) }
}

@frozen public struct MatrixSize: Equatable, Hashable, Codable, Zeroable {
    public var width: Int
    public var height: Int
    
    @inlinable public var count: Int { width * height }
    
    @inlinable public init(width: Int, height: Int) {
        self.width = width
        self.height = height
    }
    
    @inlinable public init(square amount: Int) {
        self.width = amount
        self.height = amount
    }
    
    @inlinable public static var zero: MatrixSize { .init(square: .zero) }
}


