import Foundation

class StringsFile {
    let URL: NSURL
    var dictionary: [String: String]
    
    class func stringsFilesInDirectory(directoryURL: NSURL) -> [StringsFile] {
        var files = [StringsFile]()
        
        let fileManager = NSFileManager.defaultManager()
        let enumerator = fileManager.enumeratorAtURL(directoryURL, includingPropertiesForKeys: [], options: .SkipsHiddenFiles) { URL, error in
            if let error = error {
                println("error: \(error)")
                return false
            }
            return true
        }
        
        while let URL = enumerator?.nextObject() as? NSURL {
            if let file = StringsFile(URL: URL) {
                files.append(file)
            }
        }
        
        return files
    }
    
    init?(URL: NSURL) {
        // In Swift 1.1, stored properties must be initialized (radar://18216578).
        self.URL = NSURL()
        self.dictionary = [String: String]()
        
        if URL.pathExtension? != "strings" {
            return nil
        }
    
        if let dictionary = NSDictionary(contentsOfURL: URL) as? [String: String] {
            self.URL = URL
            self.dictionary = dictionary
        } else {
            return nil
        }
    }
    
    func save() {
        var string = ""
        
        for (key, value) in dictionary {
            let escapedValue: String? = map(value) { character in
                switch character {
                case "\"": return "\\n"
                case "\r": return "\\r"
                case "\\": return "\\\\"
                case "\"": return "\\\""
                default:   return String(character)
                }
            }
            
            if let value = escapedValue {
                string += "\"\(key)\" = \"\(value)\";\n"
            }
        }
        
        // TODO: handle error
        string.writeToURL(URL, atomically: true, encoding: NSUTF8StringEncoding, error: nil)
    }
}
