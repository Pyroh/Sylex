//
//  FixedDataTable.swift
//  Sylex
//
//  Created by Pierre TACCHI on 14/10/2019.
//

public struct FixedDataTable<Element> {
    public enum Dimension {
        case row(Int)
        case col(Int)
    }
    private struct FixedDataTableColumnIterator<Element>: IteratorProtocol {
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
        
        let buffer = [Element](array.joined())
        
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
            return self.storage[self.linearizedIndex(forRow: row, column: col)]
        }
        mutating set {
            assert(row < self.rowCount, "Row index out of bounds.")
            assert(col < self.rowCount, "Column index out of bounds.")
            self.storage[self.linearizedIndex(forRow: row, column: col)] = newValue
        }
    }
    
    private func linearizedIndex(forRow row: Int, column: Int) -> Int {
        row * self.columnCount + column
    }
    
    private func delinearizedIndex(_ index: Int) -> (row: Int, column: Int) {
        let row = index / self.columnCount
        let column = index % self.columnCount

        return (row, column)
    }
    
    private mutating func ensureUniqueness() {
        if !isKnownUniquelyReferenced(&self.storage) {
            self.storage = self.storage.clone()
        }
    }
}

// MARK: - Zeroable specific intializer
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

// MARK: - ExpressibleByNilLiteral specific intializer
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

// MARK: - Elements boundaries
public extension FixedDataTable where Element: Zeroable&Comparable {
    func min() -> Element {
        self.rows.compactMap { $0.min() }.min() ?? .zero
    }
    
    func max() -> Element {
        self.rows.compactMap { $0.max() }.max() ?? .zero
    }
}

// MARK: - Access rows and columns
public extension FixedDataTable {
    var rows:[[Element]] {
        (0..<self.rowCount).lazy.map { self.linearizedIndex(forRow: $0, column: 0) }.map { self.storage.contiguousArray(fromIndex: $0, count: self.columnCount) }
    }
    
    var columns: [[Element]] {
        (0..<self.columnCount).lazy.map { index in AnySequence<Element>({ FixedDataTableColumnIterator(atIndex: index, withBuffer: self.storage, columnCount: self.columnCount) }) }.map([Element].init)
    }
    
    subscript(dimension: Dimension) -> [Element] {
        get {
            switch dimension {
            case .row(let row):
                assert(row < self.rowCount, "Row index \(row) out of range.")
                return self.row(at: row)
            case .col(let col):
                assert(col < self.columnCount, "Row index \(col) out of range.")
                return self.column(at: col)
            }
        }
        
        mutating set {
            switch dimension {
            case .row(let row):
                assert(row < self.rowCount, "Row index \(row) out of range.")
                self.ensureUniqueness()
                self.setRow(newValue, at: row)
            case .col(let col):
                assert(col < self.columnCount, "Row index \(col) out of range.")
                self.ensureUniqueness()
                self.setColumn(newValue, at: col)
            }
        }
    }
    
    private func column(at index: Int) -> [Element] {
        [Element](AnySequence<Element>({ FixedDataTableColumnIterator(atIndex: index, withBuffer: self.storage, columnCount: self.columnCount) }))
    }
    
    private func row(at index: Int) -> [Element] {
        self.storage.contiguousArray(fromIndex: self.linearizedIndex(forRow: index, column: 0), count: self.columnCount)
    }
}

// MARK: - Monadics
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
        try self.sequenceStorage.forEach(body)
    }
    
    func enumerate(_ body: ((row: Int, column: Int), Element) throws -> Void) rethrows {
        try self.sequenceStorage.enumerated().forEach { (offset: Int, element: Element) in
            try body(self.delinearizedIndex(offset), element)
        }
    }
}

// MARK: - Mutate rows and columns
private extension FixedDataTable {
    private func setRow(_ array: [Element], at index: Int) {
        if array.count > self.columnCount {
            self.storage.copyElements(from: [Element](array[0..<self.columnCount]), at: self.linearizedIndex(forRow: index, column: 0))
        } else {
            self.storage.copyElements(from: array, at: self.linearizedIndex(forRow: index, column: 0))
        }
    }
    
