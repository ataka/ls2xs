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
            let stringsFiles = StringsFile.stringsFilesInDirectory(lprojFile.URL).filter(){ stringsFile in
                stringsFile.URL != localizableStringsFile.URL &&
                contains(xibNames, stringsFile.URL.lastPathComponent!.stringByDeletingPathExtension)
            }
            
            for stringsFile in StringsFile.stringsFilesInDirectory(lprojFile.URL).filter({ $0.URL != localizableStringsFile.URL }) {
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
