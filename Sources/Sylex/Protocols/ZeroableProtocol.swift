//
//  ZeroableProtocol.swift
//  Sylex
//


import Foundation
import SwiftUI
#if !os(macOS)
import CoreGraphics
#endif

public protocol Zeroable { static var zero: Self { get } }

// MARK: - Stdlib Related
extension Double: Zeroable { }
extension Float: Zeroable { }
extension Int: Zeroable { }
extension Int64: Zeroable { }
extension Int32: Zeroable { }
extension Int16: Zeroable { }
extension Int8: Zeroable { }
extension UInt: Zeroable { }
extension UInt64: Zeroable { }
extension UInt32: Zeroable { }
extension UInt16: Zeroable { }
extension UInt8: Zeroable { }

// MARK: - Core Graphics Related
extension CGFloat: Zeroable { }
extension CGPoint: Zeroable { }
extension CGRect: Zeroable { }
extension CGSize: Zeroable { }
extension CGVector: Zeroable { }

// MARK: - Foundation Related
extension NSRange: Zeroable {
    @inlinable
    public static var zero: NSRange { .init(location: 0, length: 0) }
}

// MARK: - UIKit Related
#if canImport(UIKit)
import UIKit

extension UIOffset: Zeroable { }
extension UIEdgeInsets: Zeroable { }
#if !os(watchOS)
extension UIFloatRange: Zeroable { }
#endif
extension NSDirectionalEdgeInsets: Zeroable { }
#endif

// MARK: - SwiftUI Related
#if canImport(SwiftUI)

extension Angle: Zeroable { }
extension AnimatablePair: Zeroable { }
extension EmptyAnimatableData: Zeroable { }
extension UnitPoint: Zeroable { }
#endif



