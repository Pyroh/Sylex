//
//  FixedDataTable.swift
//  Sylex
//
//  Created by Pierre TACCHI on 14/10/2019.
//

import Foundation
import SmoothOperators
import ZeroableProtocol
#if !os(macOS)
import CoreGraphics
#endif

public struct Matrix<Element> {
    public enum Dimension {
        case row(Int)
        case col(Int)
    }
    
    private struct MatrixColumnIterator: IteratorProtocol {
        typealias Buffer = FixedSizeBuffer<Element>
        
        private unowned var buffer: Buffer
        private let columnCount: Int
        private var currentIndex: Int
        private var endIndex: Int
        
        init(atIndex i: Int, withBuffer buffer: Buffer, columnCount: Int) {
            precondition(i < columnCount, "Column index can't exceed column count.")
            precondition(columnCount > 0, "Column count must be greater than or equal to 1.")
            
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
    
    private var storage: FixedSizeBuffer<Element>
    
    public let columnCount: Int
    public let rowCount: Int
    public var count: Int { return self.columnCount * self.rowCount }
    public var size: MatrixSize { return .init(width: self.columnCount, height: self.rowCount) }
    
    public init(rows: Int, columns: Int) {
        precondition(columns > 0, "Coloumn count must be greater than or equal to 1.")
        precondition(rows > 0, "Row count must be greater than or equal to 1.")
        
        self.columnCount = columns
        self.rowCount = rows
        
        let count = self.columnCount * self.rowCount
        
        self.storage = FixedSizeBuffer<Element>.create(withCapacity: count)
    }
    
    public init(fromMultiDimensionalArray array: [[Element]]) {
        precondition(!array.isEmpty, "Can not initialize an empty table.")
        let columnsCount = Set(array.lazy.map { $0.count })
        precondition(columnsCount.count == 1, "Each subarray must hold the same number of items.")
        precondition(columnsCount.first! > 0, "Each subarray must hold at least one element.")
        let rows = array.count
        
        let buffer = [Element](array.joined())
        
        self = .init(rows: rows, columns: columnsCount.first!, buffer: buffer)
    }
    
    internal init(rows: Int, columns: Int, buffer: [Element]) {
        precondition(columns > 0, "Coloumn count must be greater than or equal to 1.")
        precondition(rows > 0, "Row count must be greater than or equal to 1.")
        precondition(rows * columns == buffer.count, "The buffer must hold the exact number of items.")
        
        self.columnCount = columns
        self.rowCount = rows
        
        self.storage = .create(fromArray: buffer)
    }
    
    public subscript(col: Int, row: Int) -> Element {
        get {
            precondition(row >= 0 && row < self.rowCount, "Row index out of bounds.")
            precondition(col >= 0 && col < self.rowCount, "Column index out of bounds.")
            return self.storage[self.linearizedIndex(forRow: row, column: col)]
        }
        mutating set {
            precondition(row >= 0 && row < self.rowCount, "Row index out of bounds.")
            precondition(col >= 0 && col < self.rowCount, "Column index out of bounds.")
            self.storage[self.linearizedIndex(forRow: row, column: col)] = newValue
        }
    }
    
    @available(*, deprecated, message: "Use the TableCoord one instead")
    public subscript(point: CGPoint) -> Element {
        get {
            let x = Int(point.x)
            let y = Int(point.y)
            
            return self[x, y]
        }
        mutating set {
            let x = Int(point.x)
            let y = Int(point.y)
            
            self[x, y] = newValue
        }
    }
    
    public subscript(coord: MatrixCoordinate) -> Element {
        get { self[coord.column, coord.row] }
        
        mutating set { self[coord.column, coord.row] = newValue }
    }
    
    private func linearizedIndex(forRow row: Int, column: Int) -> Int {
        row * self.columnCount + column
    }
    
    private func coordinateToIndex(_ coord: MatrixCoordinate) -> Int {
        self.linearizedIndex(forRow: coord.row, column: coord.column)
    }
    
    private func delinearizedIndex(_ index: Int) -> (row: Int, column: Int) {
        let row = index / self.columnCount
        let column = index % self.columnCount

        return (row, column)
    }
    
    private func indexToCoordinate(_ index: Int) -> MatrixCoordinate {
        .init(delinearizedIndex(index))
    }
    
    private var sequenceStorage: AnySequence<Element> {
        AnySequence<Element>({ () -> AnyIterator<Element> in
            var index = 0
            return AnyIterator<Element> {
                return index < self.count ? self.storage[index++] : nil
            }
        })
    }
    
    private mutating func ensureUniqueness() {
        if !isKnownUniquelyReferenced(&self.storage) {
            self.storage = self.storage.clone()
        }
    }
}

// MARK: - Specific intializer
public extension Matrix where Element: Zeroable {
    
