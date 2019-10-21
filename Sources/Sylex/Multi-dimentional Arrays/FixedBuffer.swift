//
//  FixedBuffer.swift
//  Sylex
//
//  Created by Pierre TACCHI on 14/10/2019.
//

// MARK: - Main
final class FixedBuffer<Element>: ManagedBuffer<Int, Element> {
    class func create(withCapacity cap: Int) -> FixedBuffer {
        FixedBuffer.create(minimumCapacity: cap, makingHeaderWith: { _ in cap }) as! FixedBuffer
    }
    
    class func create(fromArray array: [Element]) -> FixedBuffer {
        array.withUnsafeBufferPointer { (arrayElements) -> FixedBuffer in
            let cap = array.count
            let buffer = FixedBuffer<Element>.create(withCapacity: cap)
            buffer.withUnsafeMutablePointerToElements { (elements) in
                elements.initialize(from: arrayElements.baseAddress!, count: cap)
            }
            return buffer
        }
    }
    
    deinit {
        self.withUnsafeMutablePointers { (header, elements) -> () in
            header.deinitialize(count: 1)
            elements.deinitialize(count: self.capacity)
        }
    }
    
    func clone() -> FixedBuffer {
        self.withUnsafeMutablePointers { (header, currentElements) -> FixedBuffer in
            let clone = FixedBuffer<Element>.create(withCapacity: header.pointee)
            clone.withUnsafeMutablePointerToElements { (elements) in
                elements.initialize(from: currentElements, count: self.capacity)
            }
            return clone
        }
    }
    
    subscript(i: Int) -> Element {
        get {
            assert(i < self.capacity, "Index out of range")
            return self.withUnsafeMutablePointerToElements { $0[i] }
        }
        set {
            assert(i < self.capacity, "Index out of range")
            self.withUnsafeMutablePointerToElements { $0[i] = newValue }
        }
    }
}

// MARK: - Array interaction
extension FixedBuffer {
    func toArray() -> [Element] {
        self.withUnsafeMutablePointerToHeader { self.contiguousArray(fromIndex: 0, count: $0.pointee) }
    }
    
    func contiguousArray(fromIndex i: Int, count: Int) -> [Element] {
        self.withUnsafeMutablePointerToElements { (elements) -> [Element] in
            [Element](UnsafeBufferPointer(start: elements + i, count: count))
        }
    }
}

// MARK: - Mutations
extension FixedBuffer {
    func moveElements(fromRange srcRange: Range<Int>, intoCorrespondingRangeStatingAt dstIndex: Int, fillingGapWith value: Element) {
        
        let srcIndex = srcRange.lowerBound
        let count = srcRange.count
        let capacity = self.withUnsafeMutablePointerToHeader { $0.pointee }
        
        assert(srcIndex >= 0 && srcIndex < capacity, "Source pointer location is out of range.")
        assert(dstIndex >= 0 && dstIndex < capacity, "Destination pointer location is out of range.")
        assert(srcIndex + count <= capacity, "Source range is out of range.")
        assert(dstIndex + count <= capacity, "Destination range is out of range.")
        
        let srcRange = srcIndex..<srcIndex + count
        let dstRange = dstIndex..<dstIndex + count
        
        if dstRange.overlaps(srcRange) {
            self.withUnsafeMutablePointerToElements {
                let tmp = UnsafeMutablePointer<Element>.allocate(capacity: count)
                tmp.initialize(from: $0 + srcIndex, count: count)
                ($0 + dstIndex).moveAssign(from: tmp, count: count)
                tmp.deallocate()
            }
        } else {
            self.withUnsafeMutablePointerToElements { ($0 + dstIndex).moveAssign(from: ($0 + srcIndex), count: count) }
        }
        
        let emptyied = Set(srcRange).subtracting(Set(dstRange))
        
        if emptyied.count > 0, let startIndex = emptyied.min() {
            self.initialize(range: .init(startIndex: startIndex, count: emptyied.count), with: value)
        }
    }
    
    func swapElement(at i: Int, withElementAt j: Int) {
        let capacity = self.withUnsafeMutablePointerToHeader { $0.pointee }
        
        assert(i >= 0 && i < capacity, "Index \(i) is out of bounds.")
        assert(j >= 0 && j < capacity, "Index \(j) is out of bounds.")
        
        guard i != j else { return }
        
        (self[i], self[j]) = (self[j], self[i])
    }
    
