import Foundation

class XibFile {
    let URL: URL
    let name: String
    
    init?(URL: URL) {
        self.URL = URL
        self.name = URL.deletingPathExtension().lastPathComponent
        
        if (URL.pathExtension != "xib" && URL.pathExtension != "storyboard") || self.name.isEmpty {
            return nil
        }
    }
    
    func generateStringsInLprojFile(_ lprojFile: LprojFile) {
        let destinationURL = lprojFile.URL.appendingPathComponent("\(name).strings")
        let task = Process()
        task.launchPath = "/usr/bin/ibtool"
        task.arguments = [URL.path, "--generate-strings-file", destinationURL.path]
        task.launch()
        task.waitUntilExit()
    }
}
