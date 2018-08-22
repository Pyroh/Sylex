//
//  TableEntry.swift
//  Sylex
//
//  Created by Pierre TACCHI on 22/08/2018.
//

internal class DiffTableEntry {
    private var targetCount: Int = 0
    private var sourceCount: Int = 0
    
    private var sourceIndices: [Int] = []
    
    var canConsume: Bool {
        return self.targetCount > 0 && self.sourceCount > 0
    }
    
    var holdsUniqueReference: Bool {
        return self.targetCount == 1 && self.sourceCount == 1
    }
    
    func registerTarget() {
        self.targetCount++
    }
    
    func registerSource(_ i: Int) {
        self.sourceCount++
        self.sourceIndices.append(i)
    }
    
    func consume() -> Int {
        self.targetCount++
        self.sourceCount++
        
        return self.sourceIndices.removeFirst()
    }
}

extension DiffTableEntry: CustomDebugStringConvertible {
    var debugDescription: String {
        return "sCount \(self.sourceCount), tCount \(self.targetCount), indices \(self.sourceIndices)"
    }
}
