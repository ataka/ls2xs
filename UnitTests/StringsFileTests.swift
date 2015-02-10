import Cocoa
import XCTest

class StringsFileTests: XCTestCase {
    func testInitWithURL() {
        let projectPath = NSFileManager.defaultManager().currentDirectoryPath
        let fixturePath = projectPath.stringByAppendingPathComponent("Fixtures/Target.strings")
        let fixtureURL = NSURL(fileURLWithPath: fixturePath)!
        let stringsFile = StringsFile(URL: fixtureURL)!
        
        XCTAssertEqual(stringsFile.dictionary, [
            "qCi-L7-NSA.normalTitle": "button",
            "veg-fi-Qyb.text": "hello",
        ])
    }
    
    func testEnumerateFilesUnderDirectory() {
        let projectPath = NSFileManager.defaultManager().currentDirectoryPath
        let projectURL = NSURL(fileURLWithPath: projectPath)!
        let files = StringsFile.stringsFilesInDirectory(projectURL)
        XCTAssertEqual(count(files), 2)
    }
}
