import Foundation

extension NSFileManager {
    func fileURLsInURL(URL: NSURL) -> [NSURL] {
        let fileManager = NSFileManager.defaultManager()
        let enumerator = fileManager.enumeratorAtURL(URL, includingPropertiesForKeys: [], options: .SkipsHiddenFiles) { URL, error in
            if let error = error {
                println("error: \(error)")
                return false
            }
            return true
        }

        var URLs = [NSURL]()
        while let URL = enumerator?.nextObject() as? NSURL {
            URLs.append(URL)
        }

        return URLs

    }

    func lprojURLsInURL(parentURL: NSURL) -> [NSURL] {
        return fileURLsInURL(parentURL).filter() { URL in
            URL.pathExtension == "lproj"
        }
    }

    func xibURLsInURL(parentURL: NSURL) -> [NSURL] {
        return fileURLsInURL(parentURL).filter() { URL in
            URL.pathExtension == "xib" || URL.pathExtension == "storyboard"
        }
    }

    func stringsURLsInURL(parentURL: NSURL) -> [NSURL] {
        return fileURLsInURL(parentURL).filter() { URL in
            URL.pathExtension == "strings"
        }
    }
}
