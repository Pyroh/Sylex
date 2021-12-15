import Foundation


prefix operator ??

public typealias CompletionHandler = () -> Void
public typealias Callback<A> = (A) -> Void

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
