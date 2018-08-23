import XCTest
@testable import Sylex

extension DifferenceSet: Equatable {
    public static func == (lhs: DifferenceSet, rhs: DifferenceSet) -> Bool {
        return lhs.removedIndices == rhs.removedIndices && lhs.insertedIndices == rhs.insertedIndices && lhs.movedIndices.count == rhs.movedIndices.count && lhs.movedIndices.lazy.reduce(into: true, { (res, item) in
            res = res && rhs.movedIndices.contains(item)
        })
    }
    
    public static func == (lhs: DifferenceSet, rhs: ([Int], [Int], [(from: Int, to: Int)])) -> Bool {
        var equals = lhs.removedIndices == rhs.0 && lhs.insertedIndices == rhs.1
        equals = equals && lhs.movedIndices.count == rhs.2.count
        
        return equals
    }
}

typealias S = SwappedIndicesPair

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
    
    func testArrayDiff() {
        let s0 = ["Hello", "World"]
        let t0 = ["World", "Hello"]
        let r0 = t0.diff(from: s0)
        let sb0 = DifferenceSet(movedIndices: [S(from: 1, to: 0), S(from: 0, to: 1)])
        XCTAssertEqual(r0, sb0)
        
        
        let s1 = [1, 2, 3, 4, 5]
        let t1 = [5, 4, 3, 2, 1]
        let r1 = t1.diff(from: s1)
        let sb1 = DifferenceSet(movedIndices: [S(from: 4, to: 0), S(from: 3, to: 1), S(from: 1, to: 3), S(from: 0, to: 4)])
        XCTAssertEqual(r1, sb1)
        
        let s2 = ["a", "b", "c", "d"]
        let t2 = ["a", "c", "d"]
        let r2 = t2.diff(from: s2)
        let sb2 = DifferenceSet(removedIndices: [1])
        XCTAssertEqual(r2, sb2)
        
        let s3 = ["a", "c", "d"]
        let t3 = ["a", "b", "c", "d"]
        let r3 = t3.diff(from: s3)
        let sb3 = DifferenceSet(insertedIndices: [1])
        XCTAssertEqual(r3, sb3)
        
        let s4 = [1, 2, 3, 4, 5]
        let t4 = [5, 3, 1]
        print(t4.diff(from: s4))
    }

    static var allTests = [
        ("testBinaryIntegerPrefix", testBinaryIntegerPrefix),
        ("testBinaryFloatingPointPrefix", testBinaryFloatingPointPrefix),
        ("testBinaryIntegerPostfix", testBinaryIntegerPostfix),
        ("testBinaryFloatingPointPostfix", testBinaryFloatingPointPostfix),
        ("testExpononentBinaryInteger", testExpononentBinaryInteger),
        ("testExpononentBinaryFloatingPoint", testExpononentBinaryFloatingPoint),
        ("testArrayDiff", testArrayDiff)
    ]
}
