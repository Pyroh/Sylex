//
//  SwitchedIndicesPair.swift
//  Sylex
//
//  Created by Pierre TACCHI on 23/08/2018.
//

public struct SwappedIndicesPair {
    let from: Int
    let to: Int
    
    internal init(from: Int, to: Int) {
        self.from = from
        self.to = to
    }
    
    func reversed() -> SwappedIndicesPair {
        return SwappedIndicesPair(from: self.to, to: self.from)
    }
    
    mutating func reverse() {
        self = self.reversed()
    }
}

extension SwappedIndicesPair: Equatable {}
