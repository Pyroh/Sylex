import XCTest
@testable import Sylex

struct SomethingIdentifiable: Identifiable, Hashable {
    let id: UUID = .init()
    let value: Int = (-1000...1000).randomElement()!
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

struct IntHolder {
    let value: Int
}

final class SylexTests: XCTestCase {
    let n = 2500
    let m = 300
    
    func testData() {
        //               0     1     2     3     4     5     6     7
        let data = Data([0x12, 0x34, 0x56, 0x78, 0x12, 0x34, 0x56, 0x78])
        XCTAssert(data.uint8() == 0x12)
        XCTAssert(data.uint8(at: 1) == 0x34)
        XCTAssert(data.uint8(at: 2) == 0x56)
        XCTAssert(data.uint8(at: 3) == 0x78)
        XCTAssert(data.uint8(at: 4) == 0x12)
        XCTAssert(data.uint8(at: 5) == 0x34)
        XCTAssert(data.uint8(at: 6) == 0x56)
        XCTAssert(data.uint8(at: 7) == 0x78)
        
        XCTAssert(data.uint16() == 0x3412)
        XCTAssert(data.uint16(at: 1) == 0x5634)
        XCTAssert(data.uint16(at: 2) == 0x7856)
        XCTAssert(data.uint16(at: 3) == 0x1278)
        XCTAssert(data.uint16(at: 4) == 0x3412)
        XCTAssert(data.uint16(at: 5) == 0x5634)
        XCTAssert(data.uint16(at: 6) == 0x7856)
        
        XCTAssert(data.uint16BE() == 0x1234)
        XCTAssert(data.uint16BE(at: 1) == 0x3456)
        XCTAssert(data.uint16BE(at: 2) == 0x5678)
        XCTAssert(data.uint16BE(at: 3) == 0x7812)
        XCTAssert(data.uint16BE(at: 4) == 0x1234)
        XCTAssert(data.uint16BE(at: 5) == 0x3456)
        XCTAssert(data.uint16BE(at: 6) == 0x5678)
        
        XCTAssert(data.uint32() == 0x78563412)
        XCTAssert(data.uint32(at: 1) == 0x12785634)
        XCTAssert(data.uint32(at: 2) == 0x34127856)
        XCTAssert(data.uint32(at: 3) == 0x56341278)
        XCTAssert(data.uint32(at: 4) == 0x78563412)
        
        XCTAssert(data.uint32BE() == 0x12345678)
        XCTAssert(data.uint32BE(at: 1) == 0x34567812)
        XCTAssert(data.uint32BE(at: 2) == 0x56781234)
        XCTAssert(data.uint32BE(at: 3) == 0x78123456)
        XCTAssert(data.uint32BE(at: 4) == 0x12345678)
        
        XCTAssert(data.uint64() == 0x7856341278563412)
        
        XCTAssert(data.uint64BE() == 0x1234567812345678)
        
        XCTAssert(UInt8(0x1f).data == Data([0x1f]))
        
        XCTAssert(UInt16(0x1234).data == Data([0x34, 0x12]))
        XCTAssert(UInt16(0x1234).bigEndian.data == Data([0x12, 0x34]))
        
        XCTAssert(UInt32(0x12345678).data == Data([0x78, 0x56, 0x34, 0x12]))
        XCTAssert(UInt32(0x12345678).bigEndian.data == Data([0x12, 0x34, 0x56, 0x78]))
        
        XCTAssert(UInt64(0x12345678abcdef00).data == Data([0x00, 0xef, 0xcd, 0xab, 0x78, 0x56, 0x34, 0x12]))
        XCTAssert(UInt64(0x12345678abcdef00).bigEndian.data == Data([0x12, 0x34, 0x56, 0x78, 0xab, 0xcd, 0xef, 0x00]))
    }
    
    func testBitfield8() {
        // Write your test here and use APIs like `#expect(...)` to check expected conditions.
        var bf = Bitfield8()
        XCTAssert(bf == 0b0000_0000)
        
        bf[2] = true
        XCTAssert(bf == 0b0000_0100)
        
        bf[0..<2] = 0b11
        XCTAssert(bf == 0b0000_0111)
        
        bf[5...7] = 0b101
        XCTAssert(bf == 0b1010_0111)
        
        bf[..<2] = 0b00
        XCTAssert(bf == 0b1010_0100)
        
        bf[...3] = 0b1010
        XCTAssert(bf == 0b1010_1010)
        
        bf[5...] = 0b011
        XCTAssert(bf == 0b0110_1010)
        
        bf.toggle(2)
        XCTAssert(bf == 0b0110_1110)
    }
    
    func testAVG() {
        XCTAssert([1, 2, 3, 4, 5].avg() == 3)
        XCTAssert([2.0, 3.0, 4.0, 5.0].avg() == 3.5)
        
    }
    
    func testOptionals() {
        var a: Int? = 1
        
        a.nilify()
        
        XCTAssertTrue(a == nil)
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
        
        let e = Range(endIndex: 14, count: 6)
        XCTAssert(e == 8..<14)
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
        
        let e = ClosedRange(endIndex: 14, count: 7)
        XCTAssert(e == 8...14)
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
    
    func testStringExtension() {
        let str1 = "Hello World !"
        
        XCTAssert(str1.base64Encoded() == "SGVsbG8gV29ybGQgIQ==")
        
        let base64Str = "SGVsbG8gV29ybGQgIQ=="
        XCTAssert(base64Str.base64Decoded() == str1)
    }
    
    func testMutableProxy() {
        let p1 = CGPoint.zero
        let p2 = withMutable(p1) { $0.x = 42 }
        let p3 = Sylex.copy(p2, replacing: \.y, with: 42)
        XCTAssert(p2 == .init(x: 42, y: 0))
        XCTAssert(p3 == .init(x: 42, y: 42))
    }
}
