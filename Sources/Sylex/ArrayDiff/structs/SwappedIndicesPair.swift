//
//  SwitchedIndicesPair.swift
//  Sylex
//
//  Created by Pierre TACCHI on 23/08/2018.
//

public struct SwappedIndicesPair {
    public struct IndicesPair: Equatable {
        public let from: Int
        public let to: Int
        
        fileprivate init(pair: (from: Int, to: Int)) {
            self.from = pair.from
            self.to = pair.to
        }
        
        private init(from: Int, to: Int) {
            self.from = from
            self.to = to
        }
        
        public func reversed() -> IndicesPair {
            return IndicesPair(from: self.to, to: self.from)
        }
    }
    
    public let global: IndicesPair
    public let local: IndicesPair
    
    internal init(g: (from: Int, to: Int), l: (from: Int, to: Int)) {
        self.global = IndicesPair(pair: g)
        self.local = IndicesPair(pair: l)
    }
}

extension SwappedIndicesPair: Equatable {}

extension SwappedIndicesPair: CustomStringConvertible {
    public var description: String {
        return "global: \(self.global.from) to \(self.global.to), local: \(self.local.from) to \(self.local.to)"
    }
}
