//
//  File.swift
//  Sylex
//
//  Created by Pierre TACCHI on 22/08/2018.
//

internal struct ArrayDiff {
    private var symbolTable: [AnyHashable: DiffTableEntry]
    
    private var sourceReferences: [DiffEntryKind]
    private var targetReferences: [DiffEntryKind]
    
    init<T: Hashable>(source: [T], target: [T]) {
        var table = [AnyHashable: DiffTableEntry]()
        
        let oa = source.lazy.map(AnyHashable.init).enumerated().map { (i, item) -> DiffEntryKind in
            let entry: DiffTableEntry = table[item] ?? .init()
            entry.registerSource(i)
            table[item] = entry
            return .pointer(item)
        }
        
        let na = target.map(AnyHashable.init).map { (item) -> DiffEntryKind in
            let entry: DiffTableEntry = table[item] ?? .init()
            entry.registerTarget()
            table[item] = entry
            return .pointer(item)
        }
        
        self.symbolTable = table
        self.sourceReferences = oa
        self.targetReferences = na
    }
    
    mutating func computeDiff() -> [DiffResult] {
        self.pass3()
        self.pass4()
        self.pass5()
        
        let resultSource = self.sourceReferences.lazy.enumerated().compactMap { (i, entry) -> DiffResult? in
            guard case .pointer(_) = entry else { return nil }
            return .removed(i)
        }
        
        let resultTarget = self.targetReferences.lazy.enumerated().compactMap { (i, entry) -> DiffResult? in
            switch entry {
            case .index(let index):
                guard i != index else { return nil }
                return .moved(from: index, to: i)
            case .pointer(_):
                return .inserted(i)
            }
        }
        
        return resultSource + resultTarget
    }
    
    private mutating func pass3() {
        self.targetReferences = self.targetReferences.enumerated().map { (i, item) -> DiffEntryKind in
            guard case let .pointer(id) = item,
                let entry = self.symbolTable[id], entry.holdsUniqueReference else { return item }
            
            let j = entry.consume()
            self.sourceReferences[j] = .index(i)
            return .index(j)
        }
    }
    
    private mutating func pass4() {
        let srefc = self.sourceReferences.count
        let trefc = self.targetReferences.count
        
        (0..<trefc).forEach { i in
            if case let .index(j) = self.targetReferences[i], j + 1 < srefc, i + 1 < trefc,
                case let .pointer(nh) = self.targetReferences[i+1],
                case let .pointer(oh) = self.sourceReferences[j+1],
                nh.hashValue == oh.hashValue {
                self.targetReferences[i+1] = .index(j+1)
                self.sourceReferences[j+1] = .index(i+1)
            }
        }
    }
    
    private mutating func pass5() {
        (0..<self.targetReferences.count).lazy.reversed().forEach { i in
            if case let .index(j) = self.targetReferences[i], j - 1 >= 0, i - 1 >= 0,
                case let .pointer(nh) = self.targetReferences[i-1],
                case let .pointer(oh) = self.sourceReferences[j-1],
                nh.hashValue == oh.hashValue {
                self.targetReferences[i-1] = .index(j-1)
                self.sourceReferences[j-1] = .index(i-1)
            }
        }
    }
}
