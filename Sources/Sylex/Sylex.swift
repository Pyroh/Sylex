/// Returns the lesser between `max` and the higher between `x` and `min`.
precedencegroup MapOperatorPrecedence {
    associativity: left
    higherThan: MultiplicationPrecedence
}

postfix operator -
postfix operator +

infix operator <?>

public typealias CompletionHandler = () -> Void
public typealias Callback<A> = (A) -> Void

@inlinable
public func clamp<T: Comparable>(_ x: T, _ min: T, _ max: T) -> T {
    return Swift.min(Swift.max(x, min), max)
}

@inlinable
public func <?><T>(lhs: Any?, rhs: T) -> T { return lhs as? T ?? rhs }

@inlinable
public func address<T>(of object: T) -> Int {
    unsafeBitCast(object, to: Int.self)
}
