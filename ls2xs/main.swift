import Foundation

// TODO: input
let currentPath = NSFileManager.defaultManager().currentDirectoryPath
let inputPath = currentPath.stringByAppendingPathComponent("DemoApp")
let inputURL = NSURL(fileURLWithPath: inputPath)!
let fileManager = NSFileManager.defaultManager()

for URL in fileManager.lprojURLsInURL(inputURL) {
    if URL.lastPathComponent?.stringByDeletingPathExtension == "Base" {
        continue
    }

    if let localizableStringsFile = StringsFile(URL: URL.URLByAppendingPathComponent("Localizable.strings")) {
        for stringsFile in StringsFile.stringsFilesInDirectory(URL) {
            if stringsFile.URL == localizableStringsFile.URL {
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
