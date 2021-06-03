//
//  File.swift
//  
//
//  Created by Pierre Tacchi on 03/06/21.
//

import Foundation

public extension IteratorProtocol {
    func eraseToAnyIterator() -> AnyIterator<Element> { .init(self) }
}
