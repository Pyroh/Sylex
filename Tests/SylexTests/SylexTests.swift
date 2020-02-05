import XCTest
@testable import Sylex

typealias S = SwappedIndexPair

final class SylexTests: XCTestCase {
    func test() {
        func times2(value: Int) -> Int {
            return value * 2
        }
        
        1..log
    }
    
    func testBinaryIntegerPrefix() {
        var i: Int = 0
        XCTAssertEqual(++i, 1)
        XCTAssertEqual(i, 1)
        XCTAssertEqual(--i, 0)
        XCTAssertEqual(i, 0)
        
        XCTAssertEqual(1 + ++i, 2)
        XCTAssertEqual(i, 1)
        XCTAssertEqual(1 + --i, 1)
        XCTAssertEqual(i, 0)
    }
    
    func testBinaryFloatingPointPrefix() {
        var i: CGFloat = 0.0
        XCTAssertEqual(++i, 1.0)
        XCTAssertEqual(i, 1.0)
        XCTAssertEqual(--i, 0.0)
        XCTAssertEqual(i, 0.0)
        
        XCTAssertEqual(1.0 + ++i, 2.0)
        XCTAssertEqual(i, 1.0)
        XCTAssertEqual(1.0 + --i, 1.0)
        XCTAssertEqual(i, 0.0)
    }
    
    func testBinaryIntegerPostfix() {
        var i: Int = 0
        XCTAssertEqual(i++, 0)
        XCTAssertEqual(i, 1)
        XCTAssertEqual(i--, 1)
        XCTAssertEqual(i, 0)
        
        XCTAssertEqual(1 + i++, 1)
        XCTAssertEqual(i, 1)
        XCTAssertEqual(1 + i--, 2)
        XCTAssertEqual(i, 0)
    }
    
    func testBinaryFloatingPointPostfix() {
        var i: CGFloat = 0.0
        XCTAssertEqual(i++, 0.0)
        XCTAssertEqual(i, 1.0)
        XCTAssertEqual(i--, 1.0)
        XCTAssertEqual(i, 0.0)
        
        XCTAssertEqual(1.0 + i++, 1.0)
        XCTAssertEqual(i, 1.0)
        XCTAssertEqual(1.0 + i--, 2.0)
        XCTAssertEqual(i, 0.0)
    }
    
    func testExpononentBinaryInteger() {
        let i: Int = 2
        
        XCTAssertEqual(i ** 3, 8)
        XCTAssertEqual(i ** 3 + 2, 10)
        XCTAssertEqual(i ** 0, 1)
        
        XCTAssertEqual(i ** 3.0, 8)
        XCTAssertEqual(i ** 3.0 + 2, 10)
        XCTAssertEqual(i ** 0.0, 1)
    }
    
    func testExpononentBinaryFloatingPoint() {
        let i: CGFloat = 2
        
        XCTAssertEqual(i ** 3, 8)
        XCTAssertEqual(i ** 3 + 2, 10)
        XCTAssertEqual(i ** 0, 1)
        
        XCTAssertEqual(i ** 3.0, 8)
        XCTAssertEqual(i ** 3.0 + 2, 10)
        XCTAssertEqual(i ** 0.0, 1)
        
        XCTAssertEqual(2.5 ** 3.4, pow(2.5, 3.4))
    }
    
    func testMapOperators() {
        func add2(a: Int) -> Int { return a + 2 }
        func mayAdd2(a: Int) -> Int? {
            guard a > 0 else { return nil }
            return a + 2
        }
        func alwaysAdd2(a: Int?) -> Int {
            guard let value = a else { return 2 }
            return value + 2
        }
        func sometimesAdd2(a: Int?) -> Int? {
            guard let value = a else { return nil }
            return value + 2
        }
        
        XCTAssertEqual(1..add2, 3)
        XCTAssertEqual(1..mayAdd2, 3)
        XCTAssertEqual(0..mayAdd2, nil)
        XCTAssertEqual(1..alwaysAdd2, 3)
        XCTAssertEqual((nil as Int?)..alwaysAdd2, 2)
        XCTAssertEqual((1 as Int?)..sometimesAdd2, 3)
        XCTAssertEqual((nil as Int?)..sometimesAdd2, nil)
        XCTAssertEqual(1..add2..mayAdd2..alwaysAdd2..sometimesAdd2, 9)
        
        var i: Int? = nil
        var j = i..sometimesAdd2(a:)
        
        XCTAssert(i.isNil)
        XCTAssert(j.isNil)
        
        i = 42
        j = i..sometimesAdd2(a:)
        
        XCTAssert(i == 42)
        XCTAssert(j == 44)
    }
    
    func testOptionals() {
        let a: Int? = 1
        let b: Int? = nil
        var c: Int? = 1
        
        XCTAssertTrue(!!a)
        XCTAssertFalse(!!b)
        XCTAssertTrue(!!c)
        
        XCTAssertFalse(a.isNil)
        XCTAssertTrue(b.isNil)
        XCTAssertFalse(c.isNil)
        
        c.nilify()
        
        XCTAssertTrue(c.isNil)
        XCTAssertFalse(!!c)
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

    static var allTests = [
        ("testBinaryIntegerPrefix", testBinaryIntegerPrefix),
        ("testBinaryFloatingPointPrefix", testBinaryFloatingPointPrefix),
        ("testBinaryIntegerPostfix", testBinaryIntegerPostfix),
        ("testBinaryFloatingPointPostfix", testBinaryFloatingPointPostfix),
        ("testExpononentBinaryInteger", testExpononentBinaryInteger),
        ("testExpononentBinaryFloatingPoint", testExpononentBinaryFloatingPoint),
        ("testMapOperators", testMapOperators)
    ]
}
