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
    func makeBaseStringsFile(name: String) -> BaseStringsFile
}

extension IbFile {
    func makeBaseStringsFile(name: String) -> BaseStringsFile {
        generate(from: self, to: "\(name).strings")
        let baseStringFile = BaseStringsFile(ibFileUrl: url, name: name)
        baseStringFile.keyValues = { url in
            guard let keyValues = NSDictionary(contentsOf: url) as? [IbFile.ObjectId: Localize.Key] else { fatalError("Failed to load IbFile: \(url)") }
            return keyValues
        }(baseStringFile.url)
        return baseStringFile
    }

    private func generate(from ibFile: IbFile, to baseStringsFileName: String) {
        let generateStringsFile: Process = { task, ibFileUrl, baseStringsFileUrl in
            task.launchPath = "/usr/bin/ibtool"
            task.arguments = [
                ibFileUrl.path,
                "--generate-strings-file",
                baseStringsFileUrl.path,
            ]
            return task
        }(Process(), ibFile.url, ibFile.url.deletingLastPathComponent().appendingPathComponent(baseStringsFileName))
        generateStringsFile.launch()
        generateStringsFile.waitUntilExit()
    }

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
