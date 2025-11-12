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
        
        XCTAssert(data.uint16Array() == [0x3412, 0x7856, 0x3412, 0x7856])
        XCTAssert(data.uint32Array() == [0x78563412, 0x78563412])
        XCTAssert(data.uint64Array() == [0x7856341278563412])
        
        XCTAssert(data.uint16Array(at: 2) == [0x7856, 0x3412, 0x7856])
        XCTAssert(data.uint16Array(at: 3) == [0x1278, 0x5634])
        XCTAssert(data.uint16Array(at: 4) == [0x3412, 0x7856])
        
        XCTAssert(data.uint16Array(at: 1, count: 2) == [0x5634, 0x1278])
        
        XCTAssert(data.uint16BEArray() == [0x1234, 0x5678, 0x1234, 0x5678])
        XCTAssert(data.uint32BEArray() == [0x12345678, 0x12345678])
        XCTAssert(data.uint64BEArray() == [0x1234567812345678])
        
        XCTAssert(data.uint16BEArray(at: 2) == [0x5678, 0x1234, 0x5678])
        XCTAssert(data.uint16BEArray(at: 3) == [0x7812, 0x3456])
        XCTAssert(data.uint16BEArray(at: 4) == [0x1234, 0x5678])
        
        XCTAssert(data.uint16BEArray(at: 1, count: 2) == [0x3456, 0x7812])
        XCTAssert(data.uint16BEArray(at: 2, count: 2) == [0x5678, 0x1234])
        
        XCTAssert(Data([UInt16]([0x1234, 0x5678])) == Data([0x34, 0x12, 0x78, 0x56]))
        XCTAssert(Data(be: [UInt16]([0x1234, 0x5678])) == Data([0x12, 0x34, 0x56, 0x78]))
        
        let uuid = UUID()
        let bw = BufferWritter()
        
        bw.append(uuid)
        XCTAssert(bw.bufferData.count == MemoryLayout.size(ofValue: uuid))
        
        let br = BufferReader(bw.bufferData)
        let decodedUuid = try! UUID(from: br)
        XCTAssert(uuid == decodedUuid)
    }
    
    func testBufferReader() {
        let data = Data([0x12, 0x34, 0x56, 0x78, 0x12, 0x34, 0x56, 0x78])
        let reader = BufferReader(data)
        
        XCTAssert(reader.uint8() == 0x12)
        XCTAssert(reader.uint8() == 0x34)
        XCTAssert(reader.uint8() == 0x56)
        XCTAssert(reader.uint8() == 0x78)
        XCTAssert(reader.uint8() == 0x12)
        XCTAssert(reader.uint8() == 0x34)
        XCTAssert(reader.uint8() == 0x56)
        XCTAssert(reader.uint8() == 0x78)
        
        reader.reset()
        XCTAssert(reader.uint16() == 0x3412)
        XCTAssert(reader.uint16() == 0x7856)
        XCTAssert(reader.uint16() == 0x3412)
        XCTAssert(reader.uint16() == 0x7856)
        
        reader.reset()
        XCTAssert(reader.uint16BE() == 0x1234)
        XCTAssert(reader.uint16BE() == 0x5678)
        XCTAssert(reader.uint16BE() == 0x1234)
        XCTAssert(reader.uint16BE() == 0x5678)
        
        reader.reset()
        XCTAssert(reader.uint16BE() == 0x1234)
        XCTAssert(reader.uint16BE() == 0x5678)
        XCTAssert(reader.uint16BE() == 0x1234)
        XCTAssert(reader.uint16BE() == 0x5678)
        
        reader.reset()
        XCTAssert(reader.uint32() == 0x78563412)
        XCTAssert(reader.uint32() == 0x78563412)
        
        reader.reset()
        XCTAssert(reader.uint32BE() == 0x12345678)
        XCTAssert(reader.uint32BE() == 0x12345678)
        
        reader.reset()
        XCTAssert(reader.uint64() == 0x7856341278563412)
        
        reader.reset()
        XCTAssert(reader.uint64BE() == 0x1234567812345678)
        
        reader.reset()
        XCTAssert(reader.uint8Array() == [0x12, 0x34, 0x56, 0x78, 0x12, 0x34, 0x56, 0x78])
        
        reader.reset()
        reader.advance(by: 2)
        XCTAssert(reader.uint8Array() == [0x56, 0x78, 0x12, 0x34, 0x56, 0x78])
        
        reader.reset()
        reader.advance(by: 3)
        XCTAssert(reader.uint8Array(count: 3) == [0x78, 0x12, 0x34])
        XCTAssert(reader.uint8Array() == [0x56, 0x78])
        
        reader.reset()
        XCTAssert(reader.uint16Array() == [0x3412, 0x7856, 0x3412, 0x7856])
        reader.reset()
        XCTAssert(reader.uint32Array() == [0x78563412, 0x78563412])
        reader.reset()
        XCTAssert(reader.uint64Array() == [0x7856341278563412])
        
        reader.reset()
        reader.advance(by: 2)
        XCTAssert(reader.uint16Array() == [0x7856, 0x3412, 0x7856])
        reader.reset()
        reader.advance(by: 3)
        XCTAssert(reader.uint16Array() == [0x1278, 0x5634])
        XCTAssert(reader.uint8() == 0x78)
        reader.reset()
        reader.advance(by: 4)
        XCTAssert(reader.uint16Array() == [0x3412, 0x7856])
        
        reader.reset()
        reader.advance(by: 1)
        XCTAssert(reader.uint16Array(count: 2) == [0x5634, 0x1278])
        
        reader.reset()
        XCTAssert(reader.uint16BEArray() == [0x1234, 0x5678, 0x1234, 0x5678])
        reader.reset()
        XCTAssert(reader.uint32BEArray() == [0x12345678, 0x12345678])
        reader.reset()
        XCTAssert(reader.uint64BEArray() == [0x1234567812345678])
        
        reader.reset()
        reader.advance(by: 2)
        XCTAssert(reader.uint16BEArray() == [0x5678, 0x1234, 0x5678])
        reader.reset()
        reader.advance(by: 3)
        XCTAssert(reader.uint16BEArray() == [0x7812, 0x3456])
        XCTAssert(reader.uint8() == 0x78)
        reader.reset()
        reader.advance(by: 4)
        XCTAssert(reader.uint16BEArray() == [0x1234, 0x5678])
        
        reader.reset()
        reader.advance(by: 1)
        XCTAssert(reader.uint16BEArray(count: 2) == [0x3456, 0x7812])
        reader.reset()
        reader.advance(by: 2)
        XCTAssert(reader.uint16BEArray( count: 2) == [0x5678, 0x1234])
    }
    
    func testDataCodable() {
        let a: UInt8 = 0x12
        let b: UInt8 = 0x34
        
        let uuid = UUID()
        
        let bw = BufferWritter()
        bw.append(a)
        bw.append(uuid)
        bw.append(b)
        
        let br = BufferReader(bw.data)
        XCTAssert(br.uint8() == a)
        XCTAssert(try br.subject() as UUID == uuid)
        XCTAssert(br.uint8() == b)
    }
    
    func testBufferString() {
        let bw = BufferWritter()
        print(bw.currentOffset, bw.append(UInt16(0x1234)), bw.currentOffset)
        print(bw.data.array() as [UInt8])
        print(bw.currentOffset, bw.append("Hello", count: 8), bw.currentOffset)
        print(bw.data.array() as [UInt8])
        print(bw.currentOffset, bw.append("Hello", nullTerminated: false), bw.currentOffset)
        print(bw.data.array() as [UInt8])
        
        let br = BufferReader(bw.bufferData)
        br.advance(by: 2)
        XCTAssert(br.string() == "Hello")
        XCTAssert(br.string() == "")
        XCTAssert(br.uint8() == 0x00)
        XCTAssert(br.string() == "Hello")
        br.reset()
        _ = br.string()
        XCTAssert(br.uint8() == 0x00)
        XCTAssert(br.uint8() == 0x00)
        XCTAssert(br.string(count: 4) == "Hell")
        XCTAssert(br.string() == "o")
        
        let data = Data([72, 101, 108, 108, 111, 0, 0, 0, 0, 0, 0])
        let br2 = BufferReader(data)
        print(br2.string())
        br2.reset()
        print(br2.string(count: 7))
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

// MARK: - BinaryInteger Extension Tests

final class BinaryIntegerExtensionTests: XCTestCase {
    
    // MARK: - Type Conversion Tests
    
    func testDoubleConversion() {
        let intValue: Int = 42
        XCTAssertEqual(intValue.d, 42.0)
        
        let int64Value: Int64 = -100
        XCTAssertEqual(int64Value.d, -100.0)
        
        let uint8Value: UInt8 = 255
        XCTAssertEqual(uint8Value.d, 255.0)
    }
    
    func testUIntConversion() {
        let intValue: Int = 100
        XCTAssertEqual(intValue.u, UInt(100))
        
        let int64Value: Int64 = 50
        XCTAssertEqual(int64Value.u, UInt(50))
    }
    
    func testIntConversion() {
        let uintValue: UInt = 200
        XCTAssertEqual(uintValue.i, Int(200))
        
        let uint8Value: UInt8 = 50
        XCTAssertEqual(uint8Value.i, Int(50))
    }
    
    // MARK: - Mutating Round to Nearest Tests
    
    func testMutatingRoundToNearest() {
        var value = 23
        value.roundToNearest(10)
        XCTAssertEqual(value, 20)
        
        var value2 = 25
        value2.roundToNearest(10)
        XCTAssertEqual(value2, 30)
        
        var value3 = 27
        value3.roundToNearest(10)
        XCTAssertEqual(value3, 30)
        
        var value4 = 13
        value4.roundToNearest(5)
        XCTAssertEqual(value4, 15)
    }
    
    func testMutatingRoundToNearestNegative() {
        var value = -23
        value.roundToNearest(10)
        XCTAssertEqual(value, -20)
        
        var value2 = -25
        value2.roundToNearest(10)
        XCTAssertEqual(value2, -30)
    }
    
    func testMutatingRoundToNearestWithRule() {
        var value = 23
        value.roundToNearest(10, rule: .up)
        XCTAssertEqual(value, 30)
        
        var value2 = 23
        value2.roundToNearest(10, rule: .down)
        XCTAssertEqual(value2, 20)
        
        var value3 = 25
        value3.roundToNearest(10, rule: .toNearestOrAwayFromZero)
        XCTAssertEqual(value3, 30)
        
        var value4 = 23
        value4.roundToNearest(10, rule: .towardZero)
        XCTAssertEqual(value4, 20)
    }
    
    // MARK: - Non-Mutating Round to Nearest Tests
    
    func testRoundedToNearest() {
        let value = 23
        XCTAssertEqual(value.roundedToNearest(10), 20)
        XCTAssertEqual(value, 23) // Original unchanged
        
        XCTAssertEqual(25.roundedToNearest(10), 30) // Banker's rounding
        XCTAssertEqual(27.roundedToNearest(10), 30)
        XCTAssertEqual(13.roundedToNearest(5), 15)
    }
    
    func testRoundedToNearestNegative() {
        XCTAssertEqual((-23).roundedToNearest(10), -20)
        XCTAssertEqual((-25).roundedToNearest(10), -30) // Banker's rounding
    }
    
    func testRoundedToNearestWithRule() {
        XCTAssertEqual(23.roundedToNearest(10, rule: .up), 30)
        XCTAssertEqual(23.roundedToNearest(10, rule: .down), 20)
        XCTAssertEqual(25.roundedToNearest(10, rule: .toNearestOrAwayFromZero), 30)
        XCTAssertEqual(23.roundedToNearest(10, rule: .towardZero), 20)
        XCTAssertEqual((-23).roundedToNearest(10, rule: .towardZero), -20)
        XCTAssertEqual((-27).roundedToNearest(10, rule: .awayFromZero), -30)
    }
}

// MARK: - BinaryFloatingPoint Extension Tests

final class BinaryFloatingPointExtensionTests: XCTestCase {
    
    // MARK: - Type Conversion Tests
    
    func testDoubleConversion() {
        let floatValue: Float = 3.14
        XCTAssertEqual(floatValue.d, Double(3.14), accuracy: 0.0001)
        
        let doubleValue: Double = 42.5
        XCTAssertEqual(doubleValue.d, 42.5)
    }
    
    func testUIntConversion() {
        let doubleValue: Double = 42.7
        XCTAssertEqual(doubleValue.u, UInt(42))
        
        let floatValue: Float = 100.9
        XCTAssertEqual(floatValue.u, UInt(100))
    }
    
    func testIntConversion() {
        let doubleValue: Double = -17.8
        XCTAssertEqual(doubleValue.i, Int(-17))
        
        let floatValue: Float = 42.3
        XCTAssertEqual(floatValue.i, Int(42))
    }
    
    // MARK: - Mutating Round to Nearest Tests
    
    func testMutatingRoundToNearest() {
        var value = 23.7
        value.roundToNearest(5.0)
        XCTAssertEqual(value, 25.0, accuracy: 0.0001)
        
        var value2 = 2.5
        value2.roundToNearest(1.0)
        XCTAssertEqual(value2, 3.0, accuracy: 0.0001)
        
        var value3 = 3.5
        value3.roundToNearest(1.0)
        XCTAssertEqual(value3, 4.0, accuracy: 0.0001)
        
        var value4 = 0.123
        value4.roundToNearest(0.05)
        XCTAssertEqual(value4, 0.10, accuracy: 0.0001)
    }
    
    func testMutatingRoundToNearestNegative() {
        var value = -23.7
        value.roundToNearest(5.0)
        XCTAssertEqual(value, -25.0, accuracy: 0.0001)
        
        var value2 = -2.5
        value2.roundToNearest(1.0)
        XCTAssertEqual(value2, -3.0, accuracy: 0.0001)
    }
    
    func testMutatingRoundToNearestWithRule() {
        var value = 23.3
        value.roundToNearest(5.0, rule: .up)
        XCTAssertEqual(value, 25.0, accuracy: 0.0001)
        
        var value2 = 23.7
        value2.roundToNearest(5.0, rule: .down)
        XCTAssertEqual(value2, 20.0, accuracy: 0.0001)
        
        var value3 = 2.5
        value3.roundToNearest(1.0, rule: .toNearestOrAwayFromZero)
        XCTAssertEqual(value3, 3.0, accuracy: 0.0001)
    }
    
    // MARK: - Non-Mutating Round to Nearest Tests
    
    func testRoundedToNearest() {
        let value = 23.7
        XCTAssertEqual(value.roundedToNearest(5.0), 25.0, accuracy: 0.0001)
        XCTAssertEqual(value, 23.7, accuracy: 0.0001) // Original unchanged
        
        XCTAssertEqual(2.5.roundedToNearest(1.0), 3.0, accuracy: 0.0001)
        XCTAssertEqual(0.123.roundedToNearest(0.05), 0.10, accuracy: 0.0001)
    }
    
    func testRoundedToNearestNegative() {
        XCTAssertEqual((-23.7).roundedToNearest(5.0), -25.0, accuracy: 0.0001)
        XCTAssertEqual((-2.5).roundedToNearest(1.0), -3.0, accuracy: 0.0001) // Banker's rounding
    }
    
    func testRoundedToNearestWithRule() {
        XCTAssertEqual(23.3.roundedToNearest(5.0, rule: .up), 25.0, accuracy: 0.0001)
        XCTAssertEqual(23.7.roundedToNearest(5.0, rule: .down), 20.0, accuracy: 0.0001)
        XCTAssertEqual(2.5.roundedToNearest(1.0, rule: .toNearestOrAwayFromZero), 3.0, accuracy: 0.0001)
        XCTAssertEqual(0.5.roundedToNearest(0.5, rule: .toNearestOrAwayFromZero), 0.5, accuracy: 0.0001)
    }
}

// MARK: - Global Round Function Tests (BinaryFloatingPoint)

final class GlobalRoundFloatingPointTests: XCTestCase {
    
    func testRoundToNearest() {
        XCTAssertEqual(round(23.7, toNearest: 5.0), 25.0, accuracy: 0.0001)
        XCTAssertEqual(round(2.5, toNearest: 1.0), 3.0, accuracy: 0.0001) // Banker's rounding
        XCTAssertEqual(round(0.123, toNearest: 0.05), 0.10, accuracy: 0.0001)
    }
    
    func testRoundToNearestNegative() {
        XCTAssertEqual(round(-23.7, toNearest: 5.0), -25.0, accuracy: 0.0001)
        XCTAssertEqual(round(-2.5, toNearest: 1.0), -3.0, accuracy: 0.0001) // Banker's rounding
    }
    
    func testRoundToNearestWithRule() {
        XCTAssertEqual(round(23.3, toNearest: 5.0, rule: .up), 25.0, accuracy: 0.0001)
        XCTAssertEqual(round(23.7, toNearest: 5.0, rule: .down), 20.0, accuracy: 0.0001)
        XCTAssertEqual(round(2.5, toNearest: 1.0, rule: .toNearestOrAwayFromZero), 3.0, accuracy: 0.0001)
        XCTAssertEqual(round(-7.3, toNearest: 5.0, rule: .towardZero), -5.0, accuracy: 0.0001)
        XCTAssertEqual(round(-7.3, toNearest: 5.0, rule: .awayFromZero), -10.0, accuracy: 0.0001)
    }
    
    func testRoundToNearestFloat() {
        let floatValue: Float = 23.7
        let rounded: Float = round(floatValue, toNearest: 5.0)
        XCTAssertEqual(rounded, 25.0, accuracy: 0.0001)
    }
}

// MARK: - Global Round Function Tests (BinaryInteger)

final class GlobalRoundIntegerTests: XCTestCase {
    
    func testRoundToNearest() {
        XCTAssertEqual(round(23, toNearest: 10), 20)
        XCTAssertEqual(round(25, toNearest: 10), 30)
        XCTAssertEqual(round(137, toNearest: 16), 144)
    }
    
    func testRoundToNearestNegative() {
        XCTAssertEqual(round(-23, toNearest: 10), -20)
        XCTAssertEqual(round(-25, toNearest: 10), -30)
    }
    
    func testRoundToNearestWithRule() {
        XCTAssertEqual(round(23, toNearest: 10, rule: .up), 30)
        XCTAssertEqual(round(23, toNearest: 10, rule: .down), 20)
        XCTAssertEqual(round(137, toNearest: 16, rule: .up), 144)
        XCTAssertEqual(round(-23, toNearest: 10, rule: .towardZero), -20)
        XCTAssertEqual(round(-23, toNearest: 10, rule: .awayFromZero), -30)
    }
    
    func testRoundToNearestDifferentIntegerTypes() {
        let int64Value: Int64 = 123
        XCTAssertEqual(round(int64Value, toNearest: 50), 100)
        
        let uintValue: UInt = 47
        XCTAssertEqual(round(uintValue, toNearest: 10), 50)
    }
}

// MARK: - Edge Cases Tests

final class EdgeCasesTests: XCTestCase {
    
    func testRoundingToOne() {
        XCTAssertEqual(42.roundedToNearest(1), 42)
        XCTAssertEqual(42.7.roundedToNearest(1.0), 43.0, accuracy: 0.0001)
    }
    
    func testRoundingZero() {
        XCTAssertEqual(0.roundedToNearest(10), 0)
        XCTAssertEqual(0.0.roundedToNearest(5.0), 0.0, accuracy: 0.0001)
    }
    
    func testSmallSteps() {
        XCTAssertEqual(0.123.roundedToNearest(0.01), 0.12, accuracy: 0.0001)
        XCTAssertEqual(0.127.roundedToNearest(0.01), 0.13, accuracy: 0.0001)
    }
    
    func testLargeValues() {
        XCTAssertEqual(1000000.roundedToNearest(1000), 1000000)
        XCTAssertEqual(1000499.roundedToNearest(1000), 1000000)
    }
}
