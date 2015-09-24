import Foundation
import XCTest

class StringsFileTests: XCTestCase {
    var localizableStringsFile: StringsFile!
    var xibStringsFile: StringsFile!

    override func setUp() {
        super.setUp()
        
        let cwd = NSProcessInfo.processInfo().environment["MY_SOURCE_ROOT"]
        let fileManager = NSFileManager()
        fileManager.changeCurrentDirectoryPath(cwd!)

        let directoryPath = NSFileManager.defaultManager().currentDirectoryPath
        let directoryURL = NSURL(fileURLWithPath: directoryPath).URLByAppendingPathComponent("DemoApp")
        localizableStringsFile = StringsFile(URL: directoryURL.URLByAppendingPathComponent("en.lproj/Localizable.strings"))
        xibStringsFile = StringsFile(URL: directoryURL.URLByAppendingPathComponent("en.lproj/Main.strings"))
    }

    func testUpdate() {
        xibStringsFile.updateValuesUsingLocalizableStringsFile(localizableStringsFile)

        XCTAssertEqual(xibStringsFile.dictionary["xUH-o8-DGc.text"]!, "Hello")
        XCTAssertEqual(xibStringsFile.dictionary["uZj-A7-ihc.normalTitle"]!, "Get started")
    }
}
