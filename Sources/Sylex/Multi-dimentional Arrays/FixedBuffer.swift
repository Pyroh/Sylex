//
//  FixedBuffer.swift
//  
//
//  Created by Pierre TACCHI on 11/10/2019.
//

import Foundation

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
    
    func contiguousArray(fromIndex i: Int, count: Int) -> [Element] {
        self.withUnsafeMutablePointerToElements { (elements) -> [Element] in
            [Element](UnsafeBufferPointer(start: elements + i, count: count))
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

extension FixedBuffer where Element: Zeroable {
    class func create(withCapacity cap: Int) -> FixedBuffer {
        let buffer = FixedBuffer.create(minimumCapacity: cap, makingHeaderWith: { _ in cap }) as! FixedBuffer
        buffer.withUnsafeMutablePointerToElements { (elements) in
            elements.initialize(repeating: .zero, count: cap)
        }
        
        return buffer
    }
}

extension FixedBuffer where Element: ExpressibleByNilLiteral {
    class func create(withCapacity cap: Int) -> FixedBuffer {
        let buffer = FixedBuffer.create(minimumCapacity: cap, makingHeaderWith: { _ in cap }) as! FixedBuffer
        buffer.withUnsafeMutablePointerToElements { (elements) in
            elements.initialize(repeating: nil, count: cap)
        }
        
        return buffer
    }
}
