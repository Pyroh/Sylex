//
//  DiffEntryKind.swift
//  Sylex
//
//  Created by Pierre TACCHI on 22/08/2018.
//

import Foundation

enum DiffEntryKind {
    case pointer(AnyHashable)
    case index(Int)
}

extension DiffEntryKind: CustomStringConvertible {
    var description: String {
        switch self {
        case let .pointer(hash):
            return "pointer \(hash)"
        case let .index(i):
            return "index \(i)"
        }
    }
}
