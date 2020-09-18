//
//  File.swift
//  
//
//  Created by Pierre TACCHI on 06/12/2019.
//



public struct MatrixCoordinate: Equatable, Hashable, Codable, Zeroable {
    public var column: Int
    public var row: Int
    
    public init(column: Int, row: Int) {
        self.column = column
        self.row = row
    }
    
    init(_ pair: (row: Int, column: Int)) {
        self.column = pair.column
        self.row = pair.row
    }
    
    public static var zero: MatrixCoordinate { .init(column: .zero, row: .zero) }
}

public struct MatrixSize: Equatable, Hashable, Codable, Zeroable {
    public var width: Int
    public var height: Int
    
    public var count: Int { width * height }
    
    public init(width: Int, height: Int) {
        self.width = width
        self.height = height
    }
    
    public init(square amount: Int) {
        self.width = amount
        self.height = amount
    }
    
    public static var zero: MatrixSize { .init(square: .zero) }
}


