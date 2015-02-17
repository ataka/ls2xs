import Foundation

class Target {
    let URL: NSURL!

    var baseLprojFile: LprojFile! {
        if let URL = NSFileManager.defaultManager().fileURLsInURL(URL).filter({ URL in URL.lastPathComponent == "Base.lproj" }).first {
            return LprojFile(URL: URL)
        } else {
            return nil
        }
    }

    var langLprojFiles: [LprojFile] {
        var files = [LprojFile]()
        
        for lprojURL in NSFileManager.defaultManager().fileURLsInURL(URL) {
            if let file = LprojFile(URL: lprojURL) {
                if file.URL != baseLprojFile.URL {
                    files.append(file)
                }
            }
        }
        
        return files
    }

    init?(path: String) {
        let currentPath = NSFileManager.defaultManager().currentDirectoryPath
        let inputPath = currentPath.stringByAppendingPathComponent(path)
        URL = NSURL(fileURLWithPath: inputPath)!

        if URL == nil {
            println("error: passed invalid path.")
            return nil
        }

        if baseLprojFile == nil {
            println("could not find Base.lproj in \(URL.path!)")
            return nil
        }
    }

    func run() {
        let xibNames = baseLprojFile.xibFiles.map({ $0.name })
        for xibFile in baseLprojFile.xibFiles {
            for lprojFile in langLprojFiles {
                println("generating .strings for \(URL.path!)")
                xibFile.generateStringsInLprojFile(lprojFile)
            }
        }

        for lprojFile in langLprojFiles {
            if let localizableStringsFile = lprojFile.localizableStringsFile {
                for stringsFile in lprojFile.stringsFilesForXibNames(xibNames) {
                    println("updating \(URL.path!)")
                    stringsFile.updateValuesUsingLocalizableStringsFile(localizableStringsFile)
                    stringsFile.save()
                }
            } else {
                println("warning: Localizable.strings is not found in \(lprojFile.URL.path!)")
            }
        }
    }
}
