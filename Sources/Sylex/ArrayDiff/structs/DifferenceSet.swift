//
//  DifferenceSet.swift
//  Sylex
//
//  Created by Pierre TACCHI on 22/08/2018.
//

import Foundation

public struct DifferenceSet {
    public let removedIndices: [Int]
    public let insertedIndices: [Int]
    public let movedIndexPair: [SwappedIndexPair]
    
    public var removedIndexSet: IndexSet {
        return IndexSet(self.removedIndices)
    }
    public var insertedIndexSet: IndexSet {
        return IndexSet(self.insertedIndices)
    }
    public var localMovedIndexPairSet: Set<SwappedIndexPair.IndexPair> {
        return self.movedIndexPair.lazy.map { $0.local }.set
    }
    public var globalMovedIndexPairSet: Set<SwappedIndexPair.IndexPair> {
        return self.movedIndexPair.lazy.map { $0.global }.set
    }
    
    internal init(from results: [DiffResult]) {
        let output = results.reduce(into: (removed: [Int](), inserted: [Int](), moved: [SwappedIndexPair]())) { (output, result) in
            switch result {
            case .removed(let i):
                output.removed.append(i)
            case .inserted(let i):
                output.inserted.append(i)
            case let .moved(g, l):
                output.moved.append(SwappedIndexPair(g: g, l: l))
            }
        }
        
        self.removedIndices = output.removed
        self.insertedIndices = output.inserted
        self.movedIndexPair = output.moved
    }
    
    internal init(removedIndices: [Int] = [], insertedIndices: [Int] = [], movedIndices: [SwappedIndexPair] = []) {
        self.removedIndices = removedIndices
        self.insertedIndices = insertedIndices
        self.movedIndexPair = movedIndices
    }
}
