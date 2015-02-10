import Foundation

// TODO: input
let currentPath = NSFileManager.defaultManager().currentDirectoryPath
let inputPath = currentPath.stringByAppendingPathComponent("DemoApp")
let inputURL = NSURL(fileURLWithPath: inputPath)!
let fileManager = NSFileManager.defaultManager()

var baseLprojURL: NSURL

if let URL = fileManager.lprojURLsInURL(inputURL).filter({ URL in URL.lastPathComponent == "Base.lproj" }).first {
    baseLprojURL = URL
} else {
    println("could not find Base.lproj")
    abort()
}

var xibNames = [String]()

for URL in fileManager.xibURLsInURL(baseLprojURL) {
    if let name = URL.lastPathComponent?.stringByDeletingPathExtension {
        xibNames.append(name)
    }
}

for URL in fileManager.lprojURLsInURL(inputURL) {
    if URL.lastPathComponent == "Base.lproj" {
        continue
    }

    if let localizableStringsFile = StringsFile(URL: URL.URLByAppendingPathComponent("Localizable.strings")) {
        for stringsFile in StringsFile.stringsFilesInDirectory(URL) {
            if stringsFile.URL == localizableStringsFile.URL {
                continue
            }

            let name = stringsFile.URL.lastPathComponent?.stringByDeletingPathExtension ?? ""
            if !contains(xibNames, name) {
                continue
            }

            for (key, value) in stringsFile.dictionary {
                if let newValue = localizableStringsFile.dictionary[value] {
                    stringsFile.dictionary[key] = newValue
                }
            }
            
            stringsFile.save()
        }
    }
}
