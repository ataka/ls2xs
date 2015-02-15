import Foundation

class LprojFile {
    let URL: NSURL
    
    var xibFiles: [XibFile] {
        var xibFiles =  [XibFile]()
        
        for xibURL in NSFileManager.defaultManager().xibURLsInURL(URL) {
            if let xibFile = XibFile(URL: xibURL) {
                xibFiles.append(xibFile)
            }
        }
        
        return xibFiles
    }
    
    var localizableStringsFile: StringsFile? {
        let stringsURL = URL.URLByAppendingPathComponent("Localizable.strings")
        return StringsFile(URL: stringsURL)
    }
    
    class func baseLprojInURL(URL: NSURL) -> LprojFile? {
        if let URL = NSFileManager.defaultManager().lprojURLsInURL(URL).filter({ URL in URL.lastPathComponent == "Base.lproj" }).first {
            return LprojFile(URL: URL)
        } else {
            return nil
        }
    }
    
    class func lprojFilesInURL(directoryURL: NSURL) -> [LprojFile] {
        var files = [LprojFile]()
        
        for URL in NSFileManager.defaultManager().lprojURLsInURL(directoryURL) {
            if let file = LprojFile(URL: URL) {
                files.append(file)
            }
        }
        
        return files
    }
    
    init?(URL: NSURL) {
        self.URL = URL
        
        if URL.pathExtension != "lproj" {
            return nil
        }
    }
    
}