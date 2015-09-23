import Foundation
import XCTest

class LprojFileTests: XCTestCase {
    var lprojFile: LprojFile!

    override func setUp() {
        super.setUp()

        let cwd = NSProcessInfo.processInfo().environment["MY_SOURCE_ROOT"]
        let fileManager = NSFileManager()
        fileManager.changeCurrentDirectoryPath(cwd!)

        let path = NSFileManager.defaultManager().currentDirectoryPath
        let URL = NSURL(fileURLWithPath: path).URLByAppendingPathComponent("DemoApp/Base.lproj")
        lprojFile = LprojFile(URL: URL)
    }

    func testXibFiles() {
        XCTAssertEqual(lprojFile!.xibFiles.map({ $0.name }), ["LaunchScreen", "Main"])
    }

    func testStringsFiles() {
        XCTAssertEqual(lprojFile!.stringsFiles.map({ $0.name }), ["Localizable"])
    }
}
