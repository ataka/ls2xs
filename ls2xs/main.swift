import Foundation

func executeWithPath(path: String) {
    let currentPath = NSFileManager.defaultManager().currentDirectoryPath
    let inputPath = currentPath.stringByAppendingPathComponent(path)
    let inputURL = NSURL(fileURLWithPath: inputPath)!
    let fileManager = NSFileManager.defaultManager()
    
    // FIXME: remove unwrapping
    let baseLprojFile = LprojFile.baseLprojInURL(inputURL)!
    let lprojFiles = LprojFile.lprojFilesInURL(inputURL)
    var xibNames = [String]()
    
    for xibFile in baseLprojFile.xibFiles {
        for lprojFile in lprojFiles {
            xibFile.generateStringsInLprojFile(lprojFile)
        }
        xibNames.append(xibFile.name)
    }
    
    for lprojFile in lprojFiles.filter({ $0.URL != baseLprojFile.URL }) {
        if let localizableStringsFile = lprojFile.localizableStringsFile {
            for stringsFile in StringsFile.stringsFilesInDirectory(lprojFile.URL) {
                if stringsFile.URL == localizableStringsFile.URL {
                    continue
                }
                
                let name = stringsFile.URL.lastPathComponent!.stringByDeletingPathExtension
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
}

if Process.arguments.count == 2 {
    executeWithPath(Process.arguments[1])
} else {
    println("usage: ls2xs <path>")
}