    @available(*, deprecated, message: "Use the TableSize one instead")
    init(size: CGSize) {
        precondition(size.width > 0, "Coloumn count must be greater than or equal to 1.")
        precondition(size.height > 0, "Row count must be greater than or equal to 1.")

        self.columnCount = Int(size.width)
        self.rowCount = Int(size.height)
        
        let count = self.columnCount * self.rowCount
        
        self.storage = FixedSizeBuffer<Element>.create(withCapacity: count)
    }
    
    init(size: MatrixSize) {
        precondition(size.width > 0, "Coloumn count must be greater than or equal to 1.")
        precondition(size.height > 0, "Row count must be greater than or equal to 1.")
        
        self.columnCount = Int(size.width)
        self.rowCount = Int(size.height)
        
        let count = self.columnCount * self.rowCount
        
        self.storage = FixedSizeBuffer<Element>.create(withCapacity: count)
    }
    
    init(rows: Int, columns: Int) {
        precondition(columns > 0, "Coloumn count must be greater than or equal to 1.")
        precondition(rows > 0, "Row count must be greater than or equal to 1.")

        self.columnCount = columns
        self.rowCount = rows
        
        let count = self.columnCount * self.rowCount

        self.storage = FixedSizeBuffer<Element>.create(withCapacity: count)
    }
}

public extension Matrix where Element: ExpressibleByNilLiteral {
    @available(*, deprecated, message: "Use the TableSize one instead")
    init(size: CGSize) {
        precondition(size.width > 0, "Coloumn count must be greater than or equal to 1.")
        precondition(size.height > 0, "Row count must be greater than or equal to 1.")

        self.columnCount = Int(size.width)
        self.rowCount = Int(size.height)
        
        let count = self.columnCount * self.rowCount
        
        self.storage = FixedSizeBuffer<Element>.create(withCapacity: count)
    }
    
    init(size: MatrixSize) {
        precondition(size.width > 0, "Coloumn count must be greater than or equal to 1.")
        precondition(size.height > 0, "Row count must be greater than or equal to 1.")
        
        self.columnCount = Int(size.width)
        self.rowCount = Int(size.height)
        
        let count = self.columnCount * self.rowCount
        
        self.storage = FixedSizeBuffer<Element>.create(withCapacity: count)
    }
    
    init(rows: Int, columns: Int) {
        precondition(columns > 0, "Coloumn count must be greater than or equal to 1.")
        precondition(rows > 0, "Row count must be greater than or equal to 1.")

        self.columnCount = columns
        self.rowCount = rows
        
        let count = self.columnCount * self.rowCount

        self.storage = FixedSizeBuffer<Element>.create(withCapacity: count)
    }
}

public extension Matrix where Element == Bool {
    
    @available(*, deprecated, message: "Use the TableSize one instead")
    init(size: CGSize) {
        precondition(size.width > 0, "Coloumn count must be greater than or equal to 1.")
        precondition(size.height > 0, "Row count must be greater than or equal to 1.")

        self.columnCount = Int(size.width)
        self.rowCount = Int(size.height)
        
        let count = self.columnCount * self.rowCount
        
        self.storage = FixedSizeBuffer<Element>.create(withCapacity: count)
    }
    
    init(size: MatrixSize) {
        precondition(size.width > 0, "Coloumn count must be greater than or equal to 1.")
        precondition(size.height > 0, "Row count must be greater than or equal to 1.")
        
        self.columnCount = Int(size.width)
        self.rowCount = Int(size.height)
        
        let count = self.columnCount * self.rowCount
        
        self.storage = FixedSizeBuffer<Element>.create(withCapacity: count)
    }
    
    init(rows: Int, columns: Int) {
        precondition(columns > 0, "Coloumn count must be greater than or equal to 1.")
        precondition(rows > 0, "Row count must be greater than or equal to 1.")

        self.columnCount = columns
        self.rowCount = rows
        
        let count = self.columnCount * self.rowCount

        self.storage = FixedSizeBuffer<Element>.create(withCapacity: count)
    }
}

// MARK: - Elements boundaries
public extension Matrix where Element: Zeroable&Comparable {
    func min() -> Element {
        self.rows.compactMap { $0.min() }.min() ?? .zero
    }
    
