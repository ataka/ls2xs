import Cocoa
import XCTest

class TargetTests: XCTestCase {
    var target: Target!

    override func setUp() {
        super.setUp()
        
        let cwd = ProcessInfo.processInfo.environment["MY_SOURCE_ROOT"]
        let fileManager = FileManager()
        fileManager.changeCurrentDirectoryPath(cwd!)
        
        target = Target(path: "DemoApp")
    }

    func testInitializer() {
        XCTAssertNotNil(target)
    }

    func testBaseLprojFile() {
        XCTAssertEqual(target.baseLprojFile!.URL.lastPathComponent, "Base.lproj")
    }

    func testLangLprojFiles() {
        XCTAssertEqual(target.langLprojFiles.map({ $0.name }), ["en", "ja"])
    }
}
