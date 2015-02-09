import Foundation

class Strings {
    let URL: NSURL
    let dictionary: [String: String]
    
    init?(URL: NSURL) {
        if let dictionary = NSDictionary(contentsOfURL: URL) as? [String: String] {
            self.URL = URL
            self.dictionary = dictionary
        } else {
            // In Swift 1.1, stored properties must be initialized (radar://18216578).
            self.URL = NSURL()
            self.dictionary = [String: String]()
            return nil
        }
    }
}
