//
//  File.swift
//  
//
//  Created by Pierre TACCHI on 06/12/2019.
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


