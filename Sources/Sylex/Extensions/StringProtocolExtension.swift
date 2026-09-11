//
//  StringProtocolExtension.swift
//  Sylex
//
//  MIT License
//
//  Copyright (c) 2026 Pierre Tacchi
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

extension StringProtocol {
    private var string: String { String(self) }
    
    func filter(includeContentOf charSet: CharacterSet) -> [Character] {
        filter { charSet.contains($0) }
    }
    
    func filter(excludeContentOf charSet: CharacterSet) -> [Character] {
        filter { !charSet.contains($0) }
    }
    
    func snakeCase(uppercase: Bool = false, separator: Character = "_", keepPunctuation: Bool = false) -> String {
        let excludedCharacterSet: CharacterSet = keepPunctuation ?
            .controlCharacters + .nonBaseCharacters + .whitespacesAndNewlines :
            .controlCharacters + .nonBaseCharacters + .punctuationCharacters + .whitespacesAndNewlines
        var lastWasSeparator = false
        
        let chars = compactMap { char -> Character? in
            switch char {
            case excludedCharacterSet:
                guard !lastWasSeparator else { return nil }
                lastWasSeparator = true
                return separator
            default:
                lastWasSeparator = false
                return char
            }
        }
            .lazy
            .drop(while: { $0 == separator })
            .reversed()
            .drop(while: { $0 == separator })
            .reversed()
        
        let output = String(chars)
        return uppercase ? output.uppercased() : output.lowercased()
    }
    
    func camelCase(keepPunctuation: Bool = false) -> String {
        let words = snakeCase(separator: "\u{08}", keepPunctuation: keepPunctuation).split(separator: "\u{08}")
        return (words.prefix(1).map(String.init) + words.dropFirst().map { $0.firstLetterCapitalized() }).joined()
    }
    
    func breakCamelCase() -> String {
        map { $0.isUppercase ? " \($0)" : "\($0)" }.joined()
    }
    
    func kebabCase(uppercase: Bool = false) -> String {
        snakeCase(uppercase: uppercase).replacingOccurrences(of: "_", with: "-")
    }
    
    func pascalCase() -> String {
        snakeCase()
            .split(separator: "_")
            .map { $0.firstLetterCapitalized() }
            .joined()
    }
    
    func reversing() -> String {
        reversed().string
    }
    
    func reversingLines(removingEmptyLines flag: Bool = true) -> String {
        split(separator: "\n", omittingEmptySubsequences: flag).lazy.reversed().joined(separator: "\n")
    }
    
    func collapse(spaced: Bool = false) -> String {
        collapse(separator: spaced ? " " : "")
    }
    
    func collapse(separator: String? = nil) -> String {
        replacingOccurrences(of: "\n", with: separator ?? "")
    }
    
    func removeWhiteSpace(andNewlines flag: Bool = false) -> String {
        flag ?
        filter(excludeContentOf: .whitespacesAndNewlines).string :
        filter(excludeContentOf: .whitespaces).string
    }
    
    func removeEmptyLines() -> String {
        split(separator: "\n").joined(separator: "\n")
    }
    
    func trimmingWhitespace() -> String {
        trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    func sortLines(ascending: Bool = true, caseSensitive: Bool = true, locale: Locale? = nil) -> String {
        let expectedResult: ComparisonResult = ascending ? .orderedAscending : .orderedDescending
        let options: String.CompareOptions = caseSensitive ? [] : [.caseInsensitive]
        let comparator: (String, String) -> Bool = {
            $0.compare($1, options: options, locale: locale) == expectedResult
        }
        return split(separator: "\n").lazy
            .map { String($0) }
            .sorted(by: comparator)
            .joined(separator: "\n")
    }
    
    func firstLetterCapitalized(with locale: Locale? = nil) -> String {
        prefix(1).capitalized(with: locale) + dropFirst()
    }
}
