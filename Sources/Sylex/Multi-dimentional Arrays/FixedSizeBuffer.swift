//
//  FixedBuffer.swift
//  Sylex
//

import ZeroableProtocol

// MARK: - Main
final class FixedSizeBuffer<Element>: ManagedBuffer<Int, Element> {
    class func create(withCapacity cap: Int) -> FixedSizeBuffer {
        FixedSizeBuffer.create(minimumCapacity: cap, makingHeaderWith: { _ in cap }) as! FixedSizeBuffer
    }
    
    class func create(fromArray array: [Element]) -> FixedSizeBuffer {
        array.withUnsafeBufferPointer { (arrayElements) -> FixedSizeBuffer in
            let cap = array.count
            let buffer = FixedSizeBuffer<Element>.create(withCapacity: cap)
            buffer.withUnsafeMutablePointerToElements { (elements) in
                elements.initialize(from: arrayElements.baseAddress!, count: cap)
            }
            return buffer
        }
    }
    
    deinit {
        self.withUnsafeMutablePointers { (header, elements) -> () in
            let cap = header.pointee
            elements.deinitialize(count: cap)
            header.deinitialize(count: 1)
        }
    }
    
    func clone() -> FixedSizeBuffer {
        self.withUnsafeMutablePointers { (header, currentElements) -> FixedSizeBuffer in
            let clone = FixedSizeBuffer<Element>.create(withCapacity: header.pointee)
            clone.withUnsafeMutablePointerToElements { (elements) in
                elements.initialize(from: currentElements, count: self.capacity)
            }
            return clone
        }
    }
    
    subscript(i: Int) -> Element {
        get {
            return self.withUnsafeMutablePointerToElements { $0[i] }
        }
        set {
            self.withUnsafeMutablePointerToElements { $0[i] = newValue }
        }
    }
}

// MARK: - Array interaction
extension FixedSizeBuffer {
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
extension FixedSizeBuffer {
    func moveElements(fromRange srcRange: Range<Int>, intoCorrespondingRangeStatingAt dstIndex: Int, fillingGapWith value: Element) {
        
        let srcIndex = srcRange.lowerBound
        let count = srcRange.count
        
        let srcRange = srcIndex..<srcIndex + count
        let dstRange = dstIndex..<dstIndex + count
        
        if dstRange.overlaps(srcRange) {
            self.withUnsafeMutablePointerToElements {
                let tmp = UnsafeMutablePointer<Element>.allocate(capacity: count)
                tmp.initialize(from: $0 + srcIndex, count: count)
                ($0 + dstIndex).moveUpdate(from: tmp, count: count)
                tmp.deallocate()
            }
        } else {
            self.withUnsafeMutablePointerToElements { ($0 + dstIndex).moveUpdate(from: ($0 + srcIndex), count: count) }
        }
        
        let emptyied = Set(srcRange).subtracting(Set(dstRange))
        
        if emptyied.count > 0, let startIndex = emptyied.min() {
            self.initialize(range: .init(startIndex: startIndex, count: emptyied.count), with: value)
        }
    }
    
    func swapElement(at i: Int, withElementAt j: Int) {
        guard i != j else { return }
        
        (self[i], self[j]) = (self[j], self[i])
    }
    
    func swapElements(in srcRange: Range<Int>, withElementsInCorrespondingRangeStatingAt dstIndex: Int) {
        guard srcRange.count > 1 else {
            self.swapElement(at: srcRange.lowerBound, withElementAt: dstIndex)
            return
        }
        let dstRange = dstIndex..<dstIndex + srcRange.count
        
        guard srcRange != dstRange else { return }
        let count = srcRange.count
        
        self.withUnsafeMutablePointerToElements {
            let srcTmp = UnsafeMutablePointer<Element>.allocate(capacity: count)
            let dstTmp = UnsafeMutablePointer<Element>.allocate(capacity: count)
            
            srcTmp.initialize(from: $0 + srcRange.lowerBound, count: count)
            dstTmp.initialize(from: $0 + dstRange.lowerBound, count: count)
            
            ($0 + dstRange.lowerBound).moveUpdate(from: srcTmp, count: count)
            ($0 + srcRange.lowerBound).moveUpdate(from: dstTmp, count: count)
            
            srcTmp.deallocate()
            dstTmp.deallocate()
        }
    }
    
    func copyElements(from srcArray: [Element], at dstIndex: Int) {
        self.withUnsafeMutablePointerToElements { (elements) in
            srcArray.withUnsafeBufferPointer { (srcElements) in
                (elements + dstIndex).update(from: srcElements.baseAddress!, count: srcArray.count)
            }
        }
    }
    
    private func initialize(range: Range<Int>, with value: Element) {
        self.withUnsafeMutablePointers { (header, elements) in
            (elements + range.lowerBound).initialize(repeating: value, count: range.count)
        }
    }
}

// MARK: - Zeroable specifics
extension FixedSizeBuffer where Element: Zeroable {
    class func create(withCapacity cap: Int) -> FixedSizeBuffer {
        let buffer = FixedSizeBuffer.create(minimumCapacity: cap, makingHeaderWith: { _ in cap }) as! FixedSizeBuffer
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
extension FixedSizeBuffer where Element: ExpressibleByNilLiteral {
    class func create(withCapacity cap: Int) -> FixedSizeBuffer {
        let buffer = FixedSizeBuffer.create(minimumCapacity: cap, makingHeaderWith: { _ in cap }) as! FixedSizeBuffer
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

// MARK: - Bool specifics
extension FixedSizeBuffer where Element == Bool {
    class func create(withCapacity cap: Int) -> FixedSizeBuffer {
        let buffer = FixedSizeBuffer.create(minimumCapacity: cap, makingHeaderWith: { _ in cap }) as! FixedSizeBuffer
        buffer.withUnsafeMutablePointerToElements { (elements) in
            elements.initialize(repeating: false, count: cap)
        }
        
        return buffer
    }
    
    func moveElement(from srcIndex: Int, to dstIndex: Int) {
        self.moveElements(fromRange: .init(startIndex: srcIndex, count: 1), intoCorrespondingRangeStatingAt: dstIndex, fillingGapWith: false)
    }
    
    func moveElements(fromRange srcRange: Range<Int>, intoCorrespondingRangeStartingAt dstIndex: Int) {
        self.moveElements(fromRange: srcRange, intoCorrespondingRangeStatingAt: dstIndex, fillingGapWith: false)
    }
}
