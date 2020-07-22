//
//  LangStringsFile.swift
//  ls2xs
//
//  Created by 安宅正之 on 2020/07/23.
//

import Foundation

struct LangStringsFile {
    let url: URL
    let lang: String
    var keyValues: [IbFile.ObjectId: Localized.Value] = [:]

    init(lang: String, baseStringsFile: BaseStringsFile) {
        url = baseStringsFile.url
            .deletingLastPathComponent()
            .deletingLastPathComponent()
            .appendingPathComponent("\(lang).lproj")
            .appendingPathComponent("\(baseStringsFile.fullname)")
        self.lang = lang
    }

    mutating func update(from baseStringsFile: BaseStringsFile, with localizableString: LocalizableStringsFile) {
        baseStringsFile.keyValues.forEach { (ibKey, localizeKey) in
            if let localizedValue = localizableString.keyValues[localizeKey] {
                keyValues[ibKey] = localizedValue
            } else {
                keyValues[ibKey] = localizeKey
            }
        }
    }

    func save() {
        let output = keyValues.map({ ibKey, localizedValue in
            #""\#(ibKey)" = "\#(localizedValue)";\#n"#
            })
            .sorted()
            .joined()

        do {
            let dir = url.deletingLastPathComponent()
            try FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
            try output.write(to: url, atomically: true, encoding: .utf8)
        } catch {
            fatalError("Howdy")
        }
    }
}
