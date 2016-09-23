import Foundation

if CommandLine.arguments.count == 2 {
    Target(path: CommandLine.arguments[1])?.run()
} else {
    print("usage: ls2xs <path>")
}