    private func setColumn(_ array: [Element], at index: Int) {
        guard array.count > 0 else { return }
        let workArray = array.count <= self.rowCount ? array : [Element](array[0..<self.columnCount])
        workArray.lazy.enumerated().forEach { (offset, element) in
            self.storage[self.linearizedIndex(forRow: offset, column: index)] = element
        }
    }
}

// MARK: - Mutations: Zeroable specifics
public extension FixedDataTable where Element: Zeroable {
    mutating func moveRow(from srcIndex: Int, to dstIndex: Int) {
        assert(srcIndex >= 0 && srcIndex < self.rowCount, "Source index out of range.")
        assert(dstIndex >= 0 && dstIndex < self.rowCount, "Destination index out of range.")
        self.ensureUniqueness()
        guard srcIndex != dstIndex else { return }
        
        self.storage.moveElements(fromRange: .init(startIndex: self.linearizedIndex(forRow: srcIndex, column: 0), count: self.columnCount), intoCorrespondingRangeStartingAt: self.linearizedIndex(forRow: dstIndex, column: 0))
    }
    
    mutating func moveRows(from srcRange: Range<Int>, to dstIndex: Int) {
        assert(srcRange.lowerBound >= 0 && srcRange.lowerBound < self.rowCount, "Source range out of range.")
        assert(srcRange.count + dstIndex <= self.rowCount, "Move not possible as it would overflow.")
        self.ensureUniqueness()
        guard srcRange.lowerBound != dstIndex else { return }
        
        let moveCount = srcRange.count * self.columnCount
        self.storage.moveElements(fromRange: .init(startIndex: self.linearizedIndex(forRow: srcRange.lowerBound, column: 0), count: moveCount), intoCorrespondingRangeStartingAt: self.linearizedIndex(forRow: dstIndex, column: 0))
    }
    
    mutating func moveColumn(from srcIndex: Int, to dstIndex: Int) {
        assert(srcIndex >= 0 && srcIndex < self.columnCount, "Source index out of range.")
        assert(dstIndex >= 0 && dstIndex < self.columnCount, "Destination index out of range.")
        self.ensureUniqueness()
        guard srcIndex != dstIndex else { return }
        
        (0..<self.rowCount).forEach {
            self.storage.moveElement(from: self.linearizedIndex(forRow: $0, column: srcIndex), to: self.linearizedIndex(forRow: $0, column: dstIndex))
        }
    }
    
    mutating func moveColumns(from srcRange: Range<Int>, to dstIndex: Int) {
        assert(srcRange.lowerBound >= 0 && srcRange.lowerBound < self.columnCount, "Source range out of range.")
        assert(srcRange.count + dstIndex <= self.columnCount, "Move not possible as it would overflow.")
        self.ensureUniqueness()
        guard srcRange.lowerBound != dstIndex else { return }
        
        (0..<self.columnCount).forEach {
            self.storage.moveElements(fromRange: .init(startIndex: self.linearizedIndex(forRow: $0, column: srcRange.lowerBound), count: srcRange.count), intoCorrespondingRangeStartingAt: self.linearizedIndex(forRow: $0, column: dstIndex))
        }
    }
}

// MARK: - Mutations: ExpressibleByNilLiteral specifics
public extension FixedDataTable where Element: ExpressibleByNilLiteral {
    mutating func moveRow(from srcIndex: Int, to dstIndex: Int) {
        assert(srcIndex >= 0 && srcIndex < self.rowCount, "Source index out of range.")
        assert(dstIndex >= 0 && dstIndex < self.rowCount, "Destination index out of range.")
        self.ensureUniqueness()
        guard srcIndex != dstIndex else { return }
        
        self.storage.moveElements(fromRange: .init(startIndex: self.linearizedIndex(forRow: srcIndex, column: 0), count: self.columnCount), intoCorrespondingRangeStartingAt: self.linearizedIndex(forRow: dstIndex, column: 0))
    }
    
