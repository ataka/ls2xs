import Foundation
import ArgumentParser

struct Ls2Xs: ParsableCommand {
    static let configuration = CommandConfiguration(abstract: "A command line tool that updates .strings of .xib and .storyboard using Localizable.strings.",
                                                    version: Version.value)

    @Argument(help: "Path to target directory")
    var path: String

    @Option(name: .shortAndLong, help: "File name of *.strings file.")
    var stringsFile: String = "Localizable.strings"

    mutating func run() {
        let (stringFiles, baseLprojs) = collectingLocalizableStringsFilesAndBaseLprojs(in: path)
        makeLangStringsFiles(stringFiles: stringFiles, baseLprojs: baseLprojs)
    }

    private func collectingLocalizableStringsFilesAndBaseLprojs(in path: String) -> ([String: LocalizableStringsFile], [BaseLproj]) {
        let fileManager = FileManager.default
        let rootUrl = URL(fileURLWithPath: fileManager.currentDirectoryPath).appendingPathComponent(path)

        var stringFiles: [String: LocalizableStringsFile] = [:]
        var baseLprojs: [BaseLproj] = []
        fileManager.fileURLs(in: rootUrl).forEach() { url in
            if let stringFile = LocalizableStringsFile(name: stringsFile, url: url) {
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
