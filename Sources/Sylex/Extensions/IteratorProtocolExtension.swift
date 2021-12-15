//
//  File.swift
//  
//
//  Created by Pierre Tacchi on 03/06/21.
//

import Foundation

public extension IteratorProtocol {
    @inlinable func eraseToAnyIterator() -> AnyIterator<Element> { .init(self) }
}
