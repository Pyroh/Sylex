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
