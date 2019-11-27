//
//  RangeExtension.swift
//  
//
//  Created by Pierre TACCHI on 18/10/2019.
//

public extension Range where Bound: Strideable {
    
    init(startIndex: Bound, count: Bound.Stride) {
        let endIndex = startIndex.advanced(by: count)
        self = .init(uncheckedBounds: (startIndex, endIndex))
    }
    
    mutating func shift(by amount: Bound.Stride) {
        self = self.shifted(by: amount)
    }
    
    func shifted(by amount: Bound.Stride) -> Range<Bound> {
        let lower = self.lowerBound.advanced(by: amount)
        let upper = self.upperBound.advanced(by: amount)
        
        return .init(uncheckedBounds: (lower, upper))
    }
}

public extension ClosedRange where Bound: Strideable {
    
    init(startIndex: Bound, count: Bound.Stride) {
        let endIndex = startIndex.advanced(by: count - 1)
        self = .init(uncheckedBounds: (startIndex, endIndex))
    }
    
    mutating func shift(by amount: Bound.Stride) {
        self = self.shifted(by: amount)
    }
    
    func shifted(by amount: Bound.Stride) -> ClosedRange<Bound> {
        let lower = self.lowerBound.advanced(by: amount)
        let upper = self.upperBound.advanced(by: amount)
        
        return .init(uncheckedBounds: (lower, upper))
    }
}
