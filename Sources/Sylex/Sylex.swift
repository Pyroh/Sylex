
/// Returns the lesser between `max` and the higher between `x` and `min`.
public func clamp<T: Comparable>(_ x: T, _ min: T, _ max: T) -> T {
    return Swift.min(Swift.max(x, min), max)
}
