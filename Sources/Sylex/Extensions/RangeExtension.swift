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
}