    func max() -> Element {
        self.rows.compactMap { $0.max() }.max() ?? .zero
    }
}

public extension Matrix where Element: AdditiveArithmetic {
    func sum() -> Element {
        self.sequenceStorage.reduce(.zero, +)
    }
}

// MARK: - Equatable
extension Matrix: Equatable where Element: Equatable {
    public static func == (lhs: Matrix<Element>, rhs: Matrix<Element>) -> Bool {
        lhs.size == rhs.size && lhs.storage.toArray() == rhs.storage.toArray()
    }
}

// MARK: - Access rows and columns
public extension Matrix {
    var rows:[[Element]] {
        (0..<self.rowCount).lazy.map { self.linearizedIndex(forRow: $0, column: 0) }.map { self.storage.contiguousArray(fromIndex: $0, count: self.columnCount) }
    }
    
    var columns: [[Element]] {
        (0..<self.columnCount).lazy.map { index in AnySequence<Element>({ MatrixColumnIterator(atIndex: index, withBuffer: self.storage, columnCount: self.columnCount) }) }.map([Element].init)
    }
    
    subscript(dimension: Dimension) -> [Element] {
        get {
            switch dimension {
            case .row(let row):
                precondition(row < self.rowCount, "Row index \(row) out of range.")
                return self.row(at: row)
            case .col(let col):
                precondition(col < self.columnCount, "Row index \(col) out of range.")
                return self.column(at: col)
            }
        }
        
        mutating set {
            switch dimension {
            case .row(let row):
                precondition(row < self.rowCount, "Row index \(row) out of range.")
                self.ensureUniqueness()
                self.setRow(newValue, at: row)
            case .col(let col):
                precondition(col < self.columnCount, "Row index \(col) out of range.")
                self.ensureUniqueness()
                self.setColumn(newValue, at: col)
            }
        }
    }
    
    private func column(at index: Int) -> [Element] {
        [Element](AnySequence<Element>({ MatrixColumnIterator(atIndex: index, withBuffer: self.storage, columnCount: self.columnCount) }))
    }
    
    private func row(at index: Int) -> [Element] {
        self.storage.contiguousArray(fromIndex: self.linearizedIndex(forRow: index, column: 0), count: self.columnCount)
    }
}

// MARK: - Monadics
public extension Matrix {
    typealias EnumeratedElement = (coordinate: MatrixCoordinate, element: Element)
    
    func map<T>(_ transform: (Element) throws -> T) rethrows -> Matrix<T> {
        Matrix<T>(rows: self.rowCount, columns: self.columnCount, buffer: try self.sequenceStorage.map(transform))
    }
    
    func forEach(_ body: (Element) throws -> Void) rethrows {
        try self.sequenceStorage.forEach(body)
    }
    
    @available(*, deprecated, message: "Use enumerated() instead.")
    func enumerate(_ body: ((row: Int, column: Int), Element) throws -> Void) rethrows {
        try self.sequenceStorage.enumerated().forEach { (offset: Int, element: Element) in
            try body(self.delinearizedIndex(offset), element)
        }
    }
    
    func enumerated() -> AnySequence<EnumeratedElement> {
        AnySequence<EnumeratedElement>({ () -> AnyIterator<EnumeratedElement> in
            var index = 0
            return AnyIterator<EnumeratedElement> {
                return index < self.count ? (self.indexToCoordinate(index), self.storage[index++]) : nil
            }
        })
    }
}

// MARK: - Mutate rows and columns
private extension Matrix {
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

// MARK: - Mutations
public extension Matrix where Element: Zeroable {
    mutating func moveRow(from srcIndex: Int, to dstIndex: Int) {
        precondition(srcIndex >= 0 && srcIndex < self.rowCount, "Source index out of range.")
        precondition(dstIndex >= 0 && dstIndex < self.rowCount, "Destination index out of range.")
        self.ensureUniqueness()
        guard srcIndex != dstIndex else { return }
        
        self.storage.moveElements(fromRange: .init(startIndex: self.linearizedIndex(forRow: srcIndex, column: 0), count: self.columnCount), intoCorrespondingRangeStartingAt: self.linearizedIndex(forRow: dstIndex, column: 0))
    }
    
