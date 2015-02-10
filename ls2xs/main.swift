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

let lprojURLs = fileManager.lprojURLsInURL(inputURL)
let xibURLs = fileManager.xibURLsInURL(baseLprojURL)
let xibNames = xibURLs.map() { URL in
    URL.lastPathComponent!.stringByDeletingPathExtension
}

for xibURL in xibURLs {
    for lprojURL in lprojURLs {
        if lprojURL == baseLprojURL {
            continue
        }

        let xibName = xibURL.lastPathComponent!.stringByDeletingPathExtension
        let destinationURL = lprojURL.URLByAppendingPathComponent("\(xibName).strings")

        let task = NSTask()
        task.launchPath = "/usr/bin/ibtool"
        task.arguments = [xibURL.path!, "--generate-strings-file", destinationURL.path!]
        task.launch()
        task.waitUntilExit()
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
