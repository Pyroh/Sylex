//
//  DiffResult.swift
//  Sylex
//
//  Created by Pierre TACCHI on 22/08/2018.
//

enum DiffResult {
    case removed(Int)
    case inserted(Int)
    case moved(global: (from: Int, to: Int), local: (from: Int, to: Int))
}

extension DiffResult: CustomStringConvertible {
    var description: String {
        switch self {
        case .inserted(let i):
            return "inserted \(i)"
        case .removed(let i):
            return "removed \(i)"
        case let .moved((i, j), (k, l)):
            return "moved global \(i) to \(j) local \(k) to \(l)"
        }
    }
}
