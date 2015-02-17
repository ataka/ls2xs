import Foundation
import XCTest

class LprojFileTests: XCTestCase {
    var lprojFile: LprojFile!

    override func setUp() {
        super.setUp()

        let path = NSFileManager.defaultManager().currentDirectoryPath.stringByAppendingPathComponent("DemoApp/Base.lproj")
        let URL = NSURL(fileURLWithPath: path)!
        lprojFile = LprojFile(URL: URL)
    }

    func testXibFiles() {
        XCTAssertEqual(lprojFile!.xibFiles.map({ $0.name }), ["LaunchScreen", "Main"])
    }

    func testStringsFiles() {
        XCTAssertEqual(lprojFile!.stringsFiles.map({ $0.name }), ["Localizable"])
    }
}
