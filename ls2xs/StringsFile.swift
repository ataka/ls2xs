import Foundation

class StringsFile {
    let URL: NSURL
    var dictionary: [String: String]
    
    class func stringsFilesInDirectory(directoryURL: NSURL) -> [StringsFile] {
        var files = [StringsFile]()
        
        for URL in NSFileManager.defaultManager().stringsURLsInURL(directoryURL) {
            if let file = StringsFile(URL: URL) {
                files.append(file)
            }
        }
        
        return files
    }
    
    init?(URL: NSURL) {
        self.URL = URL
        self.dictionary = (NSDictionary(contentsOfURL: URL) as? [String: String]) ?? [String: String]()
        
        if URL.pathExtension != "strings" {
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
