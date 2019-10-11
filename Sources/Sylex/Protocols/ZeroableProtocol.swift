//
//  ZeroableProtocol.swift
//  Sylex
//
//  Created by Pierre TACCHI on 11/10/2019.
//

import Foundation
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
#if os(macOS)
extension Float80: Zeroable { }
#endif

// MARK: - Core Graphics Related
extension CGFloat: Zeroable { }
extension CGPoint: Zeroable { }
extension CGRect: Zeroable { }
extension CGSize: Zeroable { }
extension CGVector: Zeroable { }

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
import SwiftUI

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension Angle: Zeroable { }
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension AnimatablePair: Zeroable { }
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension EmptyAnimatableData: Zeroable { }
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension UnitPoint: Zeroable { }
#endif



