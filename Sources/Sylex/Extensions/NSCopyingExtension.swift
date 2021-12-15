//
//  NSCopyingExtension.swift
//  Le Tool
//
//  Created by Pierre Tacchi on 18/05/21.
//

import Foundation

public extension NSCopying {
    @inlinable func clone() -> Self { copy() as! Self }
}