    mutating func moveRows(from srcRange: Range<Int>, to dstIndex: Int) {
        assert(srcRange.lowerBound >= 0 && srcRange.lowerBound < self.rowCount, "Source range out of range.")
        assert(srcRange.count + dstIndex <= self.rowCount, "Move not possible as it would overflow.")
        self.ensureUniqueness()
        guard srcRange.lowerBound != dstIndex else { return }
        
        let moveCount = srcRange.count * self.columnCount
        self.storage.moveElements(fromRange: .init(startIndex: self.linearizedIndex(forRow: srcRange.lowerBound, column: 0), count: moveCount), intoCorrespondingRangeStartingAt: self.linearizedIndex(forRow: dstIndex, column: 0))
    }
    
    mutating func moveColumn(from srcIndex: Int, to dstIndex: Int) {
        assert(srcIndex >= 0 && srcIndex < self.columnCount, "Source index out of range.")
        assert(dstIndex >= 0 && dstIndex < self.columnCount, "Destination index out of range.")
        self.ensureUniqueness()
        guard srcIndex != dstIndex else { return }
        
        (0..<self.rowCount).forEach {
            self.storage.moveElement(from: self.linearizedIndex(forRow: $0, column: srcIndex), to: self.linearizedIndex(forRow: $0, column: dstIndex))
        }
    }
    
    mutating func moveColumns(from srcRange: Range<Int>, to dstIndex: Int) {
        assert(srcRange.lowerBound >= 0 && srcRange.lowerBound < self.columnCount, "Source range out of range.")
        assert(srcRange.count + dstIndex <= self.columnCount, "Move not possible as it would overflow.")
        self.ensureUniqueness()
        guard srcRange.lowerBound != dstIndex else { return }
        
        (0..<self.columnCount).forEach {
            self.storage.moveElements(fromRange: .init(startIndex: self.linearizedIndex(forRow: $0, column: srcRange.lowerBound), count: srcRange.count), intoCorrespondingRangeStartingAt: self.linearizedIndex(forRow: $0, column: dstIndex))
        }
    }
}

// MARK: - CustomDebugStringConvertible
extension FixedDataTable: CustomDebugStringConvertible {
    public var debugDescription: String {
        """
        FixedDataTable<\(type(of: Element.self))>
        - Size: \(self.rowCount) row\(self.rowCount > 1 ? "s" : "") × \(self.columnCount) column\(self.columnCount > 1 ? "s" : ""), totaling \(self.count) element\(self.count > 1 ? "s" : "").
        - Rows:
        \(self.rows.enumerated().map {
            "\t\($0.offset): " + String(reflecting: $0.element)
        }.joined(separator: "\n"))
        """
    }
}

// MARK: - CustomStringConvertible
extension FixedDataTable: CustomStringConvertible {
    public var description: String {
        let maxSize = self.storage.toArray().map { String(reflecting: $0).count }.max() ?? 0
        func overflow(_ item: Element) -> Int { maxSize - String(reflecting: item).count }
        func itemCell(_ item: Element) -> String {
            " \(String(repeating: " ", count: overflow(item)))\(item) "
        }
        let topLine = "┌\([String](repeating: String(repeating: "─", count: maxSize + 2), count: self.columnCount).joined(separator: "┬"))┐"
        let interLine = "├\([String](repeating: String(repeating: "─", count: maxSize + 2), count: self.columnCount).joined(separator: "┼"))┤"
        let bottomLine = "└\([String](repeating: String(repeating: "─", count: maxSize + 2), count: self.columnCount).joined(separator: "┴"))┘"
        
        let lines = [topLine] + [String](self.rows.map {
            "│\($0.map(itemCell(_:)).joined(separator: "│"))│"
        }.map { [$0] }.joined(separator: [interLine])) + [bottomLine]
        
        return lines.joined(separator: "\n")
    }
}
