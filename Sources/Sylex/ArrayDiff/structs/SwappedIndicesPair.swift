//
//  SwitchedIndicesPair.swift
//  Sylex
//
//  Created by Pierre TACCHI on 23/08/2018.
//

public struct SwappedIndicesPair {
    public let from: Int
    public let to: Int
    
    internal init(from: Int, to: Int) {
        self.from = from
        self.to = to
    }
    
    public func reversed() -> SwappedIndicesPair {
        return SwappedIndicesPair(from: self.to, to: self.from)
    }
    
    public mutating func reverse() {
        self = self.reversed()
    }
}

extension SwappedIndicesPair: Equatable {}
