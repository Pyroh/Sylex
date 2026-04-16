//
//  CharacterSetExtension.swift
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

public extension CharacterSet {
    /// A character set containing the hexadecimal digits (0-9, a-f, A-F).
    static var hexaDecimal: CharacterSet {
        CharacterSet(charactersIn: "0123456789abcdefABCDEF")
    }
    
    /// Returns a Boolean value indicating whether the character set contains the given character.
    ///
    /// This method checks if all Unicode scalars of the character are present in the character set.
    /// For characters composed of multiple Unicode scalars, all scalars must be present for the method to return `true`.
    ///
    /// - Parameter c: The character to check for membership.
    /// - Returns: `true` if all Unicode scalars of the character are in the set; otherwise, `false`.
    ///   Returns `false` for empty characters.
    func contains(_ c: Character) -> Bool {
        let scalars = c.unicodeScalars
        guard !scalars.isEmpty else { return false }
        
        for scalar in scalars {
            guard self.contains(scalar) else { return false }
        }
        
        return true
    }
    
    /// Returns a Boolean value indicating whether the character set contains all characters in the given string.
    ///
    /// This method iterates through each character in the string and verifies that the character set contains it.
    /// If any character is not found in the set, the method returns `false`.
    ///
    /// - Parameter s: The string whose characters should be checked for membership.
    /// - Returns: `true` if all characters in the string are in the set; otherwise, `false`.
    ///   Returns `true` for an empty string.
    func contains(_ s: String) -> Bool {        
        for char in s { guard contains(char) else { return false } }
        
        return true
    }
    
    /// Returns a new character set formed by adding the characters in the given string to this character set.
    ///
    /// - Parameter str: A string whose characters should be added to the character set.
    /// - Returns: A new character set containing the union of this set and the characters in `str`.
    func union(_ str: String) -> CharacterSet {
        self.union(CharacterSet(charactersIn: str))
    }
}

// MARK: - String Literal Conformance

/// Allows `CharacterSet` to be expressed using extended grapheme cluster literals.
///
/// This conformance enables you to create character sets from single-character literals:
/// ```swift
/// let questionMark: CharacterSet = "?"
/// ```
extension CharacterSet: @retroactive ExpressibleByExtendedGraphemeClusterLiteral {}

/// Allows `CharacterSet` to be expressed using Unicode scalar literals.
///
/// This conformance enables you to create character sets from Unicode scalar literals:
/// ```swift
/// let newline: CharacterSet = "\n"
/// ```
extension CharacterSet: @retroactive ExpressibleByUnicodeScalarLiteral {}

/// Allows `CharacterSet` to be expressed using string literals.
///
/// This conformance enables you to create character sets directly from string literals:
/// ```swift
/// let vowels: CharacterSet = "aeiou"
/// ```
extension CharacterSet: @retroactive ExpressibleByStringLiteral {
    public typealias StringLiteralType = String
    
    public init(stringLiteral value: CharacterSet.StringLiteralType) {
        self.init(charactersIn: value)
    }
}

// MARK: - Pattern Matching Operators

/// Pattern matching operator for checking if a character set contains a character.
///
/// This allows you to use character sets in pattern matching contexts:
/// ```swift
/// let char: Character = "a"
/// if CharacterSet.letters ~= char {
///     print("It's a letter!")
/// }
/// ```
///
/// - Parameters:
///   - lhs: The character set to check membership in.
///   - rhs: The character to check for membership.
/// - Returns: `true` if the character set contains the character; otherwise, `false`.
public func ~=(lhs: CharacterSet, rhs: Character) -> Bool {
    return lhs.contains(rhs)
}

/// Pattern matching operator for checking if one character set is a subset of another.
///
/// This allows you to use character sets in pattern matching contexts:
/// ```swift
/// let digits = CharacterSet.decimalDigits
/// if CharacterSet.alphanumerics ~= digits {
///     print("Digits are a subset of alphanumerics")
/// }
/// ```
///
/// - Parameters:
///   - lhs: The character set that should contain the subset.
///   - rhs: The character set to check as a potential subset.
/// - Returns: `true` if `rhs` is a subset of `lhs`; otherwise, `false`.
public func ~=(lhs: CharacterSet, rhs: CharacterSet) -> Bool {
    return rhs.isSubset(of: lhs)
}

// MARK: - Set Operations

/// Returns the union of two character sets.
///
/// This operator provides a convenient syntax for combining character sets:
/// ```swift
/// let vowels: CharacterSet = "aeiou"
/// let consonants: CharacterSet = "bcdfghjklmnpqrstvwxyz"
/// let letters = vowels + consonants
/// ```
///
/// - Parameters:
///   - lhs: The first character set.
///   - rhs: The second character set.
/// - Returns: A new character set containing all characters from both sets.
public func +(lhs: CharacterSet, rhs: CharacterSet) -> CharacterSet {
    return lhs.union(rhs)
}

/// Returns the union of a character set and characters from a string.
///
/// This operator provides a convenient syntax for adding string characters to a character set:
/// ```swift
/// let digits = CharacterSet.decimalDigits
/// let digitsWithDot = digits + "."
/// ```
///
/// - Parameters:
///   - lhs: The character set.
///   - rhs: A string whose characters should be added to the set.
/// - Returns: A new character set containing all characters from the set and the string.
public func +(lhs: CharacterSet, rhs: String) -> CharacterSet {
    lhs + CharacterSet(charactersIn: rhs)
}

/// Returns the difference of two character sets.
///
/// This operator provides a convenient syntax for subtracting one character set from another:
/// ```swift
/// let alphanumerics = CharacterSet.alphanumerics
/// let letters = alphanumerics - CharacterSet.decimalDigits
/// ```
///
/// - Parameters:
///   - lhs: The character set to subtract from.
///   - rhs: The character set to subtract.
/// - Returns: A new character set containing characters in `lhs` that are not in `rhs`.
public func -(lhs: CharacterSet, rhs: CharacterSet) -> CharacterSet {
    return lhs.subtracting(rhs)
}

/// Returns the difference of a character set and characters from a string.
///
/// This operator provides a convenient syntax for removing string characters from a character set:
/// ```swift
/// let vowels: CharacterSet = "aeiou"
/// let consonantsOnly = CharacterSet.letters - "aeiou"
/// ```
///
/// - Parameters:
///   - lhs: The character set to subtract from.
///   - rhs: A string whose characters should be removed from the set.
/// - Returns: A new character set containing characters in `lhs` that are not in `rhs`.
public func -(lhs: CharacterSet, rhs: String) -> CharacterSet {
    lhs - CharacterSet(charactersIn: rhs)
}
