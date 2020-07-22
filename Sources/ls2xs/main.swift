import Foundation
import ArgumentParser

struct Ls2Xs: ParsableCommand {
    @Argument()
    var path: String

    mutating func run() {
        let (stringFiles, baseLprojs) = collectingLocalizableStringsFilesAndBaseLprojs(in: path)
        makeLangStringsFiles(stringFiles: stringFiles, baseLprojs: baseLprojs)
    }

    private func collectingLocalizableStringsFilesAndBaseLprojs(in path: String) -> ([String: LocalizableStringsFile], [BaseLproj]) {
        let currentPath = FileManager.default.currentDirectoryPath
        guard let rootUrl = URL(string: currentPath)?.appendingPathComponent(path) else {
            fatalError("Failed to find the path: \(path)")
        }

        var stringFiles: [String: LocalizableStringsFile] = [:]
        var baseLprojs: [BaseLproj] = []
        FileManager.default.fileURLs(in: rootUrl).forEach() { url in
            if let stringFile = LocalizableStringsFile(url: url) {
                stringFiles[stringFile.lang] = stringFile
            }
            if let baseLproj = BaseLproj(url: url) {
                baseLprojs.append(baseLproj)
            }
        }
        return (stringFiles, baseLprojs)
    }

    private func makeLangStringsFiles(stringFiles: [String: LocalizableStringsFile], baseLprojs: [BaseLproj]) {
        let langs = Array(stringFiles.keys)
        baseLprojs.forEach { baseLproj in
            baseLproj.ibFiles.forEach { ibFile in
                print("generating *.strings file for \(ibFile.url.path)")
                let baseStringsFile = BaseStringsFile.make(ibFile: ibFile)
                defer { baseStringsFile.removeFile() }

                guard !baseStringsFile.isEmpty else { return }
                langs.forEach { lang in
                    guard let localizableStringsFile = stringFiles[lang] else { fatalError("Failed to find LANG in stringFiles: \(lang)") }
                    var langStringsFile = LangStringsFile(lang: lang, baseStringsFile: baseStringsFile)
                    langStringsFile.update(from: baseStringsFile, with: localizableStringsFile)
                    langStringsFile.save()
                }
            }
        }
    }
}

Ls2Xs.main()

// MARK: - StringsFiles

struct Localize {
    typealias Key = String
}
struct Localized {
    typealias Value = String
}

// MARK: LangStringsFile

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

// MARK: LocalizableStringsFile

final class LocalizableStringsFile {
    let url: URL
    let lang: String
    private(set) var keyValues: [Localize.Key: Localized.Value]

    init?(url: URL) {
        let lang = url.deletingLastPathComponent().deletingPathExtension().lastPathComponent
        guard url.lastPathComponent == "Localizable.strings"
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

// MARK: - FileManager

extension FileManager {
    func fileURLs(in url: URL) -> [URL] {
        let enumerator = FileManager.default.enumerator(at: url, includingPropertiesForKeys: [], options: .skipsHiddenFiles)

        var urls: [URL] = []
        while let url = enumerator?.nextObject() as? URL {
            urls.append(url)
        }
        return urls
    }
}
