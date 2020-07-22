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
