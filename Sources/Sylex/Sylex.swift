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

postfix operator %
postfix operator ++
postfix operator --

infix operator **: ExponentationPrecedence
infix operator <?>

infix operator ..: MapOperatorPrecedence

public func ..<T, R>(lhs: T, rhs: (T) throws -> (R)) rethrows -> R { return try rhs(lhs) }
public func ..<T, R>(lhs: T?, rhs: (T?) throws -> (R)) rethrows -> R { return try rhs(lhs) }
public func ..<T, R>(lhs: T, rhs: (T) throws -> (R?)) rethrows -> R? { return try rhs(lhs) }
public func ..<T, R>(lhs: T?, rhs: (T?) throws -> (R?)) rethrows -> R? { return try rhs(lhs) }

public func ..<T, R>(lhs: T, rhs: ((T) throws -> (R))?) rethrows -> R? { return try rhs?(lhs) }
public func ..<T, R>(lhs: T?, rhs: ((T?) throws -> (R))?) rethrows -> R? { return try rhs?(lhs) }
public func ..<T, R>(lhs: T, rhs: ((T) throws -> (R?))?) rethrows -> R? { return try rhs?(lhs) }
public func ..<T, R>(lhs: T?, rhs: ((T?) throws -> (R?))?) rethrows -> R? { return try rhs?(lhs) }

public func clamp<T: Comparable>(_ x: T, _ min: T, _ max: T) -> T {
    return Swift.min(Swift.max(x, min), max)
}

public func <?><T>(lhs: Any?, rhs: T) -> T { return lhs as? T ?? rhs }

public func log(_ value: Any) {
    Swift.print(value)
}
