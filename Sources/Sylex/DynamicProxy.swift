//
//  File.swift
//  
//
//  Created by Pierre Tacchi on 21/12/21.
//

import Foundation

@dynamicMemberLookup
public protocol DynamicProxy {
    associatedtype Proxied
    
    var subject: Proxied { get }
}

public extension DynamicProxy {
    @inlinable subscript<T>(dynamicMember k: KeyPath<Proxied, T>) -> T {
        subject[keyPath: k]
    }
}

