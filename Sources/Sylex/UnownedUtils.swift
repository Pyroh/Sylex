//
//  File.swift
//  
//
//  Created by Pierre Tacchi on 22/06/22.
//

@inlinable public func withUnowned<T: AnyObject, Result>(_ object: T, _ m: @escaping (T) -> () -> Result) -> () -> Result {
    { [unowned object] () -> Result in m(object)() }
}

@inlinable public func withUnowned<T: AnyObject, A, Result>(_ object: T, _ m: @escaping (T) -> (A) -> Result) -> (A) -> Result {
    { [unowned object] a -> Result in m(object)(a) }
}

@inlinable public func withUnowned<T: AnyObject, A, B, Result>(_ object: T, _ m: @escaping (T) -> (A, B) -> Result) -> (A, B) -> Result {
    { [unowned object] a, b -> Result in m(object)(a, b) }
}

@inlinable public func withUnowned<T: AnyObject, A, B, C, Result>(_ object: T, _ m: @escaping (T) -> (A, B, C) -> Result) -> (A, B, C) -> Result {
    { [unowned object] a, b, c -> Result in m(object)(a, b, c) }
}

@inlinable public func withUnowned<T: AnyObject, A, B, C, D, Result>(_ object: T, _ m: @escaping (T) -> (A, B, C, D) -> Result) -> (A, B, C, D) -> Result {
    { [unowned object] a, b, c, d -> Result in m(object)(a, b, c, d) }
}

@inlinable public func withUnowned<T: AnyObject, A, B, C, D, E, Result>(_ object: T, _ m: @escaping (T) -> (A, B, C, D, E) -> Result) -> (A, B, C, D, E) -> Result {
    { [unowned object] a, b, c, d, e -> Result in m(object)(a, b, c, d, e) }
}

@inlinable public func withUnowned<T: AnyObject, A, B, C, D, E, F, Result>(_ object: T, _ m: @escaping (T) -> (A, B, C, D, E, F) -> Result) -> (A, B, C, D, E, F) -> Result {
    { [unowned object] a, b, c, d, e, f -> Result in m(object)(a, b, c, d, e, f) }
}

@inlinable public func withUnowned<T: AnyObject, A, B, C, D, E, F, G, Result>(_ object: T, _ m: @escaping (T) -> (A, B, C, D, E, F, G) -> Result) -> (A, B, C, D, E, F, G) -> Result {
    { [unowned object] a, b, c, d, e, f, g -> Result in m(object)(a, b, c, d, e, f, g) }
}

@inlinable public func withUnowned<T: AnyObject, A, B, C, D, E, F, G, H, Result>(_ object: T, _ m: @escaping (T) -> (A, B, C, D, E, F, G, H) -> Result) -> (A, B, C, D, E, F, G, H) -> Result {
    { [unowned object] a, b, c, d, e, f, g, h -> Result in m(object)(a, b, c, d, e, f, g, h) }
}

@inlinable public func withUnowned<T: AnyObject, A, B, C, D, E, F, G, H, I, Result>(_ object: T, _ m: @escaping (T) -> (A, B, C, D, E, F, G, H, I) -> Result) -> (A, B, C, D, E, F, G, H, I) -> Result {
    { [unowned object] a, b, c, d, e, f, g, h, i -> Result in m(object)(a, b, c, d, e, f, g, h, i) }
}

@inlinable public func withUnowned<T: AnyObject, A, B, C, D, E, F, G, H, I, J, Result>(_ object: T, _ m: @escaping (T) -> (A, B, C, D, E, F, G, H, I, J) -> Result) -> (A, B, C, D, E, F, G, H, I, J) -> Result {
    { [unowned object] a, b, c, d, e, f, g, h, i, j -> Result in m(object)(a, b, c, d, e, f, g, h, i, j) }
}