    func swapElements(in srcRange: Range<Int>, withElementsInCorrespondingRangeStatingAt dstIndex: Int) {
        let capacity = self.withUnsafeMutablePointerToHeader { $0.pointee }
        let allowedRange = 0..<capacity
        
        guard srcRange.count > 1 else {
            self.swapElement(at: srcRange.lowerBound, withElementAt: dstIndex)
            return
        }
        let dstRange = dstIndex..<dstIndex + srcRange.count
        assert(srcRange.lowerBound >= allowedRange.lowerBound && srcRange.upperBound <= allowedRange.upperBound, "Source range out of range.")
        assert(dstRange.lowerBound >= allowedRange.lowerBound && dstRange.upperBound <= allowedRange.upperBound, "Destination range out of range.")
        
        guard srcRange != dstRange else { return }
        let count = srcRange.count
        
        self.withUnsafeMutablePointerToElements {
            let srcTmp = UnsafeMutablePointer<Element>.allocate(capacity: count)
            let dstTmp = UnsafeMutablePointer<Element>.allocate(capacity: count)
            
            srcTmp.initialize(from: $0 + srcRange.lowerBound, count: count)
            dstTmp.initialize(from: $0 + dstRange.lowerBound, count: count)
            
            ($0 + dstRange.lowerBound).moveAssign(from: srcTmp, count: count)
            ($0 + srcRange.lowerBound).moveAssign(from: dstTmp, count: count)
            
            srcTmp.deallocate()
            dstTmp.deallocate()
        }
    }
    
    func copyElements(from srcArray: [Element], at dstIndex: Int) {
        let capacity = self.withUnsafeMutablePointerToHeader { $0.pointee }
        let endCopyIndex = dstIndex + srcArray.count
        
        assert(endCopyIndex <= capacity, "Not enough room to copy the given elements starting at index \(dstIndex).")
        
        self.withUnsafeMutablePointerToElements { (elements) in
            srcArray.withUnsafeBufferPointer { (srcElements) in
                (elements + dstIndex).assign(from: srcElements.baseAddress!, count: srcArray.count)
            }
        }
    }
    
    private func initialize(range: Range<Int>, with value: Element) {
        self.withUnsafeMutablePointers { (header, elements) in
            let capacity = header.pointee
            
            assert(range.lowerBound >= 0 && range.lowerBound < capacity, "Start index out of range.")
            assert(range.upperBound <= capacity, "Initializing range is out of range")
            
            (elements + range.lowerBound).initialize(repeating: value, count: range.count)
        }
    }
}

// MARK: - Zeroable specifics
extension FixedBuffer where Element: Zeroable {
    class func create(withCapacity cap: Int) -> FixedBuffer {
        let buffer = FixedBuffer.create(minimumCapacity: cap, makingHeaderWith: { _ in cap }) as! FixedBuffer
        buffer.withUnsafeMutablePointerToElements { (elements) in
            elements.initialize(repeating: .zero, count: cap)
        }
        
        return buffer
    }
    
    func moveElement(from srcIndex: Int, to dstIndex: Int) {
        self.moveElements(fromRange: .init(startIndex: srcIndex, count: 1), intoCorrespondingRangeStatingAt: dstIndex, fillingGapWith: .zero)
    }
    
    func moveElements(fromRange srcRange: Range<Int>, intoCorrespondingRangeStartingAt dstIndex: Int) {
        self.moveElements(fromRange: srcRange, intoCorrespondingRangeStatingAt: dstIndex, fillingGapWith: .zero)
    }
}

// MARK: - Optionals specifics
extension FixedBuffer where Element: ExpressibleByNilLiteral {
    class func create(withCapacity cap: Int) -> FixedBuffer {
        let buffer = FixedBuffer.create(minimumCapacity: cap, makingHeaderWith: { _ in cap }) as! FixedBuffer
        buffer.withUnsafeMutablePointerToElements { (elements) in
            elements.initialize(repeating: nil, count: cap)
        }
        
        return buffer
    }
    
    func moveElement(from srcIndex: Int, to dstIndex: Int) {
        self.moveElements(fromRange: .init(startIndex: srcIndex, count: 1), intoCorrespondingRangeStatingAt: dstIndex, fillingGapWith: nil)
    }
    
    func moveElements(fromRange srcRange: Range<Int>, intoCorrespondingRangeStartingAt dstIndex: Int) {
        self.moveElements(fromRange: srcRange, intoCorrespondingRangeStatingAt: dstIndex, fillingGapWith: nil)
    }
}
