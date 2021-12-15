//
//  Zip3.swift
//  Aldo's
//
//  Created by Pierre TACCHI on 20/03/2020.
//  Copyright © 2020 Pierre TACCHI. All rights reserved.
//

@inlinable
public func zip3<Sequence1: Sequence, Sequence2: Sequence, Sequence3: Sequence>(_ sequence1: Sequence1, _ sequence2: Sequence2, _ sequence3: Sequence3) -> Zip3Sequence<Sequence1, Sequence2, Sequence3> {
    Zip3Sequence(sequence1, sequence2, sequence3)
}

@frozen public struct Zip3Sequence<Sequence1: Sequence, Sequence2: Sequence, Sequence3: Sequence> {
    @usableFromInline let sequence1: Sequence1
    @usableFromInline let sequence2: Sequence2
    @usableFromInline let sequence3: Sequence3
    
    @inlinable init(_ sequence1: Sequence1, _ sequence2: Sequence2, _ sequence3: Sequence3) {
        self.sequence1 = sequence1
        self.sequence2 = sequence2
        self.sequence3 = sequence3
    }
}

extension Zip3Sequence {
    @frozen public struct Iterator {
        @usableFromInline var iterator1: Sequence1.Iterator
        @usableFromInline var iterator2: Sequence2.Iterator
        @usableFromInline var iterator3: Sequence3.Iterator
        
        @usableFromInline var reachedEnd: Bool = false
        
        @inlinable init(_ iterator1: Sequence1.Iterator, _ iterator2: Sequence2.Iterator, _ iterator3: Sequence3.Iterator) {
            self.iterator1 = iterator1
            self.iterator2 = iterator2
            self.iterator3 = iterator3
        }
    }
}

extension Zip3Sequence.Iterator: IteratorProtocol {
    public typealias Element = (Sequence1.Element, Sequence2.Element, Sequence3.Element)
    
    @inlinable mutating public func next() -> (Sequence1.Element, Sequence2.Element, Sequence3.Element)? {
        if reachedEnd { return nil }
        guard let item1 = iterator1.next(),
            let item2 = iterator2.next(),
            let item3 = iterator3.next() else {
                reachedEnd = true
                return nil
        }
        
        return (item1, item2, item3)
    }
}

extension Zip3Sequence: Sequence {
    public typealias Element = (Sequence1.Element, Sequence2.Element, Sequence3.Element)
    
    @inlinable public func makeIterator() -> Iterator {
        .init(sequence1.makeIterator(), sequence2.makeIterator(), sequence3.makeIterator())
    }
    
    @inlinable public var underestimatedCount: Int {
        Swift.min(Swift.min(sequence1.underestimatedCount, sequence2.underestimatedCount), sequence3.underestimatedCount)
    }
}
