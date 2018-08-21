import XCTest
@testable import Sylex

final class SylexTests: XCTestCase {
    func testBinaryIntegerPrefix() {
        var i: Int = 0
        XCTAssertEqual(++i, 0)
        XCTAssertEqual(i, 1)
        XCTAssertEqual(--i, 1)
        XCTAssertEqual(i, 0)
        
        XCTAssertEqual(1 + ++i, 1)
        XCTAssertEqual(i, 1)
        XCTAssertEqual(1 + --i, 2)
        XCTAssertEqual(i, 0)
    }
    
    func testBinaryFloatingPointPrefix() {
        var i: CGFloat = 0.0
        XCTAssertEqual(++i, 0.0)
        XCTAssertEqual(i, 1.0)
        XCTAssertEqual(--i, 1.0)
        XCTAssertEqual(i, 0.0)
        
        XCTAssertEqual(1.0 + ++i, 1.0)
        XCTAssertEqual(i, 1.0)
        XCTAssertEqual(1.0 + --i, 2.0)
        XCTAssertEqual(i, 0.0)
    }
    
    func testBinaryIntegerPostfix() {
        var i: Int = 0
        XCTAssertEqual(i++, 1)
        XCTAssertEqual(i, 1)
        XCTAssertEqual(i--, 0)
        XCTAssertEqual(i, 0)
        
        XCTAssertEqual(1 + i++, 2)
        XCTAssertEqual(i, 1)
        XCTAssertEqual(1 + i--, 1)
        XCTAssertEqual(i, 0)
    }
    
    func testBinaryFloatingPointPostfix() {
        var i: CGFloat = 0.0
        XCTAssertEqual(i++, 1.0)
        XCTAssertEqual(i, 1.0)
        XCTAssertEqual(i--, 0.0)
        XCTAssertEqual(i, 0.0)
        
        XCTAssertEqual(1.0 + i++, 2.0)
        XCTAssertEqual(i, 1.0)
        XCTAssertEqual(1.0 + i--, 1.0)
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

    static var allTests = [
        ("testBinaryIntegerPrefix", testBinaryIntegerPrefix),
        ("testBinaryFloatingPointPrefix", testBinaryFloatingPointPrefix)
    ]
}
