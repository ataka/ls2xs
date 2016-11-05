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
        let strings = dictionary.reduce([], { (var result, dic) -> [String] in
            let escapedValue = String(dic.value.characters.flatMap { character -> [Character] in
                switch character {
                case "\n": return ["\\", "n"]
                case "\r": return ["\\", "r"]
                case "\\": return ["\\", "\\"]
                case "\"": return ["\\", "\""]
                default:   return [character]
                }
            })
            result.append("\"\(dic.key)\" = \"\(escapedValue)\";\n")
        }).sorted()
        
        do {
            // TODO: handle error
            try strings.joined().write(to: URL, atomically: true, encoding: String.Encoding.utf8)
        } catch _ {
        }
    }
}
