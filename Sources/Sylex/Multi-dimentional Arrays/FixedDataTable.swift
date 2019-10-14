//
//  FixedDataTable.swift
//  Sylex
//
//  Created by Pierre TACCHI on 14/10/2019.
//

import Foundation

public struct FixedDataTable<Element> {
    struct FixedDataTableColumnIterator<Element>: IteratorProtocol {
        typealias Buffer = FixedBuffer<Element>
        
        private unowned var buffer: Buffer
        private let columnCount: Int
        private var currentIndex: Int
        private var endIndex: Int
        
        init(atIndex i: Int, withBuffer buffer: Buffer, columnCount: Int) {
            assert(i < columnCount, "Column index can't exceed column count.")
            assert(columnCount > 0, "Column count must be greater than or equal to 1.")
            
            self.buffer = buffer
            self.columnCount = columnCount
            self.currentIndex = i
            self.endIndex = buffer.withUnsafeMutablePointerToHeader { $0.pointee }
        }
        
        mutating func next() -> Element? {
            guard self.currentIndex < self.endIndex else { return nil }
            defer { self.currentIndex += self.columnCount }
            return self.buffer.withUnsafeMutablePointerToElements { $0[currentIndex] }
        }
    }
    
    private var storage: FixedBuffer<Element>
    
    public let columnCount: Int
    public let rowCount: Int
    public let count: Int
    
    public var rows:[[Element]] {
        (0..<self.rowCount).lazy.map { self.linearIndex(forRow: $0, column: 0) }.map { self.storage.contiguousArray(fromIndex: $0, count: self.columnCount) }
    }
    
    public var columns: [[Element]] {
        (0..<self.columnCount).lazy.map { index in AnySequence<Element>.init({ FixedDataTableColumnIterator(atIndex: index, withBuffer: self.storage, columnCount: self.columnCount) }) }.map([Element].init)
    }
    
    public init(rows: Int, columns: Int) {
        assert(columns > 0, "Coloumn count must be greater than or equal to 1.")
        assert(rows > 0, "Row count must be greater than or equal to 1.")
        
        self.columnCount = columns
        self.rowCount = rows
        self.count = columns * rows
        
        self.storage = FixedBuffer<Element>.create(withCapacity: self.count)
    }
    
    public init(fromMultiDimensionalArray array: [[Element]]) {
        assert(!array.isEmpty, "Can not initialize an empty table.")
        let columnsCount = Set(array.lazy.map { $0.count })
        assert(columnsCount.count == 1, "Each subarray must hold the same number of items.")
        assert(columnsCount.first! > 0, "Each subarray must hold at least one element.")
        let rows = array.count
        let buffer = array.reduce(into: [Element]()) { (acc, element) in acc.append(contentsOf: element) }
        
        self = .init(rows: rows, columns: columnsCount.first!, buffer: buffer)
    }
    
    internal init(rows: Int, columns: Int, buffer: [Element]) {
        assert(columns > 0, "Coloumn count must be greater than or equal to 1.")
        assert(rows > 0, "Row count must be greater than or equal to 1.")
        assert(rows * columns == buffer.count, "The buffer must hold the exact number of items.")
        
        self.columnCount = columns
        self.rowCount = rows
        self.count = columns * rows
        
        self.storage = .create(fromArray: buffer)
    }
    
    public subscript(row: Int, col: Int) -> Element {
        get {
            assert(row < self.rowCount, "Row index out of bounds.")
            assert(col < self.rowCount, "Column index out of bounds.")
            return self.storage[self.linearIndex(forRow: row, column: col)]
        }
        mutating set {
            assert(row < self.rowCount, "Row index out of bounds.")
            assert(col < self.rowCount, "Column index out of bounds.")
            self.storage[self.linearIndex(forRow: row, column: col)] = newValue
        }
    }
    
    private func linearIndex(forRow row: Int, column: Int) -> Int {
        row * self.columnCount + column
    }
    
    private mutating func ensureUniqueness() {
        if !isKnownUniquelyReferenced(&self.storage) {
            self.storage = self.storage.clone()
        }
    }
}

public extension FixedDataTable where Element: Zeroable {
    init(rows: Int, columns: Int) {
        assert(columns > 0, "Coloumn count must be greater than or equal to 1.")
        assert(rows > 0, "Row count must be greater than or equal to 1.")

        self.columnCount = columns
        self.rowCount = rows
        self.count = columns * rows

        self.storage = FixedBuffer<Element>.create(withCapacity: self.count)
    }
}

public extension FixedDataTable where Element: ExpressibleByNilLiteral {
    init(rows: Int, columns: Int) {
        assert(columns > 0, "Coloumn count must be greater than or equal to 1.")
        assert(rows > 0, "Row count must be greater than or equal to 1.")

        self.columnCount = columns
        self.rowCount = rows
        self.count = columns * rows

        self.storage = FixedBuffer<Element>.create(withCapacity: self.count)
    }
}

public extension FixedDataTable {
    private var sequenceStorage: AnySequence<Element> {
        AnySequence<Element>({ () -> AnyIterator<Element> in
            var index = 0
            return AnyIterator<Element> {
                return index < self.count ? self.storage[index++] : nil
            }
        })
    }
    
    func map<T>(_ transform: (Element) throws -> T) rethrows -> FixedDataTable<T> {
        FixedDataTable<T>(rows: self.rowCount, columns: self.columnCount, buffer: try self.sequenceStorage.map(transform))
    }
    
    func forEach(_ body: (Element) throws -> Void) rethrows {
        try self.forEach(body)
    }
}
