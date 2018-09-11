//
//  SwitchedIndicesPair.swift
//  Sylex
//
//  Created by Pierre TACCHI on 23/08/2018.
//

public struct SwappedIndexPair: Hashable {
    public struct IndexPair: Hashable {
        public let from: Int
        public let to: Int
        
        public var isTopToBottom: Bool {
            return from < to
        }
        
        fileprivate init(pair: (from: Int, to: Int)) {
            self.from = pair.from
            self.to = pair.to
        }
        
        private init(from: Int, to: Int) {
            self.from = from
            self.to = to
        }
        
        public func reversed() -> IndexPair {
            return IndexPair(from: self.to, to: self.from)
        }
        
        public func hash(into hasher: inout Hasher) {
            let val = self.from + self.to
            hasher.combine(val)
        }
        
        public static func == (lhs: IndexPair, rhs: IndexPair) -> Bool {
            return  [lhs.from, lhs.to].sorted() == [rhs.from, rhs.to].sorted()
        }
    }
    
    public let global: IndexPair
    public let local: IndexPair
    
    internal init(g: (from: Int, to: Int), l: (from: Int, to: Int)) {
        self.global = IndexPair(pair: g)
        self.local = IndexPair(pair: l)
    }
}

extension SwappedIndexPair: CustomStringConvertible {
    public var description: String {
        return "global: \(self.global.from) to \(self.global.to), local: \(self.local.from) to \(self.local.to)"
    }
}
