import Foundation

class XibFile {
    let URL: NSURL
    let name: String
    
    init?(URL: NSURL) {
        self.URL = URL
        self.name = URL.lastPathComponent?.stringByDeletingPathExtension ?? ""
        
        if URL.pathExtension != "xib" || self.name.isEmpty {
            return nil
        }
    }
    
    func generateStringsInLprojFile(lprojFile: LprojFile) {
        let destinationURL = lprojFile.URL.URLByAppendingPathComponent("\(name).strings")
        let task = NSTask()
        task.launchPath = "/usr/bin/ibtool"
        task.arguments = [URL.path!, "--generate-strings-file", destinationURL.path!]
        task.launch()
        task.waitUntilExit()
    }
}
