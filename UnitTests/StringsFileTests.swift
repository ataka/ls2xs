import Cocoa
import XCTest

class StringsFileTests: XCTestCase {
    func testLoadingStrings() {
        let projectPath = NSFileManager.defaultManager().currentDirectoryPath
        let fixturePath = projectPath.stringByAppendingPathComponent("UnitTests/Fixture.strings")
        let fixtureURL = NSURL(fileURLWithPath: fixturePath)!
        let strings = StringsFile(URL: fixtureURL)!
        
        XCTAssertEqual(strings.dictionary, [
            "qCi-L7-NSA.normalTitle": "Button",
            "veg-fi-Qyb.text": "Hello",
        ])
    }
}
