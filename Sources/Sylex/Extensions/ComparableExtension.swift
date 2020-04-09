//
//  File.swift
//  
//
//  Created by Pierre TACCHI on 09/04/2020.
//

import Foundation

public extension Comparable {
    @inlinable
    func clamped(to range: ClosedRange<Self>) -> Self {
        Sylex.clamp(self, range.lowerBound, range.upperBound)
    }
    
    @inlinable
    mutating func clamp(to range: ClosedRange<Self>) {
        self = self.clamped(to: range)
    }
}
