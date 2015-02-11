import Foundation

func executeWithPath(path: String) {
    let currentPath = NSFileManager.defaultManager().currentDirectoryPath
    let inputPath = currentPath.stringByAppendingPathComponent(path)
    let inputURL = NSURL(fileURLWithPath: inputPath)!
    let fileManager = NSFileManager.defaultManager()
    
    var baseLprojURL: NSURL
    
    if let URL = fileManager.lprojURLsInURL(inputURL).filter({ URL in URL.lastPathComponent == "Base.lproj" }).first {
        baseLprojURL = URL
    } else {
        println("could not find Base.lproj")
        abort()
    }
    
    let lprojURLs = fileManager.lprojURLsInURL(inputURL).filter({ URL in URL != baseLprojURL })
    let xibURLs = fileManager.xibURLsInURL(baseLprojURL)
    let xibNames = xibURLs.map() { URL in
        URL.lastPathComponent!.stringByDeletingPathExtension
    }
    
    for xibURL in xibURLs {
        for lprojURL in lprojURLs {
            let xibName = xibURL.lastPathComponent!.stringByDeletingPathExtension
            let destinationURL = lprojURL.URLByAppendingPathComponent("\(xibName).strings")
            
            let task = NSTask()
            task.launchPath = "/usr/bin/ibtool"
            task.arguments = [xibURL.path!, "--generate-strings-file", destinationURL.path!]
            task.launch()
            task.waitUntilExit()
        }
    }
    
    for lprojURL in lprojURLs {
        if let localizableStringsFile = StringsFile(URL: lprojURL.URLByAppendingPathComponent("Localizable.strings")) {
            for stringsFile in StringsFile.stringsFilesInDirectory(lprojURL) {
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
