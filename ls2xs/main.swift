import Foundation

// TODO: input
let currentPath = NSFileManager.defaultManager().currentDirectoryPath
let inputPath = currentPath.stringByAppendingPathComponent("Fixtures/Localizable.strings")
let targetPath = currentPath.stringByAppendingPathComponent("Fixtures")

let inputURL = NSURL(fileURLWithPath: inputPath)!
let targetURL = NSURL(fileURLWithPath: targetPath)!
let localizableStringsFile = StringsFile(URL: inputURL)!

for file in StringsFile.stringsFilesInDirectory(targetURL) {
    if file.URL == inputURL {
        continue
    }
    
    for (key, value) in file.dictionary {
        if let newValue = localizableStringsFile.dictionary[value] {
            file.dictionary[key] = newValue
        }
    }
    
    file.save()
}
