import Cocoa
import XCTest

class TargetTests: XCTestCase {
    var target: Target!

    override func setUp() {
        super.setUp()
        target = Target(path: "DemoApp")
    }

    func testInitializer() {
        XCTAssertNotNil(target)
    }

    func testBaseLprojFile() {
        XCTAssertEqual(target.baseLprojFile!.URL.lastPathComponent!, "Base.lproj")
    }

    func testLangLprojFiles() {
        XCTAssertEqual(target.langLprojFiles.map({ $0.name }), ["en", "ja"])
    }
}
