import Foundation

extension FileManager {
    func fileURLsInURL(_ URL: URL) -> [URL] {
        let fileManager = FileManager.default
        let enumerator = fileManager.enumerator(at: URL, includingPropertiesForKeys: [], options: .skipsHiddenFiles) { (URL: URL, error: Error) in
            print("error: \(error)")
            return false
        }

        var URLs = [URL]
        while let URL = enumerator?.nextObject() as? URL {
            URLs.append(URL)
        }

        return URLs
    }
}
