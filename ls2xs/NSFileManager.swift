import Foundation

extension NSFileManager {
    func fileURLsInURL(URL: NSURL) -> [NSURL] {
        let fileManager = NSFileManager.defaultManager()
        let enumerator = fileManager.enumeratorAtURL(URL, includingPropertiesForKeys: [], options: .SkipsHiddenFiles) { URL, error in
            if let error = error {
                print("error: \(error)")
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
}
