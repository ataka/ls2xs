//
//  BaseLproj.swift
//  ls2xs
//
//  Created by 安宅正之 on 2020/07/23.
//

import Foundation

/// `Base.lproj` directory, which contains `*.storyboard` and `*.xib` files
final class BaseLproj {
    let url: URL

    init?(url: URL) {
        guard url.lastPathComponent == "Base.lproj" else { return nil }
        self.url = url
    }

    var ibFiles: [IbFile] {
        FileManager.default.fileURLs(in: url).compactMap {
            XibFile(url: $0) ?? StoryboardFile(url: $0)
        }
    }
}
