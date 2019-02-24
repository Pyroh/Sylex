/// Returns the lesser between `max` and the higher between `x` and `min`.
prefix operator ++
prefix operator --

postfix operator %
postfix operator ++
postfix operator --

infix operator **: BitwiseShiftPrecedence
infix operator <?>

public func clamp<T: Comparable>(_ x: T, _ min: T, _ max: T) -> T {
    return Swift.min(Swift.max(x, min), max)
}

public func <?><T>(lhs: Any?, rhs: T) -> T { return lhs as? T ?? rhs }
