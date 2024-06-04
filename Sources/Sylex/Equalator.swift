//
//  Equalator.swift
//  Sylex
//
//  MIT License
//
//  Copyright (c) 2023 Pierre Tacchi
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

import Foundation

public struct Equalator<T> {
    public struct Unit {
        let equalator: (T, T) -> Bool
        
        init<E: Equatable>(_ key: KeyPath<T, E>) {
            self.equalator = { $0[keyPath: key] == $1[keyPath: key] }
        }
        
        func areEqual(_ lhs: T, _ rhs: T) -> Bool { equalator(lhs, rhs) }
    }
    
    let units: [Unit]
    
    func areEqual(_ lhs: T, _ rhs: T) -> Bool {
        for unit in units { guard unit.areEqual(lhs, rhs) else { return false } }
        
        return true
    }
}


@resultBuilder
public enum EqualatorBuilder {
    public static func buildExpression<T, E: Equatable>(_ key: KeyPath<T, E>) -> Equalator<T>.Unit {
        .init(key)
    }
    
    public static func buildBlock<T>(_ units: Equalator<T>.Unit...) -> [Equalator<T>.Unit] {
        units
    }
    
    public static func buildFinalResult<T>(_ units: [Equalator<T>.Unit]) -> Equalator<T> {
        .init(units: units)
    }
}

public func allKeysEqual<T>(between lhs: T,
                            and rhs: T,
                            @EqualatorBuilder _ equalator: () -> Equalator<T>) -> Bool {
    equalator().areEqual(lhs, rhs)
}
