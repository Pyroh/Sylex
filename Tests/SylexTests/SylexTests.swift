import XCTest
@testable import Sylex

typealias S = SwappedIndexPair

final class SylexTests: XCTestCase {

    func testOptionals() {
        let a: Int? = 1
        let b: Int? = nil
        var c: Int? = 1
        
        XCTAssertFalse(a.isNil)
        XCTAssertTrue(b.isNil)
        XCTAssertFalse(c.isNil)
        
        c.nilify()
        
        XCTAssertTrue(c.isNil)
    }
    
    func testOptionalWrapping() {
        let a: Int? = 1
        let b: Int? = nil
        var c: Int? = 1
        var d: Int? = nil
        
        XCTAssert((a ?? b) == 1)
        XCTAssert((b ?? c) == 1)
        XCTAssert((b ?? d).isNil)
        
        c = b ?? c
        XCTAssert(a == 1)
        d = d ?? b
        XCTAssert(b.isNil)
    }
    
    func testTableEquality() {
        let a = Matrix(fromMultiDimensionalArray: [
            [1, 2 ,3],
            [4, 5, 6],
            [7, 8, 9]
        ])
        
        let b = Matrix(fromMultiDimensionalArray: [
            [1, 2 ,3],
            [4, 5, 6],
            [7, 8, 9]
        ])
        
        let c = Matrix(fromMultiDimensionalArray: [
            [4, 5, 6],
            [1, 2 ,3],
            [7, 8, 9]
        ])
        
        XCTAssert(a == b)
        XCTAssert(a != c)
    }
    
    func testRange() {
        let a = Range(startIndex: 0, count: 4)
        XCTAssert(a == 0..<4)
        XCTAssert(a.shifted(by: 1) == 1..<5)
        
        var b = Range(startIndex: 0, count: 4)
        XCTAssert(b == 0..<4)
        b.shift(by: 1)
        XCTAssert(b == 1..<5)
        
        let c = Range(startIndex: 0, count: 4)
        XCTAssert(c == 0..<4)
        XCTAssert(c.shifted(by: -1) == -1..<3)
        
        var d = Range(startIndex: 0, count: 4)
        XCTAssert(d == 0..<4)
        d.shift(by: -1)
        XCTAssert(d == -1..<3)
    }
    
    func testClosedRange() {
        let a = ClosedRange(startIndex: 0, count: 4)
        XCTAssert(a == 0...3)
        XCTAssert(a.shifted(by: 1) == 1...4)
        
        var b = ClosedRange(startIndex: 0, count: 4)
        XCTAssert(b == 0...3)
        b.shift(by: 1)
        XCTAssert(b == 1...4)
        
        let c = ClosedRange(startIndex: 0, count: 4)
        XCTAssert(c == 0...3)
        XCTAssert(c.shifted(by: -1) == -1...2)
        
        var d = ClosedRange(startIndex: 0, count: 4)
        XCTAssert(d == 0...3)
        d.shift(by: -1)
        XCTAssert(d == -1...2)
    }
    
    func testDataTableRotations() {
        let master1x3: [[Int]] = [
            [1],
            [2],
            [3]
        ]
        
        let left3x1: [[Int]] = [
            [1, 2, 3]
        ]
        
        let right3x1: [[Int]] = [
            [3, 2, 1]
        ]
        
        let table1x3 = Matrix(fromMultiDimensionalArray: master1x3)
        XCTAssert(table1x3.rotatedLeft().rows == left3x1)
        XCTAssert(table1x3.rotatedRight().rows == right3x1)
        
        let master3x2: [[Int]] = [
            [1, 2, 3],
            [4, 5, 6]
        ]
        
        let left2x3: [[Int]] = [
            [3, 6],
            [2, 5],
            [1, 4]
        ]
        
        let right2x3: [[Int]] = [
            [4, 1],
            [5, 2],
            [6, 3]
        ]
        
        let table3x2 = Matrix(fromMultiDimensionalArray: master3x2)
        XCTAssert(table3x2.rotatedLeft().rows == left2x3)
        XCTAssert(table3x2.rotatedRight().rows == right2x3)
        
        let master3x3: [[Int]] = [
            [1, 2, 3],
            [4, 5, 6],
            [7, 8, 9]
        ]
        
        let left3x3: [[Int]] = [
            [3, 6, 9],
            [2, 5, 8],
            [1, 4, 7]
        ]
        
        let right3x3: [[Int]] = [
            [7, 4, 1],
            [8, 5, 2],
            [9, 6, 3]
        ]
        
        let table3x3 = Matrix(fromMultiDimensionalArray: master3x3)
        XCTAssert(table3x3.rotatedLeft().rows == left3x3)
        XCTAssert(table3x3.rotatedRight().rows == right3x3)
    }
    
    func testDataTableFlips() {
        let master1x3: [[Int]] = [
            [1],
            [2],
            [3]
        ]
        
        let h1x3: [[Int]] = [
            [1],
            [2],
            [3]
        ]
        
        let v1x3: [[Int]] = [
            [3],
            [2],
            [1]
        ]
        
        let table1x3 = Matrix(fromMultiDimensionalArray: master1x3)
        XCTAssert(table1x3.horizontallyFlipped().rows == h1x3)
        XCTAssert(table1x3.verticallyFlipped().rows == v1x3)
        
        let master3x2: [[Int]] = [
            [1, 2, 3],
            [4, 5, 6]
        ]
        
        let h3x2: [[Int]] = [
            [3, 2, 1],
            [6, 5, 4]
        ]
        
        let v3x2: [[Int]] = [
            [4, 5, 6],
            [1, 2, 3]
        ]
        
        let table3x2 = Matrix(fromMultiDimensionalArray: master3x2)
        XCTAssert(table3x2.horizontallyFlipped().rows == h3x2)
        XCTAssert(table3x2.verticallyFlipped().rows == v3x2)
        
        let master3x3: [[Int]] = [
            [1, 2, 3],
            [4, 5, 6],
            [7, 8, 9]
        ]
        
        let h3x3: [[Int]] = [
            [3, 2, 1],
            [6, 5, 4],
            [9, 8, 7]
        ]
        
        let v3x3: [[Int]] = [
            [7, 8, 9],
            [4, 5, 6],
            [1, 2, 3]
        ]
        
        let table3x3 = Matrix(fromMultiDimensionalArray: master3x3)
        XCTAssert(table3x3.horizontallyFlipped().rows == h3x3)
        XCTAssert(table3x3.verticallyFlipped().rows == v3x3)
    }
    
    func testRounding() {
        let a = 1.321
        XCTAssert(a.rounded(digits: 2) == 1.32)
        XCTAssert(a.rounded(digits: 1) == 1.3)
        XCTAssert(a.rounded(digits: 0) == 1)
        
        var b = 1.321
        b.round(digits: 2)
        XCTAssert(b == 1.32)
        b.round(digits: 1)
        XCTAssert(b == 1.3)
        b.round(digits: 0)
        XCTAssert(b == 1)
    }

    static var allTests = [
        ("testTableEquality", testTableEquality),
    ]
}
