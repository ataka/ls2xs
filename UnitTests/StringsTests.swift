import Cocoa
import XCTest

class StringsTests: XCTestCase {
    func testLoadingStrings() {
        let projectPath = NSFileManager.defaultManager().currentDirectoryPath
        let fixturePath = projectPath.stringByAppendingPathComponent("UnitTests/Fixture.strings")
        let fixtureURL = NSURL(fileURLWithPath: fixturePath)!
        let strings = Strings(URL: fixtureURL)!
        
        XCTAssertEqual(strings.dictionary, [
            "qCi-L7-NSA.normalTitle": "Button",
            "veg-fi-Qyb.text": "Hello",
        ])
    }
}
