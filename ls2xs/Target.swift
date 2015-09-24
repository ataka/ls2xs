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
        let inputPath = NSURL(string: currentPath)?.URLByAppendingPathComponent(path)
        URL = inputPath

        if URL == nil {
            print("error: passed invalid path.")
            return nil
        }

        if baseLprojFile == nil {
            print("error: could not find Base.lproj in \(URL.path!)")
            return nil
        }
    }

    func run() {
        let xibNames = baseLprojFile.xibFiles.map({ $0.name })
        for xibFile in baseLprojFile.xibFiles {
            for lprojFile in langLprojFiles {
                print("generating .strings for \(lprojFile.URL.path!)/\(xibFile.name).strings")
                xibFile.generateStringsInLprojFile(lprojFile)
            }
        }

        for lprojFile in langLprojFiles {
            if let localizableStringsFile = lprojFile.localizableStringsFile {
                for stringsFile in lprojFile.stringsFilesForXibNames(xibNames) {
                    print("updating \(stringsFile.URL.path!)")
                    stringsFile.updateValuesUsingLocalizableStringsFile(localizableStringsFile)
                    stringsFile.save()
                }
            } else {
                print("warning: Localizable.strings is not found in \(lprojFile.URL.path!)")
            }
        }

        print("done.")
    }
}
