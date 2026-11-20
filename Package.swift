// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "LatvianMealPlanner",
    platforms: [
        .iOS(.v16)
    ],
    products: [
        .executable(name: "LatvianMealPlanner", targets: ["LatvianMealPlanner"])
    ],
    targets: [
        .executableTarget(
            name: "LatvianMealPlanner",
            path: "Sources"
        )
    ]
)
