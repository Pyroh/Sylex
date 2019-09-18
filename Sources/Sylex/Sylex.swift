/// Returns the lesser between `max` and the higher between `x` and `min`.
precedencegroup MapOperatorPrecedence {
    associativity: left
    higherThan: MultiplicationPrecedence
}

precedencegroup ExponentationPrecedence {
    associativity: left
    higherThan: MultiplicationPrecedence
}

prefix operator ++
prefix operator --
prefix operator !!

postfix operator %
postfix operator ++
postfix operator --

infix operator **: ExponentationPrecedence
infix operator <?>

infix operator ..: MapOperatorPrecedence
infix operator .?: MapOperatorPrecedence

public typealias F<T, R> = (T) throws -> (R)
public typealias A<T, R> = (T?) throws -> (R)
public typealias M<T, R> = (T) throws -> (R?)
public typealias P<T, R> = (T?) throws -> (R?)

public func ..<T, R>(lhs: T, rhs: F<T, R>) rethrows -> R  { return try rhs(lhs) }
public func ..<T, R>(lhs: T?, rhs: A<T, R>) rethrows -> R { return try rhs(lhs) }
public func ..<T, R>(lhs: T, rhs: M<T, R>) rethrows -> R? { return try rhs(lhs) }
public func ..<T, R>(lhs: T?, rhs: P<T, R>) rethrows -> R? { return try rhs(lhs) }

public func .?<T, R>(lhs: T, rhs: F<T, R>?) rethrows -> R? { return try rhs?(lhs) }
public func .?<T, R>(lhs: T?, rhs: A<T, R>?) rethrows -> R? { return try rhs?(lhs) }
public func .?<T, R>(lhs: T, rhs: M<T, R>?) rethrows -> R? { return try rhs?(lhs) }
public func .?<T, R>(lhs: T?, rhs: P<T, R>?) rethrows -> R? { return try rhs?(lhs) }

public func clamp<T: Comparable>(_ x: T, _ min: T, _ max: T) -> T {
    return Swift.min(Swift.max(x, min), max)
}

public func <?><T>(lhs: Any?, rhs: T) -> T { return lhs as? T ?? rhs }

public func log(_ value: Any) {
    Swift.print(value)
}
