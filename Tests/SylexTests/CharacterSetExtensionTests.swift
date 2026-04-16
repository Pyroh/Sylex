//
//  CharacterSetExtensionTests.swift
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

import Testing
import Foundation

@testable import Sylex

@Suite("CharacterSet Extension Tests")
struct CharacterSetExtensionTests {
    
    // MARK: - Hexadecimal CharacterSet Tests
    
    @Test("Hexadecimal character set contains valid hex digits")
    func hexaDecimalContainsValidDigits() {
        let hexSet = CharacterSet.hexaDecimal
        
        // Test lowercase hex digits
        #expect(hexSet.contains("a"))
        #expect(hexSet.contains("f"))
        
        // Test uppercase hex digits
        #expect(hexSet.contains("A"))
        #expect(hexSet.contains("F"))
        
        // Test numeric digits
        #expect(hexSet.contains("0"))
        #expect(hexSet.contains("9"))
    }
    
    @Test("Hexadecimal character set excludes invalid characters")
    func hexaDecimalExcludesInvalidCharacters() {
        let hexSet = CharacterSet.hexaDecimal
        
        #expect(!hexSet.contains("g"))
        #expect(!hexSet.contains("Z"))
        #expect(!hexSet.contains("@"))
        #expect(!hexSet.contains(" "))
    }
    
    @Test("Hexadecimal character set validates full hex string")
    func hexaDecimalValidatesHexString() {
        let hexSet = CharacterSet.hexaDecimal
        
        #expect(hexSet.contains("DEADBEEF"))
        #expect(hexSet.contains("123456789"))
        #expect(hexSet.contains("aBcDeF"))
        #expect(!hexSet.contains("NOTAHEX"))
        #expect(!hexSet.contains("12G45"))
    }
    
    // MARK: - Contains Character Tests
    
    @Test("Contains method works with single characters")
    func containsSingleCharacter() {
        let vowels: CharacterSet = "aeiou"
        
        #expect(vowels.contains("a"))
        #expect(vowels.contains("e"))
        #expect(!vowels.contains("b"))
        #expect(!vowels.contains("z"))
    }
    
    @Test("Contains method works with multi-scalar characters")
    func containsMultiScalarCharacter() {
        // Create a set containing just the thumbs up emoji (no skin tone)
        let thumbsUpSet = CharacterSet(charactersIn: "👍")
        let thumbsUp: Character = "👍"
        
        // Should contain the base emoji
        #expect(thumbsUpSet.contains(thumbsUp))
        
        // Now test with skin tone modifier
        // When we create a set with a modified emoji, it contains all those scalars
        let modifiedSet = CharacterSet(charactersIn: "👍🏽")
        let thumbsUpWithTone: Character = "👍🏽"
        
        // The character with skin tone requires both base + modifier scalars
        // Since modifiedSet was created with the full modified emoji, it has both
        #expect(modifiedSet.contains(thumbsUpWithTone))
        
        // But the base thumbsUp only has one scalar, which IS in modifiedSet
        // so this should pass
        #expect(modifiedSet.contains(thumbsUp))
    }
    
    @Test("Contains method handles combining characters")
    func containsCombiningCharacters() {
        // é can be composed or decomposed
        let accentSet = CharacterSet(charactersIn: "é")
        
        let composedE: Character = "é"  // Single Unicode scalar
        #expect(accentSet.contains(composedE))
    }
    
    // MARK: - Contains String Tests
    
    @Test("Contains string method validates all characters")
    func containsStringValidatesAllCharacters() {
        let digits = CharacterSet.decimalDigits
        
        #expect(digits.contains("12345"))
        #expect(digits.contains("0"))
        #expect(!digits.contains("12a45"))
        #expect(!digits.contains("abc"))
    }
    
    @Test("Contains string method returns true for empty string")
    func containsEmptyString() {
        let anySet = CharacterSet.letters
        // Empty string should return true (vacuous truth: all zero characters are in the set)
        #expect(anySet.contains(""))
    }
    
    @Test("Contains string method works with mixed content")
    func containsMixedString() {
        let alphanumeric = CharacterSet.alphanumerics
        
        #expect(alphanumeric.contains("abc123"))
        #expect(alphanumeric.contains("ABC"))
        #expect(!alphanumeric.contains("abc-123"))
        #expect(!alphanumeric.contains("hello!"))
    }
    
    // MARK: - Union with String Tests
    
    @Test("Union with string adds characters correctly")
    func unionWithString() {
        let digits = CharacterSet.decimalDigits
        let digitsWithDot = digits.union(".")
        
        #expect(digitsWithDot.contains("5"))
        #expect(digitsWithDot.contains("."))
        #expect(!digitsWithDot.contains("a"))
    }
    
    @Test("Union with string adds multiple characters")
    func unionWithMultipleCharacters() {
        let letters = CharacterSet.letters
        let extended = letters.union("@#$")
        
        #expect(extended.contains("a"))
        #expect(extended.contains("@"))
        #expect(extended.contains("#"))
        #expect(extended.contains("$"))
    }
    
    // MARK: - String Literal Conformance Tests
    
    @Test("CharacterSet can be created from string literal")
    func createFromStringLiteral() {
        let vowels: CharacterSet = "aeiou"
        
        #expect(vowels.contains("a"))
        #expect(vowels.contains("e"))
        #expect(!vowels.contains("b"))
    }
    
    @Test("CharacterSet can be created from single character literal")
    func createFromSingleCharacter() {
        let dot: CharacterSet = "."
        
        #expect(dot.contains("."))
        #expect(!dot.contains(","))
    }
    
    @Test("CharacterSet can be created from Unicode scalar literal")
    func createFromUnicodeScalar() {
        let newline: CharacterSet = "\n"
        
        #expect(newline.contains("\n"))
        #expect(!newline.contains(" "))
    }
    
