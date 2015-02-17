import Foundation

class StringsFile {
    let URL: NSURL
    let name: String
    var dictionary: [String: String]
    
    init?(URL: NSURL) {
        self.URL = URL
        self.name = URL.lastPathComponent?.stringByDeletingPathExtension ?? ""
        self.dictionary = (NSDictionary(contentsOfURL: URL) as? [String: String]) ?? [String: String]()
        
        if URL.pathExtension != "strings" || self.name.isEmpty {
            return nil
        }
    }

    func updateValuesUsingLocalizableStringsFile(localizableStringsFile: StringsFile) {
        for (key, value) in dictionary {
            if let newValue = localizableStringsFile.dictionary[value] {
                dictionary[key] = newValue
            }
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
