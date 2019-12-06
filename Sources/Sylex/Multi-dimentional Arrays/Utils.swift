//
//  File.swift
//  
//
//  Created by Pierre TACCHI on 06/12/2019.
//

public struct TableCoordinate: Equatable, Hashable, Codable {
    public var column: Int
    public var row: Int
    
    public init(column: Int, row: Int) {
        self.column = column
        self.row = row
    }
}

public struct TableSize: Equatable, Hashable, Codable {
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
}

extension TableCoordinate: Zeroable {
    public static var zero: TableCoordinate {
        .init(column: 0, row: 0)
    }
}

extension TableSize: Zeroable {
    public static var zero: TableSize {
        .init(square: .zero)
    }
}

