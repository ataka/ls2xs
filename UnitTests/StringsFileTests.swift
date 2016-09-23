import Foundation
import XCTest

class StringsFileTests: XCTestCase {
    var localizableStringsFile: StringsFile!
    var xibStringsFile: StringsFile!

    override func setUp() {
        super.setUp()
        
        let cwd = ProcessInfo.processInfo.environment["MY_SOURCE_ROOT"]
        let fileManager = FileManager()
        fileManager.changeCurrentDirectoryPath(cwd!)

        let directoryPath = FileManager.default.currentDirectoryPath
        let directoryURL = URL(fileURLWithPath: directoryPath).appendingPathComponent("DemoApp")
        localizableStringsFile = StringsFile(URL: directoryURL.appendingPathComponent("en.lproj/Localizable.strings"))
        xibStringsFile = StringsFile(URL: directoryURL.appendingPathComponent("en.lproj/Main.strings"))
    }

    func testUpdate() {
        xibStringsFile.updateValuesUsingLocalizableStringsFile(localizableStringsFile)

        XCTAssertEqual(xibStringsFile.dictionary["xUH-o8-DGc.text"]!, "Hello")
        XCTAssertEqual(xibStringsFile.dictionary["uZj-A7-ihc.normalTitle"]!, "Get started")
    }
}