    mutating func moveRows(from srcRange: Range<Int>, to dstIndex: Int) {
        precondition(srcRange.lowerBound >= 0 && srcRange.lowerBound < self.rowCount, "Source range out of range.")
        precondition(srcRange.count + dstIndex <= self.rowCount, "Move not possible as it would overflow.")
        self.ensureUniqueness()
        guard srcRange.lowerBound != dstIndex else { return }
        
        let moveCount = srcRange.count * self.columnCount
        self.storage.moveElements(fromRange: .init(startIndex: self.linearizedIndex(forRow: srcRange.lowerBound, column: 0), count: moveCount), intoCorrespondingRangeStartingAt: self.linearizedIndex(forRow: dstIndex, column: 0))
    }
    
    mutating func moveColumn(from srcIndex: Int, to dstIndex: Int) {
        precondition(srcIndex >= 0 && srcIndex < self.columnCount, "Source index out of range.")
        precondition(dstIndex >= 0 && dstIndex < self.columnCount, "Destination index out of range.")
        self.ensureUniqueness()
        guard srcIndex != dstIndex else { return }
        
        (0..<self.rowCount).forEach {
            self.storage.moveElement(from: self.linearizedIndex(forRow: $0, column: srcIndex), to: self.linearizedIndex(forRow: $0, column: dstIndex))
        }
    }
    
    mutating func moveColumns(from srcRange: Range<Int>, to dstIndex: Int) {
        precondition(srcRange.lowerBound >= 0 && srcRange.lowerBound < self.columnCount, "Source range out of range.")
        precondition(srcRange.count + dstIndex <= self.columnCount, "Move not possible as it would overflow.")
        self.ensureUniqueness()
        guard srcRange.lowerBound != dstIndex else { return }
        
        (0..<self.columnCount).forEach {
            self.storage.moveElements(fromRange: .init(startIndex: self.linearizedIndex(forRow: $0, column: srcRange.lowerBound), count: srcRange.count), intoCorrespondingRangeStartingAt: self.linearizedIndex(forRow: $0, column: dstIndex))
        }
    }
}

public extension Matrix where Element: ExpressibleByNilLiteral {
    mutating func moveRow(from srcIndex: Int, to dstIndex: Int) {
        precondition(srcIndex >= 0 && srcIndex < self.rowCount, "Source index out of range.")
        precondition(dstIndex >= 0 && dstIndex < self.rowCount, "Destination index out of range.")
        self.ensureUniqueness()
        guard srcIndex != dstIndex else { return }
        
        self.storage.moveElements(fromRange: .init(startIndex: self.linearizedIndex(forRow: srcIndex, column: 0), count: self.columnCount), intoCorrespondingRangeStartingAt: self.linearizedIndex(forRow: dstIndex, column: 0))
    }
    
    mutating func moveRows(from srcRange: Range<Int>, to dstIndex: Int) {
        precondition(srcRange.lowerBound >= 0 && srcRange.lowerBound < self.rowCount, "Source range out of range.")
        precondition(srcRange.count + dstIndex <= self.rowCount, "Move not possible as it would overflow.")
        self.ensureUniqueness()
        guard srcRange.lowerBound != dstIndex else { return }
        
        let moveCount = srcRange.count * self.columnCount
        self.storage.moveElements(fromRange: .init(startIndex: self.linearizedIndex(forRow: srcRange.lowerBound, column: 0), count: moveCount), intoCorrespondingRangeStartingAt: self.linearizedIndex(forRow: dstIndex, column: 0))
    }
    
    mutating func moveColumn(from srcIndex: Int, to dstIndex: Int) {
        precondition(srcIndex >= 0 && srcIndex < self.columnCount, "Source index out of range.")
        precondition(dstIndex >= 0 && dstIndex < self.columnCount, "Destination index out of range.")
        self.ensureUniqueness()
        guard srcIndex != dstIndex else { return }
        
        (0..<self.rowCount).forEach {
            self.storage.moveElement(from: self.linearizedIndex(forRow: $0, column: srcIndex), to: self.linearizedIndex(forRow: $0, column: dstIndex))
        }
    }
    
