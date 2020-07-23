//
//  FileManager.swift
//  ls2xs
//
//  Created by 安宅正之 on 2020/07/23.
//

import Foundation

extension FileManager {
    /// Get all urls in URL
    /// - Parameter url: Root URL to find all urls
    /// - Returns: all urls in URL
    func fileURLs(in url: URL) -> [URL] {
        let enumerator = FileManager.default.enumerator(at: url, includingPropertiesForKeys: [], options: .skipsHiddenFiles)

        var urls: [URL] = []
        while let url = enumerator?.nextObject() as? URL {
            urls.append(url)
        }
        return urls
    }
}
