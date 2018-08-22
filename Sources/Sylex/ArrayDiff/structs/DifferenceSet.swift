//
//  DifferenceSet.swift
//  Sylex
//
//  Created by Pierre TACCHI on 22/08/2018.
//

import Foundation

public struct DifferenceSet {
    let removedIndices: [Int]
    let insertedIndices: [Int]
    let movedIndices: [(from: Int, to: Int)]
    
    var removedIndexSet: IndexSet {
        return IndexSet(self.removedIndices)
    }
    var insertedIndexSet: IndexSet {
        return IndexSet(self.insertedIndices)
    }
    
    internal init(from results: [DiffResult]) {
        let output = results.reduce(into: (removed: [Int](), inserted: [Int](), moved: [(Int, Int)]())) { (output, result) in
            switch result {
            case .removed(let i):
                output.removed.append(i)
            case .inserted(let i):
                output.inserted.append(i)
            case let .moved(i, j):
                output.moved.append((i, j))
            }
        }
        
        self.removedIndices = output.removed
        self.insertedIndices = output.inserted
        self.movedIndices = output.moved
    }
}
