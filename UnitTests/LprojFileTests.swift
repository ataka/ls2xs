import Foundation
import XCTest

class LprojFileTests: XCTestCase {
    var lprojFile: LprojFile!

    override func setUp() {
        super.setUp()

        let cwd = ProcessInfo.processInfo.environment["MY_SOURCE_ROOT"]
        let fileManager = FileManager()
        fileManager.changeCurrentDirectoryPath(cwd!)

        let path = FileManager.default.currentDirectoryPath
        let anURL = URL(fileURLWithPath: path).appendingPathComponent("DemoApp/Base.lproj")
        lprojFile = LprojFile(URL: anURL)
    }

    func testXibFiles() {
        XCTAssertEqual(lprojFile!.xibFiles.map({ $0.name }), ["LaunchScreen", "Main"])
    }

    func testStringsFiles() {
        XCTAssertEqual(lprojFile!.stringsFiles.map({ $0.name }), ["Localizable"])
    }
}
