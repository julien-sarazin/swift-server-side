import PackageDescription

let package = Package(
        name: "Todolist-swift",
        dependencies: [
                .Package(url: "https://github.com/PerfectlySoft/Perfect-HTTPServer.git",
                        majorVersion: 2,
                        minor: 0)
        ]
)
