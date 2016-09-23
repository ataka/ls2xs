import Foundation

class LprojFile {
    let URL: URL
    let name: String
    
    var xibFiles: [XibFile] {
        var xibFiles =  [XibFile]()
        
        for xibURL in FileManager.default.fileURLsInURL(URL) {
            if let xibFile = XibFile(URL: xibURL) {
                xibFiles.append(xibFile)
            }
        }
        
        return xibFiles
    }

    var stringsFiles: [StringsFile] {
        var stringsFiles =  [StringsFile]()

        for xibURL in FileManager.default.fileURLsInURL(URL) {
            if let stringsFile = StringsFile(URL: xibURL) {
                stringsFiles.append(stringsFile)
            }
        }
        
        return stringsFiles
    }
    
    var localizableStringsFile: StringsFile? {
        let stringsURL = URL.appendingPathComponent("Localizable.strings")
        return StringsFile(URL: stringsURL)
    }
    
    class func baseLprojInURL(_ URL: URL) -> LprojFile? {
        if let URL = FileManager.default.fileURLsInURL(URL).filter({ URL in URL.lastPathComponent == "Base.lproj" }).first {
            return LprojFile(URL: URL)
        } else {
            return nil
        }
    }
    
    class func lprojFilesInURL(_ directoryURL: URL) -> [LprojFile] {
        var files = [LprojFile]()
        
        for URL in FileManager.default.fileURLsInURL(directoryURL) {
            if let file = LprojFile(URL: URL) {
                files.append(file)
            }
        }
        
        return files
    }
    
    init?(URL: URL) {
        self.URL = URL
        self.name = URL.deletingPathExtension().lastPathComponent
        
        if URL.pathExtension != "lproj" || self.name.isEmpty {
            return nil
        }
    }
    
    func stringsFilesForXibNames(_ xibNames: [String]) -> [StringsFile] {
        return stringsFiles.filter(){ stringsFile in
            xibNames.contains((stringsFile.URL.deletingPathExtension().lastPathComponent))
        }
    }
}
