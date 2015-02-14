import Foundation

class XibFile {
    let URL: NSURL
    let name: String
    
    class func xibFilesInURL(directoryURL: NSURL) -> [XibFile] {
        var files = [XibFile]()
        
        for URL in NSFileManager.defaultManager().xibURLsInURL(directoryURL) {
            if let file = XibFile(URL: URL) {
                files.append(file)
            }
        }
        
        return files
    }
    
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
