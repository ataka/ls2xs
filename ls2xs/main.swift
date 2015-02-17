import Foundation

if Process.arguments.count == 2 {
    Target(path: Process.arguments[1])?.run()
} else {
    println("usage: ls2xs <path>")
}