    // MARK: - Pattern Matching Operator Tests
    
    @Test("Pattern matching with character works")
    func patternMatchingCharacter() {
        let char: Character = "a"
        
        #expect(CharacterSet.letters ~= char)
        #expect(!(CharacterSet.decimalDigits ~= char))
    }
    
    @Test("Pattern matching with character in switch statement")
    func patternMatchingInSwitch() {
        let testChar: Character = "5"
        var matched = false
        
        switch testChar {
        case CharacterSet.decimalDigits:
            matched = true
        default:
            matched = false
        }
        
        #expect(matched)
    }
    
    @Test("Pattern matching with character set works")
    func patternMatchingCharacterSet() {
        let digits = CharacterSet.decimalDigits
        
        #expect(CharacterSet.alphanumerics ~= digits)
        #expect(!(digits ~= CharacterSet.alphanumerics))
    }
    
    @Test("Pattern matching verifies subset relationship")
    func patternMatchingSubset() {
        let vowels: CharacterSet = "aeiou"
        let letters = CharacterSet.letters
        
        #expect(letters ~= vowels)
        #expect(!(vowels ~= letters))
    }
    
    // MARK: - Addition Operator Tests
    
    @Test("Addition operator combines two character sets")
    func additionCombinesSets() {
        let vowels: CharacterSet = "aeiou"
        let consonants: CharacterSet = "bcdfg"
        let combined = vowels + consonants
        
        #expect(combined.contains("a"))
        #expect(combined.contains("b"))
        #expect(combined.contains("e"))
        #expect(combined.contains("f"))
    }
    
    @Test("Addition operator with string adds characters")
    func additionWithString() {
        let digits = CharacterSet.decimalDigits
        let extended = digits + ".,+-"
        
        #expect(extended.contains("5"))
        #expect(extended.contains("."))
        #expect(extended.contains(","))
        #expect(extended.contains("+"))
        #expect(extended.contains("-"))
    }
    
    @Test("Chained addition operators work")
    func chainedAddition() {
        let set1: CharacterSet = "abc"
        let set2: CharacterSet = "123"
        let set3: CharacterSet = "!@#"
        let combined = set1 + set2 + set3
        
        #expect(combined.contains("a"))
        #expect(combined.contains("1"))
        #expect(combined.contains("!"))
    }
    
    // MARK: - Subtraction Operator Tests
    
    @Test("Subtraction operator removes characters")
    func subtractionRemovesCharacters() {
        let alphanumerics = CharacterSet.alphanumerics
        let letters = alphanumerics - CharacterSet.decimalDigits
        
        #expect(letters.contains("a"))
        #expect(letters.contains("Z"))
        #expect(!letters.contains("5"))
        #expect(!letters.contains("0"))
    }
    
    @Test("Subtraction operator with string removes characters")
    func subtractionWithString() {
        let letters = CharacterSet.letters
        let consonants = letters - "aeiouAEIOU"
        
        #expect(consonants.contains("b"))
        #expect(consonants.contains("Z"))
        #expect(!consonants.contains("a"))
        #expect(!consonants.contains("E"))
    }
    
    @Test("Chained subtraction operators work")
    func chainedSubtraction() {
        let alphanumerics = CharacterSet.alphanumerics
        let result = alphanumerics - CharacterSet.decimalDigits - "xyz"
        
        #expect(result.contains("a"))
        #expect(!result.contains("5"))
        #expect(!result.contains("x"))
        #expect(!result.contains("y"))
    }
    
    @Test("Subtraction from empty result")
    func subtractionToEmpty() {
        let vowels: CharacterSet = "aeiou"
        let empty = vowels - "aeiou"
        
        #expect(!empty.contains("a"))
        #expect(!empty.contains("e"))
        #expect(empty.isEmpty)
    }
    
    // MARK: - Combined Operations Tests
    
    @Test("Combined addition and subtraction operations")
    func combinedOperations() {
        let base: CharacterSet = "abcdefghijklmnopqrstuvwxyz"
        let result = (base + "123") - "aeiou"
        
        #expect(result.contains("b"))
        #expect(result.contains("1"))
        #expect(!result.contains("a"))
        #expect(!result.contains("e"))
    }
    
    @Test("Complex character set construction")
    func complexConstruction() {
        // Build a set for valid identifier characters (letters, digits, underscore)
        let identifierChars = CharacterSet.alphanumerics + "_"
        
        #expect(identifierChars.contains("a"))
        #expect(identifierChars.contains("Z"))
        #expect(identifierChars.contains("5"))
        #expect(identifierChars.contains("_"))
        #expect(!identifierChars.contains("-"))
    }
    
    // MARK: - Edge Cases
    
    @Test("Empty character set operations")
    func emptyCharacterSetOperations() {
        let empty = CharacterSet()
        
        #expect(!empty.contains("a"))
        // Empty string should return true even for empty set (vacuous truth)
        #expect(empty.contains(""))
        
        let extended = empty + "abc"
        #expect(extended.contains("a"))
    }
    
    @Test("Special character handling")
    func specialCharacters() {
        let special: CharacterSet = "!@#$%^&*()"
        
        #expect(special.contains("!"))
        #expect(special.contains("@"))
        #expect(special.contains("("))
        #expect(!special.contains("a"))
    }
    
    @Test("Whitespace character handling")
    func whitespaceHandling() {
        let whitespace: CharacterSet = " \t\n\r"
        
        #expect(whitespace.contains(" "))
        #expect(whitespace.contains("\t"))
        #expect(whitespace.contains("\n"))
        #expect(whitespace.contains("\r"))
        #expect(!whitespace.contains("a"))
    }
}