    mutating func moveColumns(from srcRange: Range<Int>, to dstIndex: Int) {
        precondition(srcRange.lowerBound >= 0 && srcRange.lowerBound < self.columnCount, "Source range out of range.")
        precondition(srcRange.count + dstIndex <= self.columnCount, "Move not possible as it would overflow.")
        self.ensureUniqueness()
        guard srcRange.lowerBound != dstIndex else { return }
        
        (0..<self.columnCount).forEach {
            self.storage.moveElements(fromRange: .init(startIndex: self.linearizedIndex(forRow: $0, column: srcRange.lowerBound), count: srcRange.count), intoCorrespondingRangeStartingAt: self.linearizedIndex(forRow: $0, column: dstIndex))
        }
    }
}

public extension Matrix where Element == Bool {
    mutating func moveRow(from srcIndex: Int, to dstIndex: Int) {
        precondition(srcIndex >= 0 && srcIndex < self.rowCount, "Source index out of range.")
        precondition(dstIndex >= 0 && dstIndex < self.rowCount, "Destination index out of range.")
        self.ensureUniqueness()
        guard srcIndex != dstIndex else { return }
        
        self.storage.moveElements(fromRange: .init(startIndex: self.linearizedIndex(forRow: srcIndex, column: 0), count: self.columnCount), intoCorrespondingRangeStartingAt: self.linearizedIndex(forRow: dstIndex, column: 0))
    }
    
    mutating func moveRows(from srcRange: Range<Int>, to dstIndex: Int) {
        precondition(srcRange.lowerBound >= 0 && srcRange.lowerBound < self.rowCount, "Source range out of range.")
        precondition(srcRange.count + dstIndex <= self.rowCount, "Move not possible as it would overflow.")
        self.ensureUniqueness()
        guard srcRange.lowerBound != dstIndex else { return }
        
        let moveCount = srcRange.count * self.columnCount
        self.storage.moveElements(fromRange: .init(startIndex: self.linearizedIndex(forRow: srcRange.lowerBound, column: 0), count: moveCount), intoCorrespondingRangeStartingAt: self.linearizedIndex(forRow: dstIndex, column: 0))
    }
    
    mutating func moveColumn(from srcIndex: Int, to dstIndex: Int) {
        precondition(srcIndex >= 0 && srcIndex < self.columnCount, "Source index out of range.")
        precondition(dstIndex >= 0 && dstIndex < self.columnCount, "Destination index out of range.")
        self.ensureUniqueness()
        guard srcIndex != dstIndex else { return }
        
        (0..<self.rowCount).forEach {
            self.storage.moveElement(from: self.linearizedIndex(forRow: $0, column: srcIndex), to: self.linearizedIndex(forRow: $0, column: dstIndex))
        }
    }
    
    mutating func moveColumns(from srcRange: Range<Int>, to dstIndex: Int) {
        precondition(srcRange.lowerBound >= 0 && srcRange.lowerBound < self.columnCount, "Source range out of range.")
        precondition(srcRange.count + dstIndex <= self.columnCount, "Move not possible as it would overflow.")
        self.ensureUniqueness()
        guard srcRange.lowerBound != dstIndex else { return }
        
        (0..<self.columnCount).forEach {
            self.storage.moveElements(fromRange: .init(startIndex: self.linearizedIndex(forRow: $0, column: srcRange.lowerBound), count: srcRange.count), intoCorrespondingRangeStartingAt: self.linearizedIndex(forRow: $0, column: dstIndex))
        }
    }
}

// MARK: - Rotate & Flip
extension Matrix {
    public mutating func rotateLeft() {
        self = self.rotatedLeft()
    }
    
    public func rotatedLeft() -> Matrix {
        .init(fromMultiDimensionalArray: columns.reversed())
    }
    
    public mutating func rotateRight() {
        self = self.rotatedRight()
    }
    
    public func rotatedRight() -> Matrix {
        .init(fromMultiDimensionalArray: columns.map { $0.reversed() })
    }
    
    public mutating func flipHorizontally() {
        self = self.horizontallyFlipped()
    }
    
    public func horizontallyFlipped() -> Matrix {
        .init(fromMultiDimensionalArray: rows.map { $0.reversed() })
    }
    
    public mutating func flipVertically() {
        self = self.verticallyFlipped()
    }
    
    public func verticallyFlipped() -> Matrix {
        .init(fromMultiDimensionalArray: rows.reversed())
    }
}

// MARK: - CustomDebugStringConvertible
extension Matrix: CustomDebugStringConvertible {
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
extension Matrix: CustomStringConvertible {
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
