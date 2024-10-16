//
//  File.swift
//  
//
//  Created by Pierre Tacchi on 21/12/21.
//

import Foundation

@available(*, deprecated)
@dynamicMemberLookup
public protocol DynamicProxy {
    associatedtype Proxied
    
    var subject: Proxied { get }
}

@available(*, deprecated)
public extension DynamicProxy {
    @inlinable subscript<T>(dynamicMember k: KeyPath<Proxied, T>) -> T {
        subject[keyPath: k]
    }
}

