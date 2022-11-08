import Foundation

@_exported import CoreGeometry
@_exported import OptionalType
@_exported import SmoothOperators
@_exported import SwizzleIMD
@_exported import ZeroableProtocol

prefix operator ??

public typealias CompletionHandler = () -> Void
public typealias Callback<A> = (A) -> Void
public typealias CallbackDuo<A, B> = (A, B) -> Void
public typealias CallbackTrio<A, B, C> = (A, B, C) -> Void

@inlinable public func completion<A>(_ block: @escaping () -> ()) -> (A) -> () { { _ in block() } }
@inlinable public func completion<A, B>(_ block: @escaping () -> ()) -> (A, B) -> () { { _,_ in block() } }
@inlinable public func completion<A, B, C>(_ block: @escaping () -> ()) -> (A, B, C) -> () { { _,_,_ in block() } }
@inlinable public func completion<A, B, C, D>(_ block: @escaping () -> ()) -> (A, B, C, D) -> () { { _,_,_,_ in block() } }
@inlinable public func completion<A, B, C, D, E>(_ block: @escaping () -> ()) -> (A, B, C, D, E) -> () { { _,_,_,_,_ in block() } }
@inlinable public func completion<A, B, C, D, E, F>(_ block: @escaping () -> ()) -> (A, B, C, D, E, F) -> () { { _,_,_,_,_,_ in block() } }
@inlinable public func completion<A, B, C, D, E, F, G>(_ block: @escaping () -> ()) -> (A, B, C, D, E, F, G) -> () { { _,_,_,_,_,_,_ in block() } }
@inlinable public func completion<A, B, C, D, E, F, G, H>(_ block: @escaping () -> ()) -> (A, B, C, D, E, F, G, H) -> () { { _,_,_,_,_,_,_,_ in block() } }
@inlinable public func completion<A, B, C, D, E, F, G, H, I>(_ block: @escaping () -> ()) -> (A, B, C, D, E, F, G, H, I) -> () { { _,_,_,_,_,_,_,_,_ in block() } }
@inlinable public func completion<A, B, C, D, E, F, G, H, I, J>(_ block: @escaping () -> ()) -> (A, B, C, D, E, F, G, H, I, J) -> () { { _,_,_,_,_,_,_,_,_,_ in block() } }

@inlinable public func clamp<T: Comparable>(_ x: T, _ min: T, _ max: T) -> T {
    return Swift.min(Swift.max(x, min), max)
}

@inlinable public func address<T>(of object: T) -> Int {
    unsafeBitCast(object, to: Int.self)
}

@inlinable public func stride<I: BinaryInteger>(to bound: I) -> StrideTo<I> {
    stride(from: 0, to: bound, by: 1)
}

@inlinable public func stride<I: BinaryInteger>(through bound: I) -> StrideThrough<I> {
    stride(from: 0, through: bound, by: 1)
}

@inlinable public func withMutable<T>(_ subject: T, transform: (inout T) throws -> ()) rethrows -> T {
    var proxy = subject
    try transform(&proxy)
    
    return proxy
}

@inlinable public func copy<T, U>(_ subject: T, replacing keyPath: WritableKeyPath<T, U>, with value: U) -> T {
    withMutable(subject) { $0[keyPath: keyPath] = value }
}

@inlinable public func bridge<T: AnyObject>(_ object: T) -> UnsafeRawPointer {
    .init(Unmanaged.passUnretained(object).toOpaque())
}

@inlinable public func mutableBridge<T: AnyObject>(_ object: T) -> UnsafeMutableRawPointer {
    .init(mutating: bridge(object))
}

@inlinable public func bridge<T:AnyObject>(_ ptr: UnsafeRawPointer) -> T {
    Unmanaged.fromOpaque(ptr).takeUnretainedValue()
}

@inlinable public func mutableBridge<T: AnyObject>(_ ptr: UnsafeMutableRawPointer) -> T {
    bridge(UnsafeRawPointer(ptr))
}
