import Foundation

class LprojFile {
    let URL: NSURL
    let name: String
    
    var xibFiles: [XibFile] {
        var xibFiles =  [XibFile]()
        
        for xibURL in NSFileManager.defaultManager().fileURLsInURL(URL) {
            if let xibFile = XibFile(URL: xibURL) {
                xibFiles.append(xibFile)
            }
        }
        
        return xibFiles
    }

    var stringsFiles: [StringsFile] {
        var stringsFiles =  [StringsFile]()

        for xibURL in NSFileManager.defaultManager().fileURLsInURL(URL) {
            if let stringsFile = StringsFile(URL: xibURL) {
                stringsFiles.append(stringsFile)
            }
        }
        
        return stringsFiles
    }
    
    var localizableStringsFile: StringsFile? {
        let stringsURL = URL.URLByAppendingPathComponent("Localizable.strings")
        return StringsFile(URL: stringsURL)
    }
    
    class func baseLprojInURL(URL: NSURL) -> LprojFile? {
        if let URL = NSFileManager.defaultManager().fileURLsInURL(URL).filter({ URL in URL.lastPathComponent == "Base.lproj" }).first {
            return LprojFile(URL: URL)
        } else {
            return nil
        }
    }
    
    class func lprojFilesInURL(directoryURL: NSURL) -> [LprojFile] {
        var files = [LprojFile]()
        
        for URL in NSFileManager.defaultManager().fileURLsInURL(directoryURL) {
            if let file = LprojFile(URL: URL) {
                files.append(file)
            }
        }
        
        return files
    }
    
    init?(URL: NSURL) {
        self.URL = URL
        self.name = URL.lastPathComponent?.stringByDeletingPathExtension ?? ""
        
        if URL.pathExtension != "lproj" || self.name.isEmpty {
            return nil
        }
    }
    
    func stringsFilesForXibNames(xibNames: [String]) -> [StringsFile] {
        return stringsFiles.filter(){ stringsFile in
            xibNames.contains(stringsFile.URL.lastPathComponent!.stringByDeletingPathExtension)
        }
    }
}