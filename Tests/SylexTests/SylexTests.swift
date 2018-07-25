import XCTest
@testable import Sylex

final class SylexTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(Sylex().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
