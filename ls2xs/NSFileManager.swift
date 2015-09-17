import Foundation

extension NSFileManager {
    func fileURLsInURL(URL: NSURL) -> [NSURL] {
        let fileManager = NSFileManager.defaultManager()
        let enumerator = fileManager.enumeratorAtURL(URL, includingPropertiesForKeys: [], options: .SkipsHiddenFiles) { (URL: NSURL, error: NSError) in
            print("error: \(error)")
            return false
        }

        var URLs = [NSURL]()
        while let URL = enumerator?.nextObject() as? NSURL {
            URLs.append(URL)
        }

        return URLs

    }
}
