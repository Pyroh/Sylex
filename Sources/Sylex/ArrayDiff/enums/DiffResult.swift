//
//  DiffResult.swift
//  Sylex
//
//  Created by Pierre TACCHI on 22/08/2018.
//

enum DiffResult {
    case removed(Int)
    case inserted(Int)
    case moved(from: Int, to: Int)
}

extension DiffResult: CustomStringConvertible {
    var description: String {
        switch self {
        case .inserted(let i):
            return "inserted \(i)"
        case .removed(let i):
            return "removed \(i)"
        case let .moved(from: i, to: j):
            return "moved \(i) to \(j)"
        }
    }
}
