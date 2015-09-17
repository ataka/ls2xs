import Foundation

if Process.arguments.count == 2 {
    Target(path: Process.arguments[1])?.run()
} else {
    print("usage: ls2xs <path>")
}
