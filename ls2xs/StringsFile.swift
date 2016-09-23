import Foundation

class StringsFile {
    let URL: URL
    let name: String
    var dictionary: [String: String]
    
    init?(URL: URL) {
        self.URL = URL
        self.name = URL.deletingPathExtension().lastPathComponent
        self.dictionary = (NSDictionary(contentsOf: URL) as? [String: String]) ?? [String: String]()
        
        if URL.pathExtension != "strings" || self.name.isEmpty {
            return nil
        }
    }

    func updateValuesUsingLocalizableStringsFile(_ localizableStringsFile: StringsFile) {
        for (key, value) in dictionary {
            if let newValue = localizableStringsFile.dictionary[value] {
                dictionary[key] = newValue
            }
        }
    }

    func save() {
        var string = ""
        
        for (key, value) in dictionary {
            let escapedValue: String? = Optional(value).map { character in
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
        
        do {
            // TODO: handle error
            try string.write(to: URL, atomically: true, encoding: String.Encoding.utf8)
        } catch _ {
        }
    }
}
