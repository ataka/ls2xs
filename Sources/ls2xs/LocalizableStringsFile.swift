//
//  LocalizableStringsFile.swift
//  ls2xs
//
//  Created by 安宅正之 on 2020/07/23.
//

import Foundation

struct Localize {
    typealias Key = String
}
struct Localized {
    typealias Value = String
}

/// Localizable.strings file, with key-value pairs of `Localization.Key` and `Localized.Value`
final class LocalizableStringsFile {
    let url: URL
    let lang: String
    private(set) var keyValues: [Localize.Key: Localized.Value]

    init?(name: String, url: URL) {
        let lang = url.deletingLastPathComponent().deletingPathExtension().lastPathComponent
        guard url.lastPathComponent == name
            && !lang.isEmpty,
            let keyValues = Self.readKeyValues(in: url) else { return nil }

        self.url = url
        self.lang = lang
        self.keyValues = keyValues
    }

    private static func readKeyValues(in url: URL) -> [Localize.Key: Localized.Value]? {
        guard let rawKeyValues = NSDictionary(contentsOf: url) as? [Localize.Key: Localized.Value] else { return nil }
        return rawKeyValues.mapValues { value in
            String(value.flatMap { (char: Character) -> [Character] in
                switch char {
                case "\n": return ["\\", "n"]
                case "\r": return ["\\", "r"]
                case "\\": return ["\\", "\\"]
                case "\"": return ["\\", "\""]
                default:   return [char]
                }
            })
        }
    }
}
