// https://github.com/Quick/Quick
import XCTest
import phrase_swift

class PhraseSwiftTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        let result = Phrase(pattern: "My name is {first_name} {last_name} and I am {age} years on.")
        .put(key: "first_name", value: "Jan")
        .put(key: "last_name", value: "Meier")
        .put(key: "age", value: "18")
        .format()
        XCTAssert(result == "My name is Jan Meier and I am 18 years on.")
    }

}

