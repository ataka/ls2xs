//
//  IbFile.swift
//  ls2xs
//
//  Created by 安宅正之 on 2020/07/23.
//

import Foundation

/// Protocol of storyboard and xib files
protocol IbFile {
    typealias ObjectId = String
    var url: URL { get }
    /// File name without  extension
    var name: String { get }
}

extension IbFile {
    fileprivate static func getName(from url: URL) -> String {
        url.deletingPathExtension().lastPathComponent
    }
}

/// Xib file
struct XibFile: IbFile {
    let url: URL
    let name: String

    init?(url: URL) {
        guard url.pathExtension == "xib" else { return nil }
        self.url = url
        name = Self.getName(from: url)
    }
}

/// Storyboard file
struct StoryboardFile: IbFile {
    let url: URL
    let name: String

    init?(url: URL) {
        guard url.pathExtension == "storyboard" else { return nil }
        self.url = url
        name = Self.getName(from: url)
    }
}
