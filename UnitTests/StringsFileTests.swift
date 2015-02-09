import Cocoa
import XCTest

private let projectPath = NSFileManager.defaultManager().currentDirectoryPath
private let fixturePath = projectPath.stringByAppendingPathComponent("UnitTests/Fixture.strings")
private let projectURL = NSURL(fileURLWithPath: projectPath)!
private let fixtureURL = NSURL(fileURLWithPath: fixturePath)!

class StringsFileTests: XCTestCase {
    func testInitWithURL() {
        let stringsFile = StringsFile(URL: fixtureURL)!
        XCTAssertEqual(stringsFile.dictionary, [
            "qCi-L7-NSA.normalTitle": "Button",
            "veg-fi-Qyb.text": "Hello",
        ])
    }
    
    func testEnumerateFilesUnderDirectory() {
        let files = StringsFile.stringsFilesInDirectory(projectURL)
        let stringsFile = StringsFile(URL: fixtureURL)!
        XCTAssertEqual(countElements(files), 1)
        XCTAssertEqual(first(files)!.URL, stringsFile.URL)
    }
}
